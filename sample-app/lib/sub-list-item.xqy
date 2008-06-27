default element namespace="http://www.w3.org/1999/xhtml"
import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"
import module namespace dt="http://xqdev.com/dateparser" at "/dates/date-parser.xqy"

let $start := xs:integer(xdmp:get-request-field("start", "1"))

let $subid := if (xdmp:get-request-field("subid")) then xs:unsignedLong(xdmp:get-request-field("subid")) else ()
let $title := ""

let $ids-temp := 
    if ($subid)
    then
        let $t1 := xdmp:set($title, fn:concat(" ",fn:collection(feed:description())/feed:description[@subid=$subid]/feed:title/text()))
        return
        (for $i in fn:collection(feed:item())/feed:item[(@subid=$subid)]
        order by $i/feed:published descending
        return $i)[$start to ($start+49)]
    else 
        (for $i in fn:collection(feed:item())/feed:item
        order by $i/feed:published descending         
        return $i)[$start to ($start+100)]

let $ids :=
    for $i in $ids-temp
    let $sub-id := text{$i/@subid}
    let $item-id := text{$i/@id}
    let $item-uri := fn:concat("/feed/",$sub-id,"/item/",$item-id)
    let $item-dir := fn:concat($item-uri,"/")
        
    return <tr width='100%'>
               <td valign='top'  class="data-left" style='white-space:nowrap;'><a href='{$i/feed:link}'>{$i/feed:title/text()}</a></td>
               <td valign='top' class="data" align='center'><a href="sub-doc-item.xqy?id={xs:string($i/@id)}&ver=true&subid={xs:string($i/@subid)}">{fn:count(xdmp:directory($item-dir))}</a></td>
               <td valign='top' class="data" style='white-space:nowrap;' align='center'>
                        { try {
                              let $d := $i/feed:published (:fn:adjust-dateTime-to-timezone(xs:dateTime($i/feed:published), xdt:dayTimeDuration("-PT8H")):)
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
                              fn:concat( "DATE ERROR:",$i/feed:published/text())
                          }
                        }</td>
               <td valign='top' class="data" style='white-space:nowrap;'><a href="item-description.xqy?id={$i/@id}">View Detail</a></td>
               <td valign='top' class="data-left" style='white-space:nowrap;'><a href="sub-list-sub.xqy?id={xs:string($i/@subid)}">{fn:collection(feed:description())/feed:description[@id=$i/@descid]/feed:title/text()}</a></td>
               <td valign='top' class="data"><a href="sub-doc-sub.xqy?id={xs:string($i/@subid)}">sub-doc</a></td>
               <td valign='top' class="data"><a href="sub-doc-desc.xqy?id={xs:string($i/@descid)}">desc-doc</a></td>
               <td valign='top' class="data"><a href="sub-doc-item.xqy?id={xs:string($i/@id)}">item-doc</a></td>
           </tr>

return
<html>
    <head>
    <link rel="stylesheet" href="../style/feed.css" type="text/css"></link>
    </head>
    <body>
        <h2 style="float:left;">TOTAL ITEMS {fn:concat(if ($subid) then fn:concat(" FROM ", fn:collection(feed:description())/feed:description[@subid=$subid]/feed:title/text(),": ",xdmp:estimate(fn:collection(feed:item())/feed:item[(@subid=$subid)]) )  else fn:concat(": ",xdmp:estimate(fn:collection(feed:item())) )  )}</h2>
        <span style="float:right;"><a href="sub-list-item.xqy?subid={$subid}&start={if (($start - 50) < 1) then 1 else ($start - 50)}">prev 50</a>&nbsp;-&nbsp;<a href="sub-list-item.xqy?subid={$subid}&start={$start + 50}">next 50</a>
        </span>
        <table width="100%" style="float:left;">
            <tr style='white-space:nowrap;'><td class="list-left">Title</td><td class="list">Versions</td><td class="list">Published</td><td class="list">Detail</td><td class="list-left">Subscription</td><td class="list">Subscription Doc</td><td class="list">Description Doc</td><td class="list">Item Doc</td></tr>
            {$ids}
        </table>
    </body>
</html>