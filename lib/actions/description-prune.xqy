(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

define variable $desc-uri as xs:string external

(: Atom namespace :)
declare namespace atom="http://www.w3.org/2005/Atom"
declare namespace atompurl="http://purl.org/atom/ns#"
(: RDF Namespaces :)
declare namespace rdfns="http://my.netscape.com/rdf/simple/0.9/"
declare namespace purl="http://purl.org/rss/1.0/"

(: find all of the entry/item elements and remove each one :)
let $doc := fn:doc($desc-uri)
for $i in ($doc//rss/channel/item, $doc//purl:item, $doc//rdfns:item, $doc//atom:entry, $doc//atompurl:entry)
return xdmp:node-delete($i)
