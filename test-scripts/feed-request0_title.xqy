import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $url := xdmp:get-request-field("url")

let $res :=
try {
    (: we need to use http here in order to follow redirects - try whatever encoding the document uses :)
    xdmp:http-get($url,
                   <options xmlns="xdmp:http">
                       <format xmlns="xdmp:document-get">xml</format>
                       <repair xmlns="xdmp:document-get">full</repair>
                       <encoding xmlns="xdmp:document-get">UTF-8</encoding>
                   </options>
                   )[2]
    } catch ($e) {
        $e
    }
    
return feed:feed-title($res)