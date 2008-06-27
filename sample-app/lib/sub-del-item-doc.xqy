import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $items := fn:doc()/feed:item

let $t1 :=
    for $i in $items
    let $t := xdmp:document-delete(xdmp:node-uri($i))
    return $t
    
return "all items deleted via document access"