import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"
declare namespace qm = "http://marklogic.com/xdmp/query-meters"

(: checks the subscriptions to determine what feeds should be requested - requests those feeds :)
define function subscription-check() as item()*{
    for $sub in fn:collection(feed:subscription())/feed:subscription[@status != $feed:SS-UNSUB]
        let $dur-curr :=
            (: if the status is ok, get the time delta :)
            if ($sub/@status = $feed:SS-SUB)
            then
                try {
                    fn:current-dateTime() - xs:dateTime($sub/@last-requested)
                } catch ($e) {
                   xdt:dayTimeDuration("PT0S")
                }
            (: if it is processing and due, try it again :)
            else if ($sub/@status = $feed:SS-PROC)
            then    
                try {
                    (: can't do anything, coudl still be new :)
                    if ($sub/@last-requested = "0")
                    then xdt:dayTimeDuration("PT0S")
                    (: it is due :)
                    else if ( (fn:current-dateTime() - xs:dateTime($sub/@last-requested)) > 
                         (xdt:dayTimeDuration(fn:concat("PT",$sub/feed:frequency/text(),"S") )) )
                    then fn:current-dateTime() - xs:dateTime($sub/@last-requested)
                    else xdt:dayTimeDuration("PT0S")
                } catch ($e) {
                   let $t1 := xdmp:log(($e)) return
                   xdt:dayTimeDuration("PT0S")
                }
              (: if it is not in the SS-SUB state return 0, forcing it not to check
               - if it errored on the last attempt,
               or is in the new state, or it's last requested is the new state
               TODO: add an option to auto retry along with how long to wait in addition
               to the freq before retrying 
            :)
            else if ( ($sub/@status = $feed:SS-ERR) or  
                     ($sub/@status = $feed:SS-NEW) or ($sub/@last-requested = $feed:LR-NEW) )
            then
                (: TODO: any retry code goes here :)
                xdt:dayTimeDuration("PT0S")
            else
                xdt:dayTimeDuration("PT0S")
    
        return
            if ( $dur-curr >= xdt:dayTimeDuration(fn:concat("PT",$sub/feed:frequency/text(),"S")))
            then
                try {
                    (
                        (: set thte status - this wil be set by sub-req but only after it comes off of the queue :)
                        xdmp:invoke(
                            '../../lib/txn/subscription-status.xqy',
                            (xs:QName("sub-id"),$sub/@id,
                             xs:QName("sub-stat"),$feed:SS-PROC)
                        ) 
                        ,
                        xdmp:spawn(
                             '../../lib/subscription-request.xqy',
                            (xs:QName("sub-id"),xs:unsignedLong(text{$sub/@id}))
                         )
                     )
                } catch ($e) {
                    (: this is a major error - log it :)
                    xdmp:log(("SUBSCRIPTION-CHECK ERROR: ", xs:unsignedLong(text{$sub/@id}),$e))
                }
            else
                ()             
}



let $start-time := xdmp:query-meters()/qm:elapsed-time
let $time := fn:current-dateTime()
let $t1 := subscription-check()
let $stop-time := xdmp:query-meters()/qm:elapsed-time

return 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="refresh" content="630"/>
    </head>
    <body>
        {("subscriptions checked and requested at : ", $time)}
        <br/>
        {("duration: ", ($stop-time - $start-time) )}
    </body>
</html>



