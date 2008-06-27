import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $subs := fn:doc()/feed:subscription

let $t1 :=
    for $s in $subs
    let $t:= xdmp:document-delete(xdmp:node-uri($s))
    return $t
    
return "all subscriptions deleted via document access"