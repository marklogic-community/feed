
let $t1 :=
    try { 
        xdmp:http-get("http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml")
    } catch ($e) {
        $e
    }
    

let $t2 := 
    try { 
        xdmp:http-get("http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml",
            <options xmlns="xdmp:http-get">
              <format xmlns="xdmp:document-get">text</format>
            </options>)
    } catch ($e) {
        $e
    }

 let $t3 := 
    try { 
        xdmp:http-get("http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml",
            <options xmlns="xdmp:http-get">
              <encoding xmlns="xdmp:document-get">GB2312</encoding>
            </options>)
    } catch ($e) {
        $e
    }

 let $t4 := 
    try { 
        xdmp:http-get("http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml",
            <options xmlns="xdmp:http-get">
              <format xmlns="xdmp:document-get">text</format>
              <encoding xmlns="xdmp:document-get">GB2312</encoding>
            </options>)
    } catch ($e) {
        $e
    }
 
               
return (" RES1:", $t1, " RES2", $t2, " RES3:", $t3, " RES4:", $t4)

(:
rss feeds fail, html pages work
http://zh.wikipedia.org/wiki/GB_2312
http://www.blogchinese.com/u/086bcgs/rss2.xml
http://hi.baidu.com/ssylc8q/rss
http://rss.alexa.com/top_500.zh_gb2312.xml
http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml
:)