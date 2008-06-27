import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $result := 
try {
    fn:count(fn:collection(feed:item()))
} catch ($e) {
    $e
}

return $result