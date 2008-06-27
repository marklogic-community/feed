(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

module "http://marklogic.com/xdmp/feed"

import module namespace dt="http://xqdev.com/dateparser" at "/dates/date-parser.xqy"


(: 
::   See README.txt for information on requirements, configuration, and performance
:)

(: XHTML, Marklogic HTTP, and feed namespace :)
declare namespace feed = "http://marklogic.com/xdmp/feed"
declare namespace reqopt="feed"
declare namespace mlht="xdmp:http"
declare namespace tidy = "xdmp:tidy"
declare namespace xhtml="http://www.w3.org/1999/xhtml"

(: Atom namespace :)
declare namespace atom="http://www.w3.org/2005/Atom"
declare namespace atompurl="http://purl.org/atom/ns#"

(: RDF Namespaces :)
declare namespace dc="http://purl.org/dc/elements/1.1/"
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
declare namespace rdfns="http://my.netscape.com/rdf/simple/0.9/"
declare namespace purl="http://purl.org/rss/1.0/"
declare namespace content="http://purl.org/rss/1.0/modules/content/"


(: 
::  Global Variables
:)

(: configurable global variables :)
define variable $TEMP-DIR {"/var/tmp/"}
define variable $DEBUG {fn:false()}

(: subscripiton state :)
define variable $LR-NEW  {"0"}
define variable $SS-NEW  {"new"}
define variable $SS-SUB  {"subscribed"}
define variable $SS-UNSUB  {"unsubscribed"}
define variable $SS-PROC  {"processing"}
define variable $SS-ERR  {"error"}

(: public collections :)
define variable $COL-SUB  {"/feed/subscription"}
define variable $COL-DESC {"/feed/description"}
define variable $COL-ITEM {"/feed/item"}

(: subscription variables :)
define variable $REDIRECTS-DEFAULT {5}
define variable $FREQUENCY-DEFAULT {3600}
define variable $ITEM-STORE-ALL {"all"}
define variable $ITEM-STORE-CURRENT {"current"}
define variable $ITEM-STORE-DEFAULT {$ITEM-STORE-CURRENT}
define variable $DOMAIN-DEFAULT {""}
define variable $VERSIONING-DEFAULT {"false"}
define variable $ARCHIVE-DEFAULT {"false"}

(: language encodings :)
define variable $UTF8 {"UTF-8"}
define variable $ISO {"ISO-8859-1"} (: aka Latin-1 :)
define variable $GB {"GB2312"}
define variable $GBK {"GBK"}
define variable $CHARSETS{($UTF8,$ISO,$GB,$GBK)}


(:
:: Feed Public API
:)

(: 
:: feed:request(
::    $feed-reference as xs:string,
::    [$options as node()])
:: as item()+ 
::	
:: Summary:
::
::	Requests the feed document located at $feed-reference.
::	Returns the url that was ultimately used to access the document and the response of the request.
::	
:: Parameters:
::
::	$feed-reference: the URL of the feed to be requested.
::	
::	$options (optional): the options node for the request.
::	The default value is ().
::	The options node must be in the "feed" namespace.
::	
::	The feed:request options include:
::	
::	<redirects>: The number of HTTP redirect directives to follow before giving up.
::	Values can be an integer 0 or greater.
::	The default value is 5.
::	
:: Usage Notes:
::
::	feed:request uses xdmp:http-get to retrieve the document at $feed-reference. If successful it will return a sequence
::	containing the teh actual URL used to retrieve teh document and the resulting document. The actual URL and $feed-request
::	will be different if there is a redirection during the request.
::	
::	If the document is successfully retrieved but there are errors processing the xml, feed-request will attempt to fix the xml
::	by using xdmp:tidy.
::
::	Some feed documents may fail to be processed. This is typically caused by a poorly formatted feed document.
::	e.g. an XML document that does not have close tags after the last feed item. In this case feed:request will
::	return it's best attempt at accessing the text of the document. It does this by trying three langauge encodings
::	in the following order: UTF-8, ISO-8859-1, and GB2312.
::	
:: Example:
::	
::	feed:request("http://feeds.engadget.com/weblogsinc/engadget",
::   	            <options xmlns="feed">
::                      <redirects>3</redirects>
::                    </options>
::                 )[2]
::	=> the latest feed document from http://feeds.engadget.com/weblogsinc/engadget
:)
define function request($feed-reference as xs:string)
as item()+ {
	request($feed-reference,
	            <options xmlns="feed">
                    <redirects>5</redirects>
                </options>
            )
}

define function request($feed-reference as xs:string,
                        $options as node())
as item()+  {
	(:  text that was url encoded may have been unencoded when passed in
	    look for specific letters that need to be re-encoded
	    the following characters are re-encoded: space :)
	let $feed-reference-norm := fn:replace(fn:normalize-space($feed-reference),' ', '%20')
	
	(: parse the options :)
	let $redirects :=
	    try {
	        if (xs:integer($options/reqopt:redirects/text()) < 0)
	        then $REDIRECTS-DEFAULT
	        else xs:integer($options/reqopt:redirects/text())
	    } catch ($e) {
	        $REDIRECTS-DEFAULT
	    } 

	(: get the feed document :)
    let $doc-http := doc-request-http($feed-reference-norm)
	
    (: see what the server told us - good, redirected, unknown etc... :)
	let $code := $doc-http[1]/mlht:code/text()
	return
		if ( $code = ('200', '201', '202', '203', '204', '205', '206') )
		then ($feed-reference-norm, parse-doc-http($feed-reference-norm, $doc-http) )
		(: 301 and 302  = moved permanently FUTURE: change the preferred address of the doc:)
		else if ( $code = ('300', '301', '302', '303', '304', '305', '306', '307') ) 
		then follow-redirect($feed-reference-norm, $redirects, $doc-http)
		else if ( $code = ('400', '401', '402', '403', '404', '405', '406','407', '408', '409', '410',
		                   '411', '412', '413','414', '415', '416', '417') )
		then ($feed-reference-norm, $doc-http[1])
		(: 503 = Service Unavailable - currently puts status in description document - FUTURE: Create error document :)
		else if ( $code = ('500', '501', '502', '503', '504', '505') )
		then ($feed-reference-norm, $doc-http[1])
		else ($feed-reference-norm, $doc-http[1])
}


(:
:: feed:subscribe(
::     $feed-reference as xs:string,
::     [$options as node()])
:: as empty() 
::	
:: Summary:
::	
::  Creates a subscription to the feed document located at $feed-reference.
::	Returns ().
::	
:: Parameters:
::	
::  $feed-reference: the URL of the feed to be requested.
::	
::	$options (optional): the options node for the request.
::	The default value is ().
::	The options node must be in the "feed" namespace.
::	
::	The feed:request options include:
::	
::	<domain>: The domain this subscription is part of in the context of this server.
::	Domain can be used to differentiate between subscriptions sharing the same $feed-reference
::	and  to group subscriptions together.
::	Values can be any string.
::	The default value is "".
::	
::	<redirects>: The number of HTTP redirect directives to follow before giving up.
::	Values can be an integer 0 or greater.
::	The default value is 5.
::	
::	<versioning>: Determines whether or not different versions of the feed document elements will be stored.
::	If versioning is true, items that have changed from one request of a feed document to the next will be stored
::	with the most recent version being used. The same is true teh feed document meta data. If versioning is false
::	the most recent version of the feed document elements are used.
::	Values can be 'true' or 'false'.
::	The default value is 'false'.
::	
::	<item-store>: Determines the number of items to store for this subscription at any point in time.
::	Values can be any integer n >= 0 which will store the most recent n items, 'all' which will store all items,
::   and 'current' which will store only the items found in the most recent request.
::    The default value Default is 'current'.
::
::	<frequency>: Determines the expected number of seconds between requests for the latest document.
::	Values can be any integer.
::	Default is 3600 which is equivalent to one hour.
::	
:: Usage Notes:
::	
::  feed:subscription uses feed:request to access the feed document.
::	It then creates multiple documents that are used to manage the subscription
::	and store the subscription content. The retrieved feed document is immediately stored
::	in the subscription document structure.
::	
::	All of the subscription documents exist in the "http://marklogic.com/xdmp/feed" namespace.
::	
::	subscription documents store all of the information needed to manage the subscription
::	such as the frequency at which the feed document should be requested. Each subscription 
::	document is determined to be unique based on the $feed-reference and the <domain> value.
::	This document provides references to the description and item documents assocaited with
::	the subscription. Subscription documents are stored in the collection provided by
::	feed:subscription().
::	
::	description documents store all of the metadata about the feed such as the feed title.
::	Description documents are stored in the collection accessed by feed:description().
::	If versioning is 'true' only th emost recent version of the document exists in the collection.
::	All versions of the document can be accessed through a directory specific to the subscription.
::	The directory form is /feed/<subscription-id>/description/<description-id>/
::	For example:
::	let $subid  := '1234567'
::	let $descid := '7654321'
::	let $versions := xdmp:directory(fn:concat('/feed/',$subid,'/description/',$id,'/')
::	returns all of the versions of the description document in the subscription with id '1234567' and
::	a description id of '7654321'
::	
::	item documents store the content of each item from a feed document such as the description of the item
::	and the link to the original item.
::	item documents are stored in the collection accessed by item:description().
::	If versioning is 'true' only the most recent version of the document exists in the collection.
::	All versions of the document can be accessed through a directory specific to the subscription.
::	The directory form is /feed/<subscription-id>/item/<item-id>/
::	For example:
::	let $subid  := '1234567'
::	let $itemid := '7654321'
::	let $versions := xdmp:directory(fn:concat('/feed/',$subid,'/item/',$id,'/')
::	returns all of the versions of the item document in the subscription with id '1234567' and
::	an item id of '7654321'
::	
::	Examples:
::	
::	feed:subscribe("http://feeds.engadget.com/weblogsinc/engadget",
::   	            <options xmlns="feed">
::                        <domain>example</domain>
::                        <frequency>600</frequency>
::                        <item-store>all</item-store>
::                        <versioning>true</versioning>
::                        <redirects>3</redirects>
::                    </options>)
::	=> ()
:)
define function subscribe($feed-reference as xs:string) 
as empty() {                       
    subscribe(
        $feed-reference,
        <options xmlns="feed"></options>
    )                       
}


define function subscribe($feed-reference as xs:string,
                          $options as node())
as empty() {
    let $ts := 
        xdmp:set($feed-reference, fn:normalize-space($feed-reference))

    let $sub-domain :=
        if ($options/reqopt:domain/text())
        then $options/reqopt:domain/text()
        else $DOMAIN-DEFAULT

    let $sub-redirects :=
        if ($options/reqopt:redirects/text())
        then xs:integer($options/reqopt:redirects/text())
        else $REDIRECTS-DEFAULT

    let $sub-ver :=
        if ($options/reqopt:versioning/text())
        then $options/reqopt:versioning/text()
        else $VERSIONING-DEFAULT

    let $sub-store :=
        if ($options/reqopt:item-store/text())
        then $options/reqopt:item-store/text()
        else $ITEM-STORE-DEFAULT
        
    let $sub-freq :=
        if ($options/reqopt:frequency/text())
        then $options/reqopt:frequency/text()
        else $FREQUENCY-DEFAULT
    
    (: undocumented :)    
    let $make-request :=
        if ($options/reqopt:make-request/text())
        then $options/reqopt:make-request/text()
        else 'true'
           
    (: create the data we will use to define the subscription document and location of document :)
    let $sub-id := sub-id($feed-reference,$sub-domain)
    let $sub-created := fn:current-dateTime()
    let $sub-uri := fn:concat("/feed/",$sub-id)
    
    (: create the subscription document entry
       document-insert automatically replaces the document if it already exists :)
    let $sub-doc := 
        <subscription 
                xmlns="http://marklogic.com/xdmp/feed"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="/C/WIP/dshlt/marklogic/feed/schema/feed.xsd"
                id="{$sub-id}" created="{$sub-created}" last-requested="{$LR-NEW}" status="{$SS-NEW}">
            <reference>{$feed-reference}</reference>
            <reference-preferred/>
            <domain>{$sub-domain}</domain>
            <redirects>{$sub-redirects}</redirects> 
            <versioning>{$sub-ver}</versioning>
            <item-store>{$sub-store}</item-store>
            <frequency>{$sub-freq}</frequency>
        </subscription>

     let $t1 :=
        xdmp:invoke(
            'actions/subscription-insert.xqy',
            (xs:QName("sub-uri"),$sub-uri,
             xs:QName("sub-doc"),$sub-doc,
             xs:QName("sub-col"),$COL-SUB)
        )
         
     let $t2 :=
         if ($make-request = 'true') 
         then    xdmp:spawn(
                 'actions/subscription-request.xqy',
                (xs:QName("sub-id"),$sub-id)
             )
         else ()
     
    return ()
}

(:
:: feed:unsubscribe(
::    $feed-reference as xs:string,
::    [$options as node()])
::  as empty() 
::	
:: Summary:
::
::	Unsubscribes to the feed document located at $feed-reference that is part of 
::	domain provided as an option.
::	Returns ().
::	
:: Parameters:
::
::	$feed-reference: the URL of the feed to be unsubscribed from.
::	
::	$options (optional): the options node for the request.
::	The default value is ().
::	The options node must be in the "feed" namespace.
::	
::	The feed:request options include:
::	
::	<domain>: The domain this subscription is part of in the context of this server.
::	Values can be any string.
::	The default value is ().
::	
::	<archive>: Determines whether to maintain the <description> and <item> documents
::	associated with this subscription. If the documents are maintained and a subscription
::	is created to the same $feed-reference and <domain> in the future, the maintained documents
::	will be available to the new subscription.
::	Values can be 'true' which maintains the documents, or 'false' which deletes the documents.
::	The default value is 'false'.
::	
:: Usage Notes:
::
:: Examples:
::	
::	feed:unsubscribe("http://feeds.engadget.com/weblogsinc/engadget",
::   	            <options xmlns="feed">
::                        <domain>example</domain>
::                        <archive>true</archive>
::                    </options>)
::	=> ()
:)
define function unsubscribe($feed-reference as xs:string) 
as empty() {
    unsubscribe(
        $feed-reference,
        <options xmlns="feed">
            <domain></domain>
            <archive>false</archive>
        </options>
    )
}


define function unsubscribe($feed-reference as xs:string,
                            $options as node())
as empty() {
    let $sub-domain :=
        if ($options/reqopt:domain/text())
        then $options/reqopt:domain/text()
        else $DOMAIN-DEFAULT

    let $sub-archive :=
        if ($options/reqopt:archive/text())
        then $options/reqopt:archive/text()
        else $ARCHIVE-DEFAULT
    
    let $sub-id := sub-id($feed-reference, $sub-domain)
    let $sub-doc := fn:doc(fn:concat("/feed/",$sub-id))
    
    let $t1 := xdmp:node-replace($sub-doc/feed:subscription/@status, attribute status { $SS-UNSUB })
    
    return
        if ($sub-archive = "false")
        then xdmp:collection-delete(fn:concat("/feed/",$sub-id,"/item"))
        else ()  
}

(:
:: feed:subscription()
:: xs:string*
::	
:: Summary:
::	
::  Returns the subscription collections as a sequence of strings. Currently only
::	one collection is used to store the subscription documents.
::	
:: Usage Notes:
::
:: Examples:
::	
::	fn:collection(feed:subscription())
::	=> The documents in the subscription collection
:)
define function subscription()
as xs:string* {
    $COL-SUB
}

(:
:: feed:description()
:: xs:string*
::	
:: Summary:
::	Returns the description collections as a sequence of strings. Currently only
::	one collection is used to store the description documents.
::	
:: Usage Notes:
::
:: Examples:
::	
::	fn:collection(feed:description())
::	=> The documents in the description collection
:)
define function description()
as xs:string* {
    $COL-DESC
}

(:
:: feed:item()
:: xs:string*
::	
:: Summary:
::	Returns the item collections as a sequence of strings. Currently only
::	one collection is used to store the global set of item documents.
::	
:: Usage Notes:
::
:: Examples:
::	
::	fn:collection(feed:item())
::	=> The documents in the item collection
:)
define function item() as xs:string* {
    $COL-ITEM
}





(:
:: Private Functions
:)

(: 
::   feed:request() Utilities
::
::   when accessing feeds via text, the order in which
::   encoding is attempted when forced may create a false match
::   e.g. the encoding of ISO may match a GB encoded doc - ouch!
::   check the actual string and provide the correct encoding if needed
:)

define function parse-doc-http($feed-reference as xs:string, $doc-http as item()*) {
(: manage the quality of xml and the encoding of the xml :)
    (: KNOWN ISSUE: if the document is encoded in a non UTF-8 encoding and the xml is broken,
       ML will treat it as UTF-8, ignoring the encoding, and failing when there is a chance the xml could be fixed :)
    (: attempt encoding in this order: HTTP HEADER ENCODING, FORCED XML ISO-8859-1 ,XML DOC BASED ENCODING, TEXT UTF-8, TEXT ISO-8859-1, TEXT GB2312 :)
	let $res-text :=  
	    try {
    	     let $TEMP-FILE := xs:string(xdmp:hash64(fn:concat($feed-reference,fn:current-dateTime())))   
    	     let $doc-save := doc-write-temp($TEMP-FILE, $doc-http[2])
            
             (: get the encoding from the http header :)
             let $cont-type-http := http-encoding-check($doc-http)
             let $enc :=
                 if ($cont-type-http) 
                 then $cont-type-http
                 else ()           
            
             let $doc := 
                 try {
                     if ($enc)
                     then
                         (: grab the saved document with the heading we found or UTF8 as default :)
                         doc-request-text-enc(fn:concat($TEMP-DIR,$TEMP-FILE), $enc)                     
                     else doc-request-text-enc(fn:concat($TEMP-DIR,$TEMP-FILE), $UTF8)
                 } catch ($e) {
                     (: UTF8 may have been forced- try ISO - at the least we may be able to get the encoding :)
                     let $doc-iso := doc-request-text-enc(fn:concat($TEMP-DIR,$TEMP-FILE), $ISO)
                    (: check to see if the document encoding matches what we just tried :)
                     let $enc-text := text-encoding-check($doc-iso)
                     (: if correct return the doc, if not try all other encodings :)
                     return
                         if ($enc-text)
                         then 
                             (: if it is ISO, just return the ISO :)
                             if ($enc-text = $ISO)
                             then $doc-iso
                             else 
                                try {
                                    doc-request-text-enc(fn:concat($TEMP-DIR,$TEMP-FILE), $enc-text)
                                } catch ($e) {
                                    (: this is an awful case where it declares utf-8 encoding but uses ISO characters
                                       so need to return the ISO version :)
                                    $doc-iso   
                                }
                         else $doc-iso
                 }
             return ($doc-http[1],$doc) 
        } catch ($e) {
            (: major error - log no matter what:)
            xdmp:log(("PARSE DOC HTTP ERROR: FAILED TO ACCESS THE DOCUMENT FROM FILE STORE",$e))
        }
            
    let $res-xml :=
        try {
            xdmp:unquote($res-text[2])
        } catch ($e) {
            try {
                xdmp:tidy(
                    xdmp:quote($res-text[2]),
                    <options xmlns="xdmp:tidy">
                      <input-xml>yes</input-xml>
                      <tidy-mark>no</tidy-mark>
                      <show-warnings>no</show-warnings>
                      <show-errors>0</show-errors>
                      <force-output>yes</force-output>
                    </options>
                )[2]
            } catch ($e) {
                (: ouch - we have failed in our mission - log it no matter what and kick out the straight text :)
                let $log := xdmp:log(("PARSE DOC HTTP ERROR: FAILED TO CREATE XML FROM FEED DOCUMENT: ", $e))
                return $res-text[2]
            }
        }
         
    let $res := ($res-text[1], $res-xml)
    return $res-xml
}

define function follow-redirect($feed-reference as xs:string, $redirects as xs:integer, $doc-http as item()*) {
    if ($redirects > 0)
    then 
        (: get or create the proper redirect url depending on whether a full or relative was provided :)		    
        request(
            url-rel-to-full($feed-reference, $doc-http[1]/mlht:headers/mlht:location/text()) ,
             <options xmlns="feed">
                <redirects>{$redirects - 1}</redirects>
             </options>
         )
    else ()
}

define function http-encoding-check($res as item()*) {
    (: multiple content-type headers are possible:)
    let $val :=
        fn:string-join(
            for $i in $res[1]/mlht:headers/mlht:content-type/text()
                return
                    fn:upper-case (
                        fn:replace (
                            fn:substring-after($i,"charset="),
                            '&quot;',
                            ''
                        )
                    ),
                    ""
                )
    
    let $charset :=
        for $ce in $CHARSETS
        return
            if (fn:contains($val, $ce))
            then $ce
            else ()
        
    let $t1 := if ($DEBUG) then xdmp:log((fn:concat("http-encoding-check FOUND: ",$charset[1]))) else ()

    return $charset[1]

}

define function text-encoding-check($text as xs:string) {
    let $encodings :=
        for $ce in $CHARSETS
        return (fn:concat('encoding="',$ce,'"'))

    (: when checking for this text, linux ML may give a bad code paoint iterator error when incompatible encodings :)
    let $ enc :=
        for $en at $c in $encodings
        return
            if (try {fn:contains($text, $en) or fn:contains($text, fn:lower-case($en))} catch ($e) {()})
            then $CHARSETS[$c]
            else ()
    
    let $t1 := if ($DEBUG) then xdmp:log((fn:concat("text-encoding-check FOUND: ",$enc))) else ()   
    
    return $enc[1]
}

(: helpers for http and doc requests :)
define function doc-request-http($feed-reference as xs:string) as item()* {
    try {
         http-request-bin($feed-reference)
     } catch ($e) {
         (: encoding type may have quotes around it - stops ML processing :)
         (: head request fails too - force a winner by forcing the encoding :)
         (: not getting any contents so will not impact processing :)
         let $t1 := if ($DEBUG) then xdmp:log(("FAILED http-request-bin: ",$e)) else () 
         return
         try {
             let $http-head :=
                 xdmp:http-head(
                     $feed-reference,
                     <options xmlns="xdmp:http">
                       <encoding xmlns="xdmp:document-get">{$UTF8}</encoding>
                     </options>
                 )
             let $encoding := http-encoding-check($http-head[1])   	             
             return
                 http-request-text-enc($feed-reference, $encoding)
         } catch ($e) {
             let $t1 := if ($DEBUG) then xdmp:log(("FAILED http-request-text-enc $enc: ",$e)) else ()
             return
             try {
                 http-request-text-enc($feed-reference, $ISO)
             } catch ($e) {
                 let $t1 := if ($DEBUG) then xdmp:log(("failed http-request-text-enc ISO: ",$e)) else ()
                 (: major error - could not even get the document - log no matter what :)
                 let $log := xdmp:log(("FAILED TO MAKE INITIAL HTTP REQUEST",$e))
                 return $e
             }
         }
     }
}

define function http-request-bin ($feed-reference) {
    xdmp:http-get(
        $feed-reference,
        <options xmlns="xdmp:http">
           <format xmlns="xdmp:document-get">binary</format>
        </options>   
       )
}


define function http-request-text-enc ($feed-reference, $enc) {
    xdmp:http-get(
        $feed-reference,
        <options xmlns="xdmp:http">
           <format xmlns="xdmp:document-get">text</format>
           <encoding xmlns="xdmp:document-get">{$enc}</encoding>
        </options>   
       )
}


define function doc-request-text-enc ($ref, $enc) {
    xdmp:document-get(
        $ref,
        <options xmlns="xdmp:document-get">
           <format>text</format>
           <encoding>{$enc}</encoding>
        </options>   
       )
}


define function doc-write-temp($file as xs:string, $data as item()) {     
    try {
     xdmp:save(fn:concat($TEMP-DIR,$file), $data)            
    } catch ($e) {
     (: another major error - log no matter what :)
     xdmp:log(("FAILED TO SAVE DOC",$e))
    }
}
(: 
::   feed:subscribe() Utilities
:)
(: generates the id for the subscription :)
define function sub-id($feed-reference, $sub-domain) as xs:unsignedLong{
    xdmp:hash64(fn:concat($feed-reference,$sub-domain))
}


define function subscription-request($sub-id as xs:unsignedLong) {
    let $time := fn:current-dateTime()
    let $sub-uri := fn:concat("/feed/",$sub-id)
    let $sub-doc := fn:doc($sub-uri)

    let $t1 :=
        xdmp:invoke(
            'actions/subscription-status.xqy',
            (xs:QName("sub-id"),$sub-doc/feed:subscription/@id,
             xs:QName("sub-stat"),$SS-PROC)
        )


    (: get the feed-reference :)
    let $feed-reference := $sub-doc/feed:subscription/feed:reference/text()
                             
    (: check item storage :)
    let $item-store := $sub-doc/feed:subscription/feed:item-store/text()
    
    (: check versioning :)
    let $versioning :=
        if ($sub-doc/feed:subscription/feed:versioning/text())
        then $sub-doc/feed:subscription/feed:versioning/text()
        else "false"   

    (: get the latest feed document :)
    let $url := 
        if ($sub-doc/feed:subscription/feed:reference-preferred/text())
        then $sub-doc/feed:subscription/feed:reference-preferred/text()
        else $feed-reference
    let $req := request($url)

    let $req-doc := $req[2]
    let $feed-reference-pref := $req[1]
    let $feed-type := feed-type($req-doc)
    
    let $desc-id := xdmp:hash64(fn:concat($sub-id))
     
    return    
        (process-desc-doc($req-doc, $feed-reference, $feed-type, $time, $versioning, $sub-id, $desc-id),
         process-item-doc($req-doc, $feed-reference, $feed-type, $time, $versioning, $sub-id, $desc-id, $item-store),
         process-sub($feed-reference-pref, $sub-id, $time)
        ) 
        
}


define function process-desc-doc ($req-doc as item(),
                                  $feed-reference as xs:string,
                                  $feed-type as xs:string, 
                                  $time as xs:dateTime, 
                                  $versioning as  xs:string,
                                  $sub-id as xs:unsignedLong,
                                  $desc-id as xs:unsignedLong) {
    (:set-up uri and directories :)
    let $desc-uri := fn:concat("/feed/",$sub-id, "/description/", $desc-id)
    let $desc-dir := fn:concat($desc-uri,"/")
    
    (: prune the req-doc to just the description :)
    (: temporarily insert and prune the RAW description :)
    let $desc-uri-temp := fn:concat($desc-uri,"/temp")
    let $t1-desc-temp :=
        xdmp:invoke(
            'actions/description-insert.xqy',
            (xs:QName("desc-uri"),$desc-uri-temp,
             xs:QName("desc-doc"),<description-temp xmlns="http://marklogic.com/xdmp/feed">{$req-doc}</description-temp>,
             xs:QName("desc-col"),$COL-DESC)
        )  

        let $t2-desc-temp := 
            xdmp:invoke(
                'actions/description-prune.xqy',
                (xs:QName("desc-uri"),$desc-uri-temp)
            )
            
        let $desc-doc-pruned := 
            xdmp:invoke(
                'actions/description-get.xqy',
                (xs:QName("desc-uri"),$desc-uri-temp)
            )/feed:description-temp/*          
         
    (: compare the version of the docs :)
    let $desc-ver := 
        if ($versioning = "true")
        then         
            
            (: create the directory if needed :)                      
            let $dc := 
                xdmp:invoke("actions/directory-create.xqy",
                            (xs:QName("dir"),$desc-dir)
                            )

            let $docs := 
                for $d in xdmp:directory($desc-dir)/feed:description 
                order by $d/@version descending
                return $d
              
            return
                let $num :=
                    if (fn:count($docs) = 0)
                    then 1
                    else
                        (: get the most recent one via version :)
                        (: compare the raw doc to what we have :)
                        (: if same do nothing, if different, incr version number and continue :)                                        
                        let $ver := $docs[1]/@version
                        return
                            if ($docs[1]/feed:raw-description/text() = xdmp:quote($desc-doc-pruned))
                            then $ver
                            else ($ver + 1)
                let $clean := 
                    xdmp:invoke("actions/document-delete.xqy",
                            (xs:QName("doc"),$desc-uri-temp)
                    )
                return $num
        else 1   

        (: check the feed links elements for a valid value, up to 3 :)
        let $feed-link :=
            let $fl := feed-link($req-doc, 1)
            return
                if ($fl = "")
                then 
                    let $fl2 := feed-link($req-doc, 2)
                    return
                        if ($fl2 = "")
                        then
                            let $fl3 := feed-link($req-doc, 3)
                            return
                                $fl3
                        else $fl2 
                else $fl
    
        (: we must have a time value for the feed published date :)
        let $feed-pub := 
            if (feed-published($req-doc))
            then feed-published($req-doc)
            else $time
        
        let $desc-doc :=     
            <description xmlns="http://marklogic.com/xdmp/feed"
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="/C/WIP/dshlt/marklogic/feed/schema/feed.xsd"
                      id="{$desc-id}"
                      subid="{$sub-id}"
                      version="{$desc-ver}"
                      created="{$time}"
                      updated="{$time}">
                <type>{$feed-type}</type>
                <title>{feed-title($req-doc)}</title>
                <link>{url-rel-to-full($feed-reference, $feed-link)}</link>
                <icon>{feed-icon(url-rel-to-full($feed-reference, $feed-link))}</icon>
                <detail>{feed-description($req-doc)}</detail>
                <published>{$feed-pub}</published>
                <raw-description>{xdmp:quote($desc-doc-pruned)}</raw-description>
             </description>

        (: insert the description document :)
        let $t1-desc-insert :=
            xdmp:invoke(
                'actions/description-insert.xqy',
                (xs:QName("desc-uri"),$desc-uri,
                 xs:QName("desc-doc"),$desc-doc,
                 xs:QName("desc-col"),$COL-DESC)
            )

        (: remove item/entry elements from the description document :)             
        let $t2-desc-prune :=
            xdmp:invoke(
                'actions/description-prune.xqy',
                (xs:QName("desc-uri"),$desc-uri)
            )

        (: if we are versioning, insert a copy in the version directory:)
        (: use desc-doc-ver variable, inserting as fn:doc($desc-uri) fails in some cases:) 
        let $t3-desc-ins-ver :=
            if ($versioning = "true")
            then
                xdmp:invoke(
                    'actions/description-insert-uri.xqy',
                    (xs:QName("desc-uri"),fn:concat($desc-dir,$desc-ver),
                     xs:QName("desc-doc-uri"),$desc-uri,
                     xs:QName("desc-col"),"")
                )              
            else ()    
         return ()         
}


define function process-item-doc($req-doc as item(), 
                                 $feed-reference as xs:string,
                                 $feed-type as xs:string,
                                 $time as xs:dateTime,
                                 $versioning as xs:string,
                                 $sub-id as xs:unsignedLong,
                                 $desc-id as xs:unsignedLong,
                                 $item-store as xs:string) {
    let $req-items := feed-items($req-doc)
    (: create the item collection for just this subscription - only used internally :)
    let $sub-item-col := fn:concat("/feed/",$sub-id,"/item")
    
    (: check the item store, if 'current' remove existing items :)
    let $item-store-delete :=
        if ($item-store = $ITEM-STORE-CURRENT)
        then 
            (: execute via eval to avoid conflict with this query :)
            xdmp:eval(fn:concat("xdmp:collection-delete('",$sub-item-col,"')"))
        else ()
    
    let $t2-item-insert :=
        for $i in $req-items
            let $item-id := item-id($feed-reference, $i)
            let $item-uri := fn:concat("/feed/",$sub-id,"/item/",$item-id)
            let $item-dir := fn:concat($item-uri,"/")
            
            let $item-version :=
                try {
                    if ($versioning = "true")
                    then 
                        (: create the directory if needed :)                      
                        let $dc := 
                            xdmp:invoke(
                                "actions/directory-create.xqy",
                                (xs:QName("dir"),$item-dir)
                            )
                        let $docs := 
                            for $d in xdmp:directory($item-dir)/feed:item 
                            order by $d/@version descending
                            return $d
                        return
                            if (fn:count($docs) = 0)
                            then 1
                            else
                                (: get the most recent one via version :)
                                (: compare the raw doc to what we have :)
                                (: if same do nothing, if different, incr version number and continue :)                                        
                                let $ver := $docs[1]/@version
                                return
                                    if ($docs[1]/feed:raw-item/text() = xdmp:quote($i))
                                    then $ver
                                    else ($ver + 1)
                    else 1
                } catch ($e) {
                    (: conflicting updates if identical items - log it - not a failure error :)
                    xdmp:log(("LOGGED ERROR ITEM INSERT: ", fn:concat("SUB ID: ",$sub-id), fn:concat("ITEM ID: ",$item-id), fn:concat("ERROR CODE: ", $e/err:code) ))
                }           
            (: if the item is not versioned and already exists get the original creation date for this item :)
            let $create-time :=
                if (($versioning = "false") and (fn:doc($item-uri)/feed:item) )
                then fn:doc($item-uri)/feed:item/@created
                else $time
                
            (: get the correct published date or use current time if non-existent :)
            let $item-pub := 
                let $ip := item-published($i)
                return
                    if ($ip)
                    then $ip
                    else $time
            
            (: create the item doc :)
            let $item-doc :=
                <item id="{$item-id}" descid="{$desc-id}" subid="{$sub-id}"
                       version="{$item-version}"
                       created="{$create-time}"
                       updated="{$time}"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="/C/WIP/dshlt/marklogic/feed/schema/feed.xsd"
                       xmlns="http://marklogic.com/xdmp/feed">
                    <type>{$feed-type}</type>
                    <title>{item-title($i)}</title>
                    <link>{url-rel-to-full($feed-reference,item-link($i))}</link>
                    <detail>{item-description($i)}</detail>
                    <published>{$item-pub}</published>
                    <raw-item>{xdmp:quote($i)}</raw-item>
                 </item>
            
            return
                try {
                    (: insert the item document - comparing the _entire_ raw document takes longer than writing it
                       so just write the document ~30% faster just writing:)
                       let $t1-item-ins-cur :=
                        xdmp:invoke(
                            "actions/item-insert.xqy",
                            (xs:QName("item-uri"), $item-uri,
                             xs:QName("item-doc"), $item-doc,
                             xs:QName("item-col1"), $COL-ITEM,
                             xs:QName("item-col2"), $sub-item-col
                            )
                        )
                         
                    return 
                        if ($versioning = "true")
                        then
                        xdmp:invoke(
                            "actions/item-insert.xqy",
                            (xs:QName("item-uri"), fn:concat($item-dir,$item-version),
                             xs:QName("item-doc"), $item-doc,
                             xs:QName("item-col1"), "",
                             xs:QName("item-col2"), ""
                            )
                        )                            

                        else ()
                } catch ($e) {
                    (: identical items conflict - keep one - log - not a failure :)  
                    xdmp:log(("LOGGED ERROR ITEM INSERT: ", fn:concat("SUB ID: ",$sub-id), fn:concat("ITEM ID: ",$item-id), fn:concat("ERROR CODE: ", $e/err:code), $e))
                }

    (: if the item store is an integer, prune the older items :)
    return
        if ( ($item-store != $ITEM-STORE-CURRENT) and ($item-store != $ITEM-STORE-ALL) )
        then 
            try {
                xdmp:invoke(
                    'actions/item-prune.xqy',
                    (xs:QName("id"),$sub-id,
                     xs:QName("count"),xs:integer($item-store))
                )
            } catch ($e) {
                (: major problem - log it - not a failure:)
                xdmp:log(("LOGGED ERROR PRUNE: ", $e))
            }
         else ()
    
}

define function process-sub ($feed-reference-pref as xs:string,
                             $sub-id as xs:unsignedLong, 
                             $time as xs:dateTime) {
    (: update the subscription doc after the request :)
    (
        xdmp:invoke(
            'actions/subscription-reference-preferred.xqy',
            (xs:QName("sub-id"),$sub-id,
             xs:QName("sub-rp"),$feed-reference-pref)
        ) 
    ,
             
    (: update the subscription last-requested attribute :)
        xdmp:invoke(
            'actions/subscription-last-requested.xqy',
            (xs:QName("sub-id"),$sub-id,
             xs:QName("sub-lr"),$time)
        ) 
    ,
    
    (: update the subscription status attribute - catch in case we changed it to error earlier :)
           xdmp:invoke(
                'actions/subscription-status.xqy',
                (xs:QName("sub-id"),$sub-id,
                 xs:QName("sub-stat"),$SS-SUB)
            )
    )
}



(: 
::   Feed Description/MetaData Processing Utilities
:: 	 the following criteria in order is used to determine what type of feed document is being worked with
::	 RSS 2.0 and above - if the outermost element name is RSS and there is a version identifier
::   RSS 1.0 or earlier - if the outermost element name is RDF in the "http://www.w3.org/1999/02/22-rdf-syntax-ns#" namespace
::   Atom 1.0 - if the outermost elment name is FEED in the "http://www.w3.org/2005/Atom" namespace
::   Atom 0.3 - if the outermost element name is FEED in the "http://purl.org/atom/ns#" namespace
:)
define function feed-type($f as node()) as xs:string {
    (: rss 2.0 :)
    if ($f/rss/@version)
    	then fn:concat("rss ",$f/rss/@version)					
    (: rss 1.0 or earlier :)
    else if ($f/rdf:RDF)
    	then "rss 1.0/0.9x"
    (: atom 1.0:)
    else if ($f/atom:feed)
    	then "atom 1.0"
    (: atom pre 1.0 :)
    else if ($f/atompurl:feed)
    	then fn:concat("atom ", $f/atompurl:feed/@version)
    else "unknown"
}

define function feed-title($f as node()) as xs:string {
	(: rss 2.0 :)
	if ($f/rss)
		then if ($f/rss/channel/title/text())
		     then $f/rss/channel/title/text()
		     else ""					
	(: rss 1.0 or earlier :)
	else if ($f/rdf:RDF)
	    then if ($f/rdf:RDF/rdf:channel/rdf:title/text())
	    then $f/rdf:RDF/rdf:channel/rdf:title/text()
		else if ($f/rdf:RDF/purl:channel/purl:title/text())
		then $f/rdf:RDF/purl:channel/purl:title/text()
		else if ($f/rdf:RDF/rdfns:channel/rdfns:title/text())
		then $f/rdf:RDF/rdfns:channel/rdfns:title/text()
		else ""
	(: atom 1.0 :)
	else if ($f/atom:feed)
		then $f/atom:feed/atom:title/text()
    (: atom 0.3 :)
	else if ($f/atompurl:feed)
		then $f/atompurl:feed/atompurl:title/text()
	else ""
}

define function feed-link($f as node(), $pos as xs:integer) as xs:string {
    (: rss 2.0 :)
    if ($f/rss)
    then if ($f/rss/channel/link[$pos]/text())
         then $f/rss/channel/link/text()
         else ""					
    (: rss 1.0 or earlier:)
    else if ($f/rdf:RDF)
    then if ($f/rdf:RDF/purl:channel/purl:link[$pos]/text())
         then $f/rdf:RDF/purl:channel/purl:link/text()
         else if ($f/rdf:RDF/rdfns:channel/rdfns:link[$pos]/text())
         then $f/rdf:RDF/rdfns:channel/rdfns:link/text()
         else ""   
    (: atom 1.0:)
    else if ($f/atom:feed)
    then if ($f/atom:feed/atom:link[@rel='alternate']/@href)
    	 then xs:string(($f/atom:feed/atom:link[@rel='alternate']/@href)[$pos])
    	 else if ($f/atom:feed/atom:link/@href)
    	 then xs:string(($f/atom:feed/atom:link/@href)[$pos])
    	 else ""
    (: atom 0.3 :)
    else if ($f/atompurl:feed)
    then if ($f/atompurl:feed/atompurl:link[@rel='alternate']/@href)
         then xs:string(($f/atompurl:feed/atompurl:link[@rel='alternate']/@href)[$pos])
    	 else ""
    else ""
}


define function feed-description($f as node()) as xs:string {
    (: rss 2.0 :)
    if ($f/rss/channel/description/text())
    then $f/rss/channel/description/text()					
    (: rss 1.0 or earlier :)
    else if ($f/rdf:RDF/rdf:channel/rdf:description)
    then $f/rdf:RDF/rdf:channel/rdf:description/text()
    else if ($f/rdf:RDF/rdfns:channel/rdfns:description)
    then $f/rdf:RDF/rdfns:channel/rdfns:description/text()
    else if ($f/rdf:RDF/purl:channel/purl:description)
    then $f/rdf:RDF/purl:channel/purl:description/text()
    (: atom 1.0:)
    else if ($f/atom:feed/atom:subtitle)
    then $f/atom:feed/atom:subtitle/text()
    (: atom 0.3:)
    else if ($f/atompurl:feed/atompurl:tagline)
    then $f/atompurl:feed/atompurl:tagline/text()
    else ""
}

(: 
::   gets the date the feed was published
::   prefer dc:date to pubDate to lastBuildDate in RSS
::   prefer dc:date to atom:updated to atom:published in Atom 1.0
::   prefer dc:date to atom:modified in Atom pre 1.0
:)
define function feed-published($f as node()) as item()* {
	let $res := 
		(: rss 2.0 :)
		if ($f/rss)
		then
		    if ($f/rss/channel/dc:date)
		    then $f/rss/channel/dc:date/text()
		    else if ($f/rss/channel/pubDate)
		    then $f/rss/channel/pubDate/text()	    
		    else if ($f/rss/channel/lastBuildDate)
		    then $f/rss/channel/lastBuildDate/text()
		    else ()					
		(: rss 1.0 or earlier:)
		else if ($f/rdf:RDF)
		then
    	    if ($f/rdf:RDF/purl:channel/dc:date)
    		then $f/rdf:RDF/purl:channel/dc:date/text()
    		else if ($f/rdf:RDF/rdfns:channel/rdfns:pubDate)
    		then $f/rdf:RDF/rdfns:channel/rdfns:pubDate/text()
    		else ()
		(: atom 1.0 :)
		else if ($f/atom:feed)
		then 
		    if ($f/atom:feed/dc:date)
		    then $f/atom:feed/dc:date/text()
		    else if ($f/atom:feed/atom:updated)
		    then $f/atom:feed/atom:updated/text()
		    else ()
		(: atom 0.3 :)
		else if ($f/atompurl:feed)
		then
		    if ($f/atompurl:feed/dc:date)
		    then $f/atompurl:feed/dc:date/text()
		    else if ($f/atompurl:feed/atompurl:modified)
		    then $f/atompurl:feed/atompurl:modified/text()
		    else ()
		else
			()
    return 
        if ($res)
        then (convert-date(fn:normalize-space(fn:string-join($res,""))))
        else ()
}


define function item-count($f as node()) as xs:integer {
	if ($f/rss)
	then fn:count($f/rss/channel/item)			
	else if ($f/rdf:RDF/purl:item)
	then fn:count($f/rdf:RDF/purl:item)
	else if ($f/rdf:RDF/rdfns:item)
	then fn:count($f/rdf:RDF/rdfns:item)
	else if ($f/atom:feed)
	then fn:count($f/atom:feed/atom:entry)
	else if ($f/atompurl:feed)
	then fn:count($f/atompurl:feed/atompurl:entry)
	else 0
}

(: 
::   Feed Item Access Utilities
:)
(: return a sequence of all items :)
define function feed-items($f as node()) as item()* {
		if ($f/rss)
		then $f/rss/channel/item
		else if ($f/rdf:RDF/purl:item)
		then $f/rdf:RDF/purl:item
		else if ($f/rdf:RDF/rdfns:item)
		then $f/rdf:RDF/rdfns:item
		else if ($f/atom:feed)
		then $f/atom:feed/atom:entry
		else if ($f/atompurl:feed)
		then $f/atompurl:feed/atompurl:entry
		else ()
}


define function feed-item($f as node(), $item as xs:integer) as node() {
	(: handle a request for less than 1 item :)
	let $t1 := 
		if ($item < 1)
		then xdmp:set($item, 1)
		else ()
	
	(: get the item and handle a request for greater than the total number of available items :)
	return
		if ($f/rss)
		then
			let $max := fn:count($f/rss/channel/item)
			let $t2 := if ($item > $max) then xdmp:set($item, $max) else 1 
			return $f/rss/channel/item[$item]
		else if ($f/rdf:RDF)
		then if ($f/rdf:RDF/purl:item)
    	    then
    	        let $max := fn:count($f/rdf:RDF/purl:item)
    			let $t2 := if ($item > $max) then xdmp:set($item, $max) else 1 
    			return $f/rdf:RDF/purl:item[$item]
    		else if ($f/rdf:RDF/rdfns:item)
    		then
    			let $max := fn:count($f/rdf:RDF/rdfns:item)
    			let $t2 := if ($item > $max) then xdmp:set($item, $max) else 1 
    			return $f/rdf:RDF/rdfns:item[$item]
    		else ()
		else if ($f/atom:feed)
		then
			let $max := fn:count($f/atom:feed/atom:entry)
			let $t2 := if ($item > $max) then xdmp:set($item, $max) else 1 
			return $f/atom:feed/atom:entry[$item]
		else if ($f/atompurl:feed)
		then
			let $max := fn:count($f/atompurl:feed/atompurl:entry)
			let $t2 := if ($item > $max) then xdmp:set($item, $max) else 1 
			return $f/atompurl:feed/atompurl:entry[$item]
		else ()
}

(: 
::   Feed Item Data Utilities
:)
(: generate the item id :)
define function item-id ($ref as xs:string,$f as node() ) as xs:unsignedLong {
    let $i := 
        (: rss 2.0 and rss 1.0 or earlier - guid (2.0), ( link(both), title(both), description (2.0) ), ( link(both), title(both) ), description (2.0), item document(both) - in that order:)
        (: specifying first link and title due to inconsisten feeds :) 
         if (fn:local-name($f) = "item")
         then 
             if (($f/guid) and ($f/guid/text() != ""))
             then $f/guid/text()
             else if (($f/link) and ($f/title) and ($f/description) )
             then fn:concat($f/link[1]/text(),$f/title[1]/text(),$f/description[1]/text())
             else if (($f/link) and ($f/title) )
             then fn:concat($f/link[1]/text(),$f/title[1]/text())
             else if (($f/link[1]) and ($f/link[1]/text() != ""))
             then $f/link[1]/text()
             else if(($f/purl:link[1]) and ($f/purl:title))
             then fn:concat($f/purl:link[1]/text(), $f/purl:title[1]/text())
             else if(($f/purl:link[1]) and ($f/purl:link[1]/text() != ""))
             then $f/purl:link[1]/text()
             else if (($f/title) and ($f/title[1]/text() != ""))
             then $f/title[1]/text()
             else if (($f/purl:title) and ($f/purl:title[1]/text() != ""))
             then $f/purl:title[1]/text()
             else if (($f/description) and ($f/description[1]/text() != ""))
             then $f/description[1]/text()
             else xdmp:quote($f)
         (: atom 1.0 - id (both), title (both), item document (both) in that order :)
         else if (fn:local-name($f) = "entry")
         then
             if (($f/atom:id) and ($f/atom:id/text() != ""))
             then  $f/atom:id/text()
             else if (($f/atompurl:id) and ($f/atompurl:id/text() != ""))
             then  $f/atompurl:id/text()
             else if (($f/atom:title) and ($f/atom:title[1]/text() != ""))
             then $f/atom:title[1]/text()
             else if (($f/atompurl:title) and ($f/atompurl:title[1]/text() != ""))
             then $f/atompurl:title[1]/text()
             else xdmp:quote($f)
         else xdmp:quote($f)
   return xdmp:hash64(fn:concat($ref, $i))
}

define function item-title($f as node()) as item()* {  
    (: rss 2.0 and rss 1.0 or earlier :)
     if (fn:local-name($f) = "item")
     then 
         if ($f/title/text())
         then $f/title/text()
         else if ($f/purl:title/text())
         then $f/purl:title/text()
         else if ($f/rdfns:title/text())
         then $f/rdfns:title/text()
         else ""
     (: atom 1.0  and atom 0.3 :)
     else if (fn:local-name($f) = "entry")
         then 
             if ($f/atom:title/text())
             then $f/atom:title/text()
             else if ($f/atompurl:title/text())
             then
    		    if ($f/atompurl:title[@mode='escaped'])
    		    then xdmp:unquote($f/atompurl:title/text())
    		    else $f/atompurl:title/text()
             else ""
         else ""
}


define function item-link($f as node()) as xs:string {
     (: rss 2.0 and rss 1.0 or earlier :)
     if (fn:local-name($f) = "item")
     then 
         if ($f/link)
         then 
             if ($f/guid[@ispermalink="true"])
             then $f/guid/text()
             else $f/link[1]/text()
         else if ($f/purl:link)
              then $f/purl:link[1]/text()
              else if ($f/rdfns:link)
              then $f/rdfns:link[1]/text()
              else ""
     (: atom 1.0 and atom 0.3 :)
     else if (fn:local-name($f)="entry")
     then if ($f/atom:link[@rel="alternate"]/@href)
          then xs:string($f/atom:link[@rel="alternate"]/@href)
          else if ($f/atompurl:link[@rel="alternate"]/@href)
          then xs:string($f/atompurl:link[@rel="alternate"]/@href)
          else ""
     else ""
}


define function item-description($f as node()) as item()* {
    (: rss 2.0 and rss 1.0 or earlier :)
     if (fn:local-name($f) = "item")
     then 
         if ($f/description)
         then $f/description/text()
         else if ($f/purl:description)
         then $f/purl:description/text()
         else if ($f/rdfns:description)
         then $f/rdfns:description/text()
         else ""
     (: atom 1.0 and atom 0.3:)
     else if (fn:local-name($f)="entry")
     then 
         (: atom 1.0 :)
         if ($f/atom:content)
         then
             (: primary standard forms text and html are strings, xhtml is xml:)
             (: TBD support a src attribute for out of line content :)
             if ($f/atom:content[@type="xhtml"])
             then xdmp:quote($f/atom:content[@type="xhtml"])
             else if ($f/atom:content[@type="html"])
             then $f/atom:content[@type="html"]/text()
             else if ($f/atom:content[@type="text"])
             then $f/atom:content[@type="text"]/text()
             (: if no type, standard is to treat as type text :)
             else if ($f/atom:content/text())
             then $f/atom:content/text()
             (: non-standard but found in a live feed :)
             else if ($f/atom:content[@type="text/html"])
             then $f/atom:content[@type="text/html"]/text()
             (: if no type and the content is not text, then try to treat as XML/XHTML :)
             else if ($f/atom:content)
             then xdmp:quote($f/atom:content)
             else ""
         (: atom 0.3 :)
         else if ($f/atompurl:content)
         then
             if ($f/atompurl:content[@type="text/html"]/text())
             then $f/atompurl:content[@type="text/html"]/text()
             else if ($f/atompurl:content[@type="html"]/text())
             then $f/atompurl:content[@type="html"]/text()
             else if ($f/atompurl:content/text())
             then $f/atompurl:content/text()
             else ""
         (: if we can't find content, use the summary entry :)
         else if ($f/atom:summary)
         then
             if ($f/atom:summary[@type="html"])
             then $f/atom:summary[@type="html"]/text()
             else if ($f/atom:summary[@type="text/html"])
             then $f/atom:summary[@type="text/html"]/text()
             else if ($f/atom:summary[1])
             then $f/atom:summary[1]/text()
             else ""
         else if ($f/atompurl:summary)
         then                                                                                                                    
             if ($f/atompurl:summary[@type="html"])
             then $f/atompurl:summary[@type="html"]/text()
             else if ($f/atompurl:summary[@type="text/html"])
             then $f/atompurl:summary[@type="text/html"]/text()
             else if ($f/atompurl:summary[1])
             then $f/atompurl:summary[1]/text()
             else ""
         else ""
     else ""   
}

(: prefer dc:date to pubDate (also included rdf namespace pubDate) in RSS
   prefer dc:date to atom:updated to atom:published in Atom 1.0
   prefer dc:date to atom:modified to atom:issued to atom:created in pre Atom 0.3
   if there is no date the current date time is used - this date is required for indexing purposes
:)
define function item-published($f as node()) as xs:dateTime? {
   let $d :=
     (: rss 2.0 and rss 1.0 or earlier:)
     if (fn:local-name($f) = "item")
     then 
        if ($f/dc:date)
        then $f/dc:date/text()
        else if ($f/pubDate)
        then $f/pubDate/text()
        else if ($f/rdfns:pubDate)
    	then $f/rdfns:pubDate/text()	    
        else ()
     (: atom 1.0 and atom 0.3:)
     else if (fn:local-name($f)="entry")
     then
         if ($f/dc:date)
         then $f/dc:date/text()
         else if ($f/atom:updated)
         then $f/atom:updated/text()
         else if ($f/atom:published)
         then $f/atom:published/text()
         else if ($f/atompurl:modified)
         then $f/atompurl:modified/text()
         else if ($f/atompurl:issued)
         then $f/atompurl:issued/text()
         else if ($f/atompurl:created)
         then $f/atompurl:created/text()
         else ()
     else ()
     
     return 
        if ($d)
        then (convert-date(fn:concat($d,""))) (: sometimes comes through as an xs:dateTime :)
        else ()
}

define function feed-icon($url-site as xs:string)  {
	(: first try based on the standard favicon location :)
	(: break down the url to the domain   :)
        
    let $favlink := ""
    let $fav := "favicon.ico"

    let $l := fn:tokenize($url-site, "/")
    let $link := fn:concat($l[1],"//", $l[3], "/")

    (: try the basic domain link :)
    (: if moved, return the moved to location :)
    let $favreq1 := fn:concat($link, $fav)

    let $favlink :=
    try {
        let $t := xdmp:http-head($favreq1)
        return
    	if ( $t/mlht:code/text() = "200" )
    	then $favreq1
    	else if ( $t/mlht:code/text() = "302" )
    	then $t/mlht:headers/mlht:location/text()
    	else if ( $t/mlht:code/text() = "404" )
    	(: get the home page and look for the <link rel="shortcut icon" href ="ico location"/> and get the href value :)
    	then
    		let $html := xdmp:http-get($link)[2]
    		return
    		xdmp:quote(
    			(xdmp:tidy($html)[2])/xhtml:html/xhtml:head/xhtml:link[xdmp:quote(@rel) eq "shortcut icon"]/@href
    		)
    	else xs:string("")
    } catch($e) {
    	xs:string("")
    }
	return $favlink
} 

(: 
::   Miscellaneous Data Processing Utilities
:)
define function convert-date($date as xs:string) as xs:dateTime? {
        try {
            xs:dateTime($date)
        } catch ($e) {
            try {
                dt:parseDateTime($date)
            } catch ($e) {
                ()
            }
        }
}

(:  takes a fully qualified url and a url that might be full or relative
    returns the unknown url as a fully qualified url :)
define function url-rel-to-full ($full as xs:string, $rel as xs:string) as xs:string {
    if (fn:contains($rel, "http://"))
    then $rel
    else if (($rel = "") or ($rel = ()))
    then ""
    else
        let $pat := "((http:\/\/[^\/]+)?(\/[^\/]+)?)"
        let $dom := fn:replace($full, $pat, "$2")
        return fn:concat($dom, $rel)
}
