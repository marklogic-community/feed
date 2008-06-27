default element namespace="http://marklogic.com/xdmp/feed"
import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

(: STATISTICS SET-UP :)
let $subs := fn:collection(feed:subscription())//feed:subscription
let $sub-tot := fn:count($subs)

let $time := fn:current-dateTime()

(: SUBSCRIPTION STATUS VARIABLES :)
let $subscribed :=  fn:count(fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-SUB])
let $current := $subscribed
let $new :=  fn:count(fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-NEW])
let $proc :=  fn:count(fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-PROC])
let $due :=  0
let $err :=   fn:count(fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-ERR])
let $unsubscribed := fn:count(fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-UNSUB])

(: same numbers scaled :)

let $new-per := 0
let $proc-per := 0
let $current-per := 0
let $due-per := 0
let $err-per := 0 
let $unsubscribed-per := 0

let $sub-t1 := 
    for $i in $subs
        return
            if ($i/@status = $feed:SS-SUB)
            then 
                let $dur-curr := ($time - (xs:dateTime($i/@last-requested)))
                let $dur-limit := xdt:dayTimeDuration(fn:concat("PT",$i/feed:frequency/text(),"S"))
                return
                    if  ($dur-curr > $dur-limit)
                    then (xdmp:set($due, $due + 1), xdmp:set($current, $current - 1) )
                    else ()
            else "n/a"

(: scale subs numbers for chart - catch div by zero :)
let $sub-calc :=
    if ($sub-tot <= 0)
    then ()
    else
        (xdmp:set($current-per, ($current div ($sub-tot)) * 100),
         xdmp:set($new-per, ($new div ($sub-tot)) * 100),
         xdmp:set($proc-per, ($proc div ($sub-tot)) * 100),
         xdmp:set($due-per, ($due div ($sub-tot)) * 100),
         xdmp:set($err-per, ($err div ($sub-tot)) * 100 ),
         xdmp:set($unsubscribed-per, ($unsubscribed div ($sub-tot)) * 100)
        ) 

return
    <subs-status>
         <data>
             <subscribed>{$subscribed}</subscribed>
             <new>{$new}</new>
             <proc>{$proc}</proc>
             <unsubscribed>{$unsubscribed}</unsubscribed>
             <err>{$err}</err>
             <current>{$current}</current>    
             <due>{$due}</due>
         </data>
         <chart-url>
             http://chart.apis.google.com/chart?cht=p3&chd=t:{$new-per},{$proc-per},{$current-per},{$due-per},{$err-per},{$unsubscribed-per}&chs=400x150&chl={$new} New|{$proc} Processing|{$current} Sub-Current| {$due} Sub-Due|{$err} Error|{$unsubscribed} Unsubscribed
         </chart-url>
    </subs-status>