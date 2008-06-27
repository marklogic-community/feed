import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $url := xdmp:get-request-field("url")

let $feed := feed:request($url)[2]

return feed:feed-published($feed)