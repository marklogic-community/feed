import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $desc := (fn:doc()/feed:description, fn:doc()/feed:description-temp)

let $t1 :=
    for $d in $desc
    let $t := xdmp:document-delete(xdmp:node-uri($d))
    return $t
    
return "all descriptions deleted via document access"