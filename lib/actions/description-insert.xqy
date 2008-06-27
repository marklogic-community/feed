(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

define variable $desc-uri as xs:string external
define variable $desc-doc as node() external
define variable $desc-col as xs:string external

xdmp:document-insert(
     $desc-uri,
     $desc-doc,
     xdmp:default-permissions(),
     if ($desc-col = "")
     then xdmp:default-collections()
     else $desc-col
)
