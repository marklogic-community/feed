import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $id := xs:unsignedLong(xdmp:get-request-field("id"))
let $archive := xdmp:get-request-field("archive", "false")

let $feed := fn:collection(feed:subscription())/feed:subscription[@id=$id]

let $url := $feed/feed:reference/text()
let $dom := $feed/feed:domain/text()

let $result := 
try {
    feed:unsubscribe($url,
                    <options xmlns="feed">
                        <domain>{$dom}</domain>
                        <archive>{$archive}</archive>
                    </options>)
} catch ($e) {
    $e
}

return ("unsubscribed from feed:",$url," ", "domain: ", $dom, " ", "archive: ", $archive, " ", $result)