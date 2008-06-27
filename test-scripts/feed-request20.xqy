
let $url := xdmp:get-request-field("url")

let $res :=
try {
    (: we need to use http here in order to follow redirects - try whatever encoding the document uses :)
    xdmp:http-get($url,
                   <options xmlns="xdmp:http">
                       <format xmlns="xdmp:document-get">text</format>
                       <encoding xmlns="xdmp:document-get">UTF-8</encoding>
                   </options>
                   )
    } catch ($e) {
        $e
    }
    
return xdmp:tidy($res[2],
                    <options xmlns="xdmp:tidy">
                      <input-xml>yes</input-xml>
                      <tidy-mark>no</tidy-mark>
                      <show-warnings>no</show-warnings>
                      <show-errors>0</show-errors>
                      <force-output>yes</force-output>
                    </options>)[2]