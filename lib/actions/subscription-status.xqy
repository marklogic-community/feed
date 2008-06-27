(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

import module namespace feed="http://marklogic.com/xdmp/feed" at "../feed.xqy"

define variable $sub-id as xs:unsignedLong external
define variable $sub-stat as xs:string external

xdmp:node-replace(fn:collection(feed:subscription())/feed:subscription[@id = $sub-id]/@status, attribute status {$sub-stat})
