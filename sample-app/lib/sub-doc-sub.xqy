import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $id := xdmp:get-request-field("id", "")

return
if ($id != "")
then fn:doc()/feed:subscription[@id=xs:unsignedLong($id)]
else fn:doc()/feed:subscription