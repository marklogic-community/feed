default element namespace="http://www.w3.org/1999/xhtml"

import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $url := xdmp:get-request-field("url")
let $num := xdmp:get-request-field("num")

let $id := if(xdmp:get-request-field("id")) then xs:unsignedLong(xdmp:get-request-field("id")) else ()



let $result := 
try {
    if ($id)
    then (fn:collection(feed:item())/feed:item[@id=$id])[1]/feed:detail/text()
    else
        let $feed := feed:request($url)[2]
        return feed:item-description(feed:feed-item($feed, xs:integer($num)))
} catch ($e) {
    $e
}

return 
<html>
    <body>
        DESCRIPTION HTML:<br/>
        {try {
                       if ($result)
                       then xdmp:unquote($result, xs:string(""),(xs:string("repair-full"),xs:string("format-xml")) ) 
                       else ()
                   } catch ($e) {
                       try {
                           xdmp:tidy($result,
                               <options xmlns="xdmp:tidy">
                                  <tidy-mark>no</tidy-mark>
                                  <show-warnings>no</show-warnings>
                                  <show-errors>0</show-errors>
                                  <force-output>yes</force-output>
                              </options>)[2]
                       } catch ($e) {
                           ("ERROR: ", $e, "DESC: ", $result)
                       }
                   }
             }
           <br/><br/>
           DESCRIPTION TEXT:<br/>
           {$result}
    </body>
</html>