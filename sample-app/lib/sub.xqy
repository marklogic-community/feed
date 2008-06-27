import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $url := xdmp:get-request-field("url")
let $num := xdmp:get-request-field("num")

let $result := 
try {
    feed:subscribe($url)
} catch ($e) {
    $e
}

return ("subscribed to feed: ", $url)