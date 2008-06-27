default element namespace="http://www.w3.org/1999/xhtml"
import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $desc := fn:collection(feed:description())//feed:description

let $ids := 
    for $i in $desc
        let $sub-id := text{$i/@subid}
        let $desc-id := text{$i/@id}
        let $desc-uri := fn:concat("/feed/",$sub-id,"/description/",$desc-id)
        let $desc-dir := fn:concat($desc-uri,"/")
        
    order by try {xs:dateTime($i/feed:published)} catch ($e) {xs:dateTime("1971-01-01T00:00:00Z")} descending
    return 
        <tr width='100%'>
            <td valign='top'> <a href="sub-doc-sub.xqy?id={text{$i/@subid}}"> {text{$i/@subid}} </a></td>
            <td valign='top'> <a href="sub-doc-desc.xqy?id={text{$i/@id}}"> {text{$i/@id}} </a></td>
            <td valign='top' align='center'><a href="sub-doc-desc.xqy?id={xs:string($i/@id)}&ver=true&subid={xs:string($i/@subid)}">{fn:count(xdmp:directory($desc-dir))}</a></td>
            <td valign='top' style='white-space:nowrap;'>{$i/feed:type/text()}</td>
            <td valign='top' style='white-space:nowrap;'>{$i/feed:title/text()}</td>
            <td valign='top'>{$i/feed:published/text()}</td>
            <td valign='top' width='150'>
                <a href="{$i/feed:link/text()}">{$i/feed:link}</a>
            </td>
            <td valign='top' style='white-space:nowrap;'>{$i/feed:detail/text()}</td>
         </tr>
 
return
<html>
    <body>
        <h3>{fn:concat("TOTAL DESCRIPTIONS: ", fn:count($desc))}</h3>
        <table width="100%">
            <tr><td>SUBID</td><td>DESC ID</td><td>VERSIONS</td><td>TYPE</td><td>TITLE</td><td>PUBLISHED</td><td>LINK</td><td>DESCRIPTION</td></tr>
            {$ids}
        </table>
    </body>
</html>