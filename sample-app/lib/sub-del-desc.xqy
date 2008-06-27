import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $t1 := xdmp:collection-delete(feed:description())
    
return "all descriptions deleted"