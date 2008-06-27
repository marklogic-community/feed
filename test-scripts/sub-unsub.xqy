import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $url := xdmp:get-request-field("url")
let $dom := xdmp:get-request-field("dom", "")
let $arch:= xdmp:get-request-field("arch", "false")

let $result := 
try {
    feed:unsubscribe($url,
                    <options xmlns="feed">
                        <domain>{$dom}</domain>
                        <archive>{$arch}</archive>
                    </options>)
} catch ($e) {
    $e
}

return ("unsubscribed from feed:",$url," ", "domain: ", $dom, " ", "archive: ", $arch, " ", $result)