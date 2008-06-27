default element namespace="http://www.w3.org/1999/xhtml"
import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $subid := xdmp:get-request-field("subid", "")
let $title := ""

let $items := 
    if ($subid != "")
    then
        let $t1 := xdmp:set($title, fn:concat(" ",fn:collection(feed:description())/feed:description[@subid=$subid]/feed:title/text()))
        return (for $i in fn:collection(feed:item())/feed:item[@subid=$subid] order by $i/feed:published descending return $i)[1 to 100]
    else (for $i in fn:collection(feed:item())/feed:item order by $i/feed:published descending return $i)[1 to 100]


let $ids-order := 
    for $i in $items
    order by try {xs:dateTime($i/feed:published)} catch ($e) {xs:dateTime("1971-01-01T00:00:00Z")} descending
    return $i
    
let $ids :=
    for $i in $ids-order[1 to 100]
    
    let $sub-id := text{$i/@subid}
    let $item-id := text{$i/@id}
    let $item-uri := fn:concat("/feed/",$sub-id,"/item/",$item-id)
    let $item-dir := fn:concat($item-uri,"/")
        
    return <tr width='100%'>
               <td valign='top'><a href="sub-doc-sub.xqy?id={xs:string($i/@subid)}">{xs:string($i/@subid)}</a></td>
               <td valign='top'><a href="sub-doc-item.xqy?id={xs:string($i/@id)}">{xs:string($i/@id)}</a></td>
               <td valign='top' align='center'><a href="sub-doc-item.xqy?id={xs:string($i/@id)}&ver=true&subid={xs:string($i/@subid)}">{fn:count(xdmp:directory($item-dir))}</a></td>
               <td valign='top' style='white-space:nowrap;'>{$i/feed:title/text()}</td>
               <td valign='top'>{$i/feed:published}</td>
               <td valign='top' style='overflow:hidden;'><a href='{$i/feed:link}'>{$i/feed:link}</a></td>
               <td valign='top' style='white-space:nowrap;'><a href="item-description.xqy?id={$i/@id}">HTML</a> {$i/feed:detail/text()}</td>
           </tr>

(: try {
                       if ($i/feed:detail/text())
                       then xdmp:unquote($i/feed:detail/text(), xs:string(""),(xs:string("repair-full"),xs:string("format-xml")) ) 
                       else ()
                   } catch ($e) {
                       try {
                           xdmp:tidy($i/feed:detail/text(),
                               <options xmlns="xdmp:tidy">
                                  <tidy-mark>no</tidy-mark>
                                  <show-warnings>no</show-warnings>
                                  <show-errors>0</show-errors>
                                  <force-output>yes</force-output>
                              </options>)[2]
                       } catch ($e) {
                           ("ERROR: ", $e, "DESC: ", $i/feed:detail/text())
                       }
                       }
                    :) 

return
<html>
    <body>
        {if ($title != "") then <h3>{$title}</h3> else ()}
        <h3>{fn:concat("TOTAL ITEMS: ", fn:count($items))}</h3>
        <table width="100%">
            <tr><td>SUB ID</td><td>ITEM ID</td><td>VERSIONS</td><td>TITLE</td><td>PUBLISHED</td><td>LINK</td><td>DESCRIPTION</td></tr>
            {$ids}
        </table>
    </body>
</html>