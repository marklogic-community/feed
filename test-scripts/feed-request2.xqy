
let $url := xdmp:get-request-field("url")

return
try {
    (: we need to use http here in order to follow redirects - try whatever encoding the document uses :)
    xdmp:http-get($url,
                   <options xmlns="xdmp:http">
                       <format xmlns="xdmp:document-get">xml</format>
                       <repair xmlns="xdmp:document-get">full</repair>
                       <encoding xmlns="xdmp:document-get">GB2312</encoding>
                   </options>
                   )
    } catch ($e) {
        $e
    }