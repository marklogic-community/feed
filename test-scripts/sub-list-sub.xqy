default element namespace="http://www.w3.org/1999/xhtml"
import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $subs := fn:collection(feed:subscription())//feed:subscription

let $overdue :=  0
let $failed :=   0
let $inactive := fn:count(fn:collection(feed:subscription())//feed:subscription[@active='false'])


let $ids := 
    for $i in $subs
    order by xs:dateTime($i/@created)
        return
        <tr width='100%'>
        <td valign='top'><a href="sub-doc-sub.xqy?id={text{$i/@id}}">{text{$i/@id}}</a></td>
        <td valign='top'><a href="sub-doc-desc.xqy?id={text{fn:collection(feed:description())/feed:description[@subid=$i/@id]/@id}}">{text{fn:collection(feed:description())/feed:description[@subid=$i/@id]/@id}}</a></td>
        <td valign='top' align='center'>{text{$i/@active}}</td>
        <td valign='top' align='center'>{$i/feed:versioning/text()}</td>
        <td valign='top' align='center'>{$i/feed:item-store/text()}</td>
        <td valign='top' align='center'>
            <a href="sub-list-item.xqy?subid={$i/@id}">
                {
                    let $ic := fn:count(fn:collection(feed:item())/feed:item[@subid=$i/@id])
                    return  if ($ic = 0)
                            then <b>{$ic}</b>
                            else $ic 
                }
            </a>
        </td>
        <td valign='top'>{text{$i/@created}}</td>
        <td valign='top'>{text{$i/@last-requested}}</td>
        <td valign='top' align='center' >{$i/feed:frequency/text()}</td>
        <td valign='top' align='center' style='white-space:nowrap;'>
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
                        if ($secs > xs:int($i/feed:frequency/text()))
                        then 
                            let $x1 := xdmp:set($overdue, $overdue + 1)
                            return <b>{$secs}</b>
                        else $secs
            } catch ($e) {
                let $x2 := xdmp:set($failed, $failed + 1) 
                return ()
            }
            return $t1
        }
        </td>
        
        <td valign='top' style='white-space:nowrap;'><a href="{$i/feed:reference/text()}">{$i/feed:reference/text()}</a></td>
        <td valign='top' style='white-space:nowrap;'><a href="{$i/feed:reference-preferred/text()}">{$i/feed:reference-preferred/text()}</a></td>
        <td valign='top'>{$i/feed:domain/text()}</td>
        <td valign='top'>{$i/feed:redirects/text()}</td>
        <td valign='top'>
        </td></tr>
return
<html>
    <body>
        <table>
        <tr>
            <td>
                <h2>{fn:concat("TOTAL SUBSCRIPTIONS: ", fn:count($subs))}</h2>
                <h3>{fn:concat("SUBSCRIBED: ", fn:count($subs)-($overdue)-($failed)-($inactive))}</h3>
                <h3>{fn:concat("OVERDUE: ", $overdue)}</h3>
                <h3>{fn:concat("FAILED: ", $failed)}</h3>
                <h3>{fn:concat("INACTIVE: ", $inactive)}</h3>
            </td>
            <td>
                <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:{fn:count($subs)-($overdue)-($failed)-($inactive)},{$overdue},{$failed},{$inactive}&chs=300x100&chl={fn:count($subs)-($overdue)-($failed)-($inactive)} Subscribed|{$overdue} Overdue|{$failed} Failed|{$inactive} Inactive"/>
            </td>
         </tr>
         </table>
            

        <table width="100%">
            <tr><td>SUB ID</td><td>DESC ID</td><td>ACTIVE</td><td>VERSIONING</td><td>ITEM STORE</td><td>TOTAL ITEMS</td><td>CREATED</td><td>LAST REQUEST</td><td>FREQUENCY</td><td>TIME SINCE REQUEST</td><td>REFERENCE</td><td>PREFERRED REFERENCE</td><td>DOMAIN</td><td>REDIRECT</td></tr>
            {$ids}
        </table>
    </body>
</html>