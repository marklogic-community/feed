(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

import module namespace feed="http://marklogic.com/xdmp/feed" at "../feed.xqy"

define variable $id as xs:unsignedLong external
define variable $count as xs:integer external

(: removes the item documents from a subscription that is limiting the total number of items to store :)
let $items := 
        for $i in fn:collection(feed:item())/feed:item[@subid=$id]
        order by $i/feed:published descending
        return $i

return     
    for $m at $c in $items
    return     
        if ($c > $count)
        then xdmp:document-delete(fn:concat("/feed/",$id,"/item/",text{$m/@id}))
        else ()