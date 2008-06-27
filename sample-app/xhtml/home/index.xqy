default element namespace="http://www.w3.org/1999/xhtml"

import module namespace feed="http://marklogic.com/xdmp/feed" at "../../../lib/feed.xqy"

let $subs-tot := xdmp:estimate(fn:collection(feed:subscription())//feed:subscription)
let $items-tot := xdmp:estimate(fn:collection(feed:item()))

(: get subscription status report :)
let $ss := xdmp:invoke("/feed/sample-app/lib/subs-status.xqy")

return
<html>
	<head>
	    <link rel="stylesheet" href="../../style/feed.css" type="text/css"></link>
	</head>
	<body  LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0"> 	
	
	<div class="header">
		<h2 class="title">Feed</h2>	
	</div>
	<div id="sub-header" class="sub-header">
		<span class="sub-header-selected"><a class="sub-header-a" href="index.xqy">home</a></span> |
		<span class="sub-header"><a class="sub-header-a"  href="../manage/index.xqy">manage</a></span>
	</div>	

		<table style="margin-left:10px;margin-top:10px;width:100%;">
		    <tr>
		        <td width="400px">
		            <h2><a href="../../lib/sub-list-sub.xqy">SUBSCRIPTIONS</a>: {$subs-tot}</h2>		          		            
		        </td>
		        <td width="50">
		             &nbsp;&nbsp;&nbsp;&nbsp;
		         </td>
		        <td width="800px">
		            <h2><a href="../../lib/sub-list-item.xqy?start=1">ITEMS</a>: {$items-tot}</h2>
		        </td>
		     </tr>
		     <tr>
		         <td><br/></td>
		     </tr>
		     <tr>
		         <td valign="top">
		            <h2>SUBSCRIPTIONS STATUS</h2>
                    <table>
                        <tr>
                            <td>
                                <table>
                                    <tr><td><a href="../../lib/sub-list-sub.xqy?status={$feed:SS-NEW}">new</a>: </td><td> {$ss/feed:data/feed:new/text()}</td></tr>
                                    <tr><td><a href="../../lib/sub-list-sub.xqy?status={$feed:SS-SUB}">subscribed</a>: </td><td> {$ss/feed:data/feed:subscribed/text()}</td></tr>
                                    <tr><td style="font-size:smaller;">&nbsp;&nbsp;current: </td><td style="font-size:smaller;"> {$ss/feed:data/feed:current/text()}</td></tr>                                    
                                    <tr><td style="font-size:smaller;">&nbsp;&nbsp;due: </td><td style="font-size:smaller;"> {$ss/feed:data/feed:due/text()}</td></tr>
                                    <tr><td><a href="../../lib/sub-list-sub.xqy?status={$feed:SS-PROC}">processing</a>: </td><td> {$ss/feed:data/feed:proc/text()}</td></tr>
                                    <tr><td><a href="../../lib/sub-list-sub.xqy?status={$feed:SS-UNSUB}">un-subscribed</a>: </td><td> {$ss/feed:data/feed:unsubscribed/text()}</td></tr>
                                    <tr><td><a href="../../lib/sub-list-sub.xqy?status={$feed:SS-ERR}">error</a>: </td><td> {$ss/feed:data/feed:err/text()}</td></tr>
                                </table>
                            </td>
                            <td valign="top">
                                {<img src="{$ss/feed:chart-url/text()}"/>}
                            </td>
                        </tr>
                    </table>
		         </td>
		         <td>
		             &nbsp;&nbsp;
		         </td>
		         <td>
		            <table height="100%" width="100%">
                        <tr>
            		        <td>
            		            
            		            <h2>ITEM SEARCH</h2> 
            		            <h2>
            		                <form action="../../lib/item-search.xqy" target="search-result">
            		                    <input class="search" id="s" name="s" type="text"></input>&nbsp;
            		                    <input class="search" type="submit" value="search"></input>
            		                    <br/> 
            		                    <input class="search" type="radio" name="sort" value="rel" checked="true"></input> relevance
            		                    &nbsp;
            		                    <input class="search" type="radio" name="sort" value="date"></input> date
            		                </form>
            		            </h2>
            		            
            		        </td>
                        </tr>
                        <tr height="800px" width="100%">
            		        <td valign="top">
            		            <iframe id="search-result" name="search-result" height="100%" width="100%"
        	                     marginheight="0"  marginwidth="0" frameborder="0">
            		            </iframe>
            		        </td>
            		    </tr>
                    </table>
		         </td>
		     </tr>

		     
		</table>
		
</body>
</html>