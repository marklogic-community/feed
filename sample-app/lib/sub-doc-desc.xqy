
import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $id := if(xdmp:get-request-field("id")) then xs:unsignedLong(xdmp:get-request-field("id")) else ()
let $ver := xdmp:get-request-field("ver", "false")
let $subid := xdmp:get-request-field("subid", "")

return
if ($id)
    then
        if ($ver='true')
        then xdmp:directory(fn:concat('/feed/',$subid,'/description/',$id,'/'))
        else fn:doc()/feed:description[@id=$id]
              
    else
        fn:doc()/feed:description