import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $url := xdmp:get-request-field("url")
let $num := xdmp:get-request-field("num")

let $feed := feed:request($url)[2]

let $result := 
try {
    feed:item-link(feed:feed-item($feed, xs:integer($num)))
} catch ($e) {
    $e
}

return $result