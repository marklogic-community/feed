import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $url := xdmp:get-request-field("url")
let $domain := xdmp:get-request-field("domain", "")
let $freq := xdmp:get-request-field("freq", "")
let $store := xdmp:get-request-field("store", "current")
let $version := xdmp:get-request-field("version", "false")
let $redirects := xdmp:get-request-field("redirects", "5")

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
    xdmp:log($e)
}

return ("subscribed to feed ",
        fn:concat("url: ", $url),
        fn:concat("domain: ", $domain),
        fn:concat("frequency: ", $freq),
        fn:concat("item-store: ", $store),
        fn:concat("versioning: ", $version) )