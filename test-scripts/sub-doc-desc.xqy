import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $id := xdmp:get-request-field("id", "")
let $ver := xdmp:get-request-field("ver", "false")
let $subid := xdmp:get-request-field("subid", "")

return
if ($id != "")
    then
        if ($ver='true')
        then xdmp:directory(fn:concat('/feed/',$subid,'/description/',$id,'/'))
        else fn:collection(feed:description())/feed:description[@id=$id]
              
    else
        fn:doc()/feed:description