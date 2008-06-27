import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $feeds := xdmp:http-get("http://localhost/lib/feed/test-scripts/data/opml.xml")//outline/@xmlUrl

let $result :=
    for $f in $feeds
        let $t1 := 
            try {
                feed:unsubscribe(xs:string($f))
            } catch ($e) {
                $e
            }
        return $t1

return $result