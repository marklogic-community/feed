import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $domain := xdmp:get-request-field("domain", "")
let $freq := xdmp:get-request-field("freq", "")
let $store := xdmp:get-request-field("store", "current")
let $version := xdmp:get-request-field("version", "false")
let $redirects := xdmp:get-request-field("redirects", "5")

let $file := xdmp:get-request-field("file")

let $feeds := xdmp:document-get($file,
                                <options xmlns="xdmp:document-get">
                                    <format>xml</format>
                                    <repair>full</repair>
                                </options>)//outline/@xmlUrl

let $feeds2 := xdmp:document-get($file,
                                <options xmlns="xdmp:document-get">
                                    <format>xml</format>
                                    <repair>full</repair>
                                </options>)//outline/@xmlURL

let $result :=
    for $f in ($feeds, $feeds2)
        let $t1 := 
            try {
                feed:subscribe(xs:string($f),
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
        return $t1

return ("subscribed to opml file:",$file,$feeds, $feeds2, $result)