default element namespace="http://www.w3.org/1999/xhtml"
declare namespace qm = "http://marklogic.com/xdmp/query-meters"

import module namespace feed="http://marklogic.com/xdmp/feed" at "../../lib/feed.xqy"

let $count := xs:integer(xdmp:get-request-field("c","20"))
let $count-start := try {xs:integer(xdmp:get-request-field("cs","1"))} catch ($e) {1}
let $s := xdmp:get-request-field("s","")
let $sort := xdmp:get-request-field("sort", "rel") (: rel | date :)
let $debug := xdmp:get-request-field("debug", "true") (: true :)

(: 
::parse the search term - looking for:
:: keyword e.g. term
:: negative terms e.g. -term
:: phrases e.g. "term term2"
:: negative phrases e.g. -"term term2"
:)
let $word := ()
let $word-neg := ()
let $phrase := ()
let $phrase-neg := ()

(: the fields to search :)
let $fields := ("feed-title", "feed-detail")

(: find phrases surrounded by quotes - replace the space :)
let $tokens :=
    fn:tokenize(
        fn:string-join(
            let $ts :=  fn:tokenize($s,'"')
            return
                if (fn:count($ts) > 2)
                then 
                     for $qt at $c in $ts
                     return
                         if (($c mod 2) = 0)
                         then 
                             if (fn:ends-with($ts[$c - 1], '-'))
                             then fn:concat("-",fn:replace($qt, "\s+", "!+!"))
                             else fn:replace($qt, "\s+", "!+!")
                         else $qt
                else $s
            ,
            " ")
        , " ")

let $t1 :=
    for $t in $tokens
        return
        if ($t = "-")
        then ()
        else if (fn:contains($t, "!+!"))
        then
            if (fn:starts-with($t, '-'))
            then xdmp:set($phrase-neg, ($phrase-neg, (fn:replace($t, "!\+!", " "))))
            else xdmp:set($phrase, ($phrase, fn:replace($t, "!\+!", " ")))
        else if (fn:starts-with($t, '-'))
        then xdmp:set($word-neg, ($word-neg, $t))
        else if ($t != "")
        then xdmp:set($word, ($word, $t))
        else ()

(: 
:: build the queries 
:: wildcard - automatically add a trailing wildcard
:: case sensitivity - lower case terms are automatically insensitive, any upper case term make is sensitive
:)    
let $wq :=
    (
        for $w in $word return
        cts:field-word-query(
        	$fields,
            (if (fn:ends-with($w,"*")) then $w else fn:concat($w,"*"))
         )
         ,
        for $p in $phrase return
        cts:field-word-query(
        	$fields,
            $p
         )
     )
             


let $wqn :=
    (
        for $wn in $word-neg return
        cts:not-query(
            cts:field-word-query(
            	$fields,
                fn:substring-after($wn,"-")
             )
         )
         ,
        for $pn in $phrase-neg return
        cts:not-query(
            cts:field-word-query(
            	$fields,
                fn:substring-after($pn,"-")
             )
         )
     )    

(: build the cts:query :)
let $q :=
    if ($wq or $wqn)
    then cts:and-query(($wq, $wqn))
    else ()
    
    
    
(: run the search :)
let $debug-search-start := xdmp:query-meters()/qm:elapsed-time
let $sr := cts:search(fn:collection(feed:item()), $q, ("unfiltered") )
let $sres-count := fn:count($sr)
let $sres :=  
    (: the search call :) 
    if ($sort = "date")
    then
        (for $i in $sr
         order by $i/feed:item/feed:published descending
         return $i)[$count-start to ($count-start + $count - 1)]
    else
        $sr[$count-start to ($count-start + $count - 1)]
        
let $debug-search-finish := xdmp:query-meters()/qm:elapsed-time
        
let $debug-xhtml-start := xdmp:query-meters()/qm:elapsed-time
        
let $search-results :=
    if ($s = "")
    then <tr><td><span>no search term provided</span></td></tr>
    else     
        for $i at $c in $sres
        return
            <tr>
                <td>
                    <span><a href="{$i/feed:item/feed:link/text()}" target="_blank">{xdmp:unquote($i/feed:item/feed:title/text())}</a> from
                    {
                        (: getting the feed's title - this appears to slow the page gen down quite a bit :)
                        fn:collection(feed:description())/feed:description[@id=$i/feed:item/@descid]/feed:title/text()
                    }
                    </span>
                </td>
            </tr>

let $debug-xhtml-finish := xdmp:query-meters()/qm:elapsed-time

let $debug-search-qm := xdmp:query-meters()
let $debug-result :=
    <debug>
        BEGIN DEBUG
        <div>terms: {$s}</div>
        <div>key word: { for $w in $word return $w}</div>
        <div>key word neg: {$word-neg}</div>
        <div>phrase: {$phrase}</div>
        <div>phrase-neg: {$phrase-neg}</div>
        <div>search duration:{$debug-search-finish - $debug-search-start }</div>
        <div>xhtml duration:{$debug-xhtml-finish - $debug-xhtml-start }</div>
        <div>actual result count:{$sres-count}</div>
        <div onmouseover="document.getElementById('qm').style.display='block';"  onmouseout="document.getElementById('qm').style.display='none';">
            query metrics (rollover to display):
            <span id="qm" style="display:none;">
            {xdmp:quote($debug-search-qm)}
            </span>
        </div>
        <div>QUERY: {cts:and-query($q)}</div>
        END DEBUG
    </debug>

return
        <html>
        	<head>
        	    <link rel="stylesheet" href="../style/feed.css" type="text/css"></link>
        	</head>
        	<body  LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">
        	
            <table width="100%">                   
            {    
             <tr>
                <td valign="top">
                    <span><b>
                        {$sres-count} results for '{$s}'
                          {if ($sres-count > $count)
                           then fn:concat(" showing ",$count-start," - ", if (($count + $count-start) > $sres-count) then $sres-count else $count + ($count-start - 1))
                           else ()
                          }
                          {if ($sres-count > $count)
                           then <span>&nbsp;&nbsp;&nbsp;
                                {if ($count-start > $count)
                                 then  <a href="/feed/sample-app/lib/item-search.xqy?s={$s}&sort={$sort}&c={$count}&cs={$count-start - $count}&debug={$debug}">prev</a>
                                 else "prev"}
                                 - 
                                 {if (($count + $count-start) < $sres-count)
                                 then <a href="/feed/sample-app/lib/item-search.xqy?s={$s}&sort={$sort}&c={$count}&cs={$count-start + $count}&debug={$debug}">next</a>
                                 else "next"}
                                </span>
                           else ()
                          }
                          </b></span>
                </td>
              </tr>
             }
             {$search-results}
      </table>
      </body>
 </html>