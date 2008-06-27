default element namespace="http://www.w3.org/1999/xhtml"
import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"
import module namespace dt="http://xqdev.com/dateparser" at "/dates/date-parser.xqy"

let $sub-id := if (xdmp:get-request-field("id")) then xs:unsignedLong(xdmp:get-request-field("id")) else ()
let $sub-status := xdmp:get-request-field("status", "")

let $subs := 
    if ($sub-id)
    then fn:collection(feed:subscription())//feed:subscription[@id=$sub-id]
    else if ($sub-status)
    then fn:collection(feed:subscription())//feed:subscription[@status=$sub-status]
    else fn:collection(feed:subscription())//feed:subscription
    
let $ids := 
    for $i in $subs
    let $title := fn:collection(feed:description())/feed:description[@subid=$i/@id]/feed:title
    let $type := fn:collection(feed:description())/feed:description[@subid=$i/@id]/feed:type
    order by fn:normalize-space($title)
        return
        <tr width='100%'>
        <td valign='top' class="data-left" style='white-space:nowrap;'><a href="{text{fn:collection(feed:description())/feed:description[@subid=$i/@id]/feed:link/text()}}">{$title/text()}</a></td>
        <td class="data"  valign='top' style='white-space:nowrap;'>{$type}</td>
        <td class="data"  valign='top'>{text{$i/@status}}&nbsp;<a href="../../lib/subscription-request.xqy?subid={text{$i/@id}}" style="font-size:smaller;">req</a></td>
        <td class="data"  valign='top'>{$i/feed:versioning/text()}</td>
        <td class="data"  valign='top'>{$i/feed:item-store/text()}</td>
        <td class="data"  valign='top'>{$i/feed:domain/text()}</td>
        <td  class="data" valign='top'>
            <a href="sub-list-item.xqy?subid={$i/@id}">
                {
                    fn:count(fn:collection(feed:item())/feed:item[@subid=$i/@id])
                }
            </a>
        </td>
        <td class="data"  valign='top' style='white-space:nowrap;'>
        {
            let $t1 := try {
                if ($i/@active = "false")
                then "n/a"
                else
                    let $ diff := ((fn:current-dateTime()) - (xs:dateTime($i/@last-requested)))
                    let $s := xs:int(seconds-from-duration($diff))
                    let $m := minutes-from-duration($diff) * 60
                    let $h := hours-from-duration($diff) * 60 * 60
                    let $d := days-from-duration($diff) * 60 * 60 * 24
                    let $ secs := $s + $m + $h + $d
                    return
                        if ($secs > (xs:int($i/feed:frequency/text())) )
                        then <b>{$secs}</b>
                        else $secs
            } catch ($e) {
                ()
            }
            return $t1
        }
        </td>        
        <td class="data"  valign='top'>{$i/feed:frequency/text()}</td>
        <td class="data"  valign='top' style='white-space:nowrap;'>{
                        try {  
                          let $d :=  fn:adjust-dateTime-to-timezone($i/@last-requested, xdt:dayTimeDuration("-PT8H"))
                          return fn:concat(fn:hours-from-dateTime($d),
                                           ":",
                                   if (fn:minutes-from-dateTime($d) < 10) then fn:concat("0", xs:string(fn:minutes-from-dateTime($d))) else fn:minutes-from-dateTime($d),
                                           ", ",
                                           fn:month-from-dateTime($d),
                                           " ",
                                           fn:day-from-dateTime($d),
                                           " ",
                                           fn:year-from-dateTime($d))
                        } catch ($e) {
                            $i/@last-requested/text()
                        }
                        }</td>
        <td class="data-left"  valign='top' style='white-space:nowrap;'><a href="{$i/feed:reference/text()}">{$i/feed:reference/text()}</a></td>
        <td class="data-left"  valign='top' style='white-space:nowrap;'><a href="{$i/feed:reference-preferred/text()}">{$i/feed:reference-preferred/text()}</a></td>
        <td class="data"  valign='top'>{$i/feed:redirects/text()}</td>
        <td class="data"  valign='top'><a href="sub-doc-sub.xqy?id={text{$i/@id}}">sub doc</a></td>
        <td class="data"  valign='top'><a href="sub-doc-desc.xqy?id={(fn:collection(feed:description())/feed:description[@subid=$i/@id]/@id)[1]}">desc doc</a></td>
        <td class="data"  valign='top' style='white-space:nowrap;'>{
                        try {
                            let $d :=  fn:adjust-dateTime-to-timezone($i/@created, xdt:dayTimeDuration("-PT8H"))
                            return fn:concat(fn:hours-from-dateTime($d),
                                       ":",
                                       if (fn:minutes-from-dateTime($d) < 10) then fn:concat("0", xs:string(fn:minutes-from-dateTime($d))) else fn:minutes-from-dateTime($d),
                                       ", ",
                                       fn:month-from-dateTime($d),
                                       " ",
                                       fn:day-from-dateTime($d),
                                       " ",
                                       fn:year-from-dateTime($d))
                        } catch ($e) {
                            $i/@created/text()
                        }
                }</td>
        <td valign='top'>
        </td></tr>


return
<html>
    <head>
    <link rel="stylesheet" href="../style/feed.css" type="text/css"></link>
    </head>
    <body  LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">
        {if ($sub-id)
         then <h2>SUBSCRIPTION: {fn:collection(feed:description())/feed:description[@subid=$sub-id]/feed:title/text()}</h2>
         else
             let $res :=
             <span>
             <h2>{fn:concat("TOTAL", if ($sub-status) then fn:upper-case(fn:concat(" ",$sub-status)) else "" ," SUBSCRIPTIONS: ", fn:count($subs))}</h2>
             </span>
             return $res
         }
        <table width="100%" style="padding-left:2px;padding-right:2px">
            <tr valign='top' style="font-size:smaller;white-space:nowrap;"><td class="list-left" width="200px">Title</td><td class="list" >Type</td><td class="list" >Status</td><td class="list" >Versioned</td><td class="list" >Store Type</td><td class="list" >Domain</td><td class="list" >Number Items</td><td class="list" >Seconds Since Request</td><td>Request Frequency</td><td class="list" >Last Requested</td><td class="list-left" >Reference</td><td class="list-left" >Preferred Reference</td><td class="list" >Redirects</td><td class="list" >Subscription Doc</td><td class="list" >Description Doc</td><td class="list" >Created</td></tr>
            {$ids}
        </table>
    </body>
</html>