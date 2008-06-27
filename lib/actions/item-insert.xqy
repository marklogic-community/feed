(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

define variable $item-uri as xs:string external
define variable $item-doc as node() external
define variable $item-col1 as xs:string external
define variable $item-col2 as xs:string external

xdmp:document-insert(
     $item-uri,
     $item-doc,
     xdmp:default-permissions(),
     if ($item-col1 = "")
     then xdmp:default-collections()
     else ($item-col1, $item-col2)
)
