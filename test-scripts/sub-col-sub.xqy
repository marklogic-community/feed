import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"

let $id := xdmp:get-request-field("id", "")

return
if ($id != "")
then fn:collection(feed:subscription())/feed:subscription[@id=$id]
else fn:collection(feed:subscription())/feed:subscription