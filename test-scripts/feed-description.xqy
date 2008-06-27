default element namespace="http://www.w3.org/1999/xhtml"

import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $url := xdmp:get-request-field("url")
let $feed := feed:request($url)[2]

let $result := 
try {
    feed:feed-description($feed)
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