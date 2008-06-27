import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"
let $url := xdmp:get-request-field("url")
return feed:feed-title(xdmp:unquote(feed:http-request-text-enc($url, $feed:ISO)[2]))