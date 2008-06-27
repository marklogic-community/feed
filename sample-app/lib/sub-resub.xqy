import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $id := xs:unsignedLong(xdmp:get-request-field("id"))

let $feed := fn:collection(feed:subscription())/feed:subscription[@id=$id]

let $url := $feed/feed:reference/text()
let $domain := $feed/feed:domain/text()
let $freq := $feed/feed:frequency/text()
let $store := $feed/feed:item-store/text()
let $version := $feed/feed:versioning/text()
let $redirects := $feed/feed:redirects/text()

let $result := 
try {
    feed:subscribe($url,
                    <options xmlns="feed">
                        <domain>{$domain}</domain>
                        <frequency>{$freq}</frequency>
                        <item-store>{$store}</item-store>
                        <versioning>{$version}</versioning>
                        <redirects>{$redirects}</redirects>
                    </options>)
} catch ($e) {
    $e
}

return ("subscribed to feed ",
        fn:concat("url: ", $url),
        fn:concat("domain: ", $domain),
        fn:concat("frequency: ", $freq),
        fn:concat("item-store: ", $store),
        fn:concat("versionins: ", $version) )