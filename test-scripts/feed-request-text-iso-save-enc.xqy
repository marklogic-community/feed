import module namespace feed="http://marklogic.com/xdmp/feed" at "../lib/feed.xqy"
declare namespace mlht="xdmp:http"
let $url := xdmp:get-request-field("url")
let $doc-http := feed:http-request-text-enc($url, $feed:ISO)
let $TEMP-FILE := xdmp:hash64(fn:concat($url,fn:current-dateTime()))
let $doc-save := xdmp:save(fn:concat($feed:TEMP-DIR,$TEMP-FILE), $doc-http[2])

let $cont-type-text := feed:http-encoding-check($doc-http)
let $enc :=
if ($cont-type-text) 
then $cont-type-text
else ()

return feed:doc-request-text-enc(fn:concat($feed:TEMP-DIR,$TEMP-FILE), $enc)