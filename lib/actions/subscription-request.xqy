(:
:: Copyright 2002-2008 Mark Logic Corporation.  All Rights Reserved. 
:: This software is licensed to you under the terms and conditions
:: specified at http://www.apache.org/licenses/LICENSE-2.0. If you
:: do not agree to those terms and conditions, you must cease use of
:: and destroy any copies of this software that you have downloaded. 
:)

import module namespace feed="http://marklogic.com/xdmp/feed" at "../feed.xqy"

declare namespace err="http://marklogic.com/xdmp/error"

(:
:: subscription-request (
::     $sub-id as xs:unsignedLong
:: )
::
:: feed/lib/subscription-request.xqy?sub-id=<$sub-id as xs:unsignedLong>
::
:: Summary
::     For an existing subscription, requests the latest updates the dscriotion and item documents.
::     This also manages versioning and the item store.
::
::     This query is called externally by the process used to trigger subscription requests.
::     From the API this query is called by feed:subscribe() through xdmp:spawn().
::     From the example application this query is called by /feed/admin/lib/subscription-check.xqy
::
:: Parameters:
::
::	$sub-id: the unsignedLong id of the subscription that will be updated. If the variable is passed
::  in through an http request, it is cast to an xs:unsignedLong
:)


(: get the subscription id from spawn/invoke or http :)
define variable $sub-id as xs:unsignedLong external

(: accept argument from either invoke or http request :)
let $sub-id-check-http :=
    try {
        if ($sub-id)
        then ()
        else
            let $sub-id-http := xdmp:get-request-field("subid")
            return xdmp:set($sub-id, xs:unsignedLong($sub-id-http))
    } catch ($e) {
        let $sub-id-http := xdmp:get-request-field("subid")
        return xdmp:set($sub-id, xs:unsignedLong($sub-id-http))
    }

return
    try {
       feed:subscription-request($sub-id)
    } catch ($e) {
        (: major error - log this :)
        let $log := xdmp:log($e)
        let $set-err := 
            xdmp:invoke(
                'subscription-status.xqy',
                (xs:QName("sub-id"),$sub-id,
                 xs:QName("sub-stat"),$feed:SS-ERR)
            )
        return $e
    }