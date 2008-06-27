let $stat1 := "status-1"
let $stat2 := "status-2"
let $stat3 := "status-3"

let $temp := if (1 = 2) then xdmp:document-insert("fake.xml", <a/>) else ()

let $doc := <status-test status-att="status-0">
                <status-ele>status-0</status-ele>
            </status-test> 

let $t0 :=
try {
    xdmp:invoke(
        'txn-ins.xqy',
        (xs:QName("doc"),$doc),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
            <prevent-deadlocks>true</prevent-deadlocks>
        </options>
    )
} catch ($e) {
    $e
}
let $doc1 := fn:doc("/status-test")/status-test
let $res1 := fn:concat("original doc status: ", text{$doc1/@status-att}, $t0)

let $t1 :=
try {
    xdmp:invoke(
        'txn-att.xqy',
        (xs:QName("doc-stat"),$stat1),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
            <prevent-deadlocks>true</prevent-deadlocks>
        </options>
    )
} catch ($e) {
    $e
}
let $update1 := fn:concat("updated action -> status to: ", $stat1, $t1)
let $doc2 := fn:doc("/status-test")/status-test
let $res2 := fn:concat("updated doc status: ", text{$doc2/@status-att})

let $t2 :=
    xdmp:invoke(
        'txn-del.xqy'
    )
    
return ($res1, $update1, $res2)