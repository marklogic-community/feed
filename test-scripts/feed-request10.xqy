
let $url := xdmp:get-request-field("url")

return
try {
    (: we need to use http here in order to follow redirects - try whatever encoding the document uses :)
    xdmp:http-get($url,
                   <options xmlns="xdmp:http">
                       <format xmlns="xdmp:document-get">text</format>
                       <encoding xmlns="xdmp:document-get">UTF-8</encoding>
                   </options>
                   )[2]
    } catch ($e) {
        $e
    }