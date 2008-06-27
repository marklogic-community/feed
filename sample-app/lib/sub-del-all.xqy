import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $t1 := xdmp:collection-delete(feed:subscription())
let $t2 := xdmp:collection-delete(feed:description())
let $t3 := xdmp:collection-delete(feed:item())
    
return "all subscription documents (subscription, description, item) deleted"