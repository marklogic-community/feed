import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"
let $url := xdmp:get-request-field("url")
return feed:http-request-text-enc($url, $feed:ISO)