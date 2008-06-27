default element namespace="http://www.w3.org/1999/xhtml"

import module namespace feed="http://marklogic.com/xdmp/feed" at "../../../lib/feed.xqy"

<html>
	<head>
	    <link rel="stylesheet" href="../../style/feed.css" type="text/css"></link>
	</head>
	<body  LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">

    <div class="header">
		<h2 class="title">Feed</h2>	
	</div>
	<div id="sub-header" class="sub-header">
		<span class="sub-header"><a class="sub-header-a" href="../home/index.xqy">home</a></span> |
		<span class="sub-header-selected"><a class="sub-header-a"  href="index.xqy">manage</a></span>
	</div>	

	<table width="100%" height="91%">
	<tr height="100%">
	    <td width="400">
            <table width="100%" height="100%">
            	<tr>
            	<td valign="top" width="400">	
            		<div class="admin-header">UPDATE ALL SUBSCRIPTIONS</div>
                    <div class="admin-control">
            			<span><a href="../../lib/subscription-check.xqy" target="result">update</a></span>
            			<br/>&nbsp;
            		</div>
            		
            		<div class="admin-header">SUBSCRIBE TO SINGLE FEED</div>
                    <div class="admin-control" >
                        <table width="100%">
                        <tr>
                            <td width="100px">
                                url: 
                            </td>
                            <td>
                                <input type="text" id="sub" style="width:200px;"></input>
                            </td>
                            <td>
                            </td>
                        </tr>            
                        <tr>
                            <td>domain:</td>
                            <td> <input type="text" id="domain" style="width:100px;" value=""></input> </td>
                            <td><span style="font-size:smaller">text</span></td>
                        </tr>
                        <tr>
                            <td>frequency:</td>
                            <td> <input type="text" id="freq" style="width:100px;" value="3600"> </input> </td>
                            <td><span style="font-size:smaller">0 - n</span></td>
                        </tr>
                        <tr>
                            <td>versioning:</td>
                            <td> <input type="text" id="version" style="width:50px;" value="false"></input></td>
                            <td><span style="font-size:smaller">true | false</span></td>
                        </tr>
                        <tr>
                            <td>item store:</td>
                            <td> <input type="text" id="store" value="all" style="width:50px;"></input></td>
                            <td> <span style="font-size:smaller">all | current | 0 - n</span></td>
                        </tr>
                        <tr>
                            <td>redirects:</td>
                            <td> <input type="text" id="redirects" value="5" style="width:50px;"></input> </td>
                            <td><span style="font-size:smaller">0 - n</span></td>
                        </tr>            
                        <tr>
                            <td></td>
                            <td><input type="button" value="subscribe" onclick="window.open('../../lib/sub-opt.xqy?url=' + escape(document.getElementById('sub').value) + '&store=' + escape(document.getElementById('store').value)+ '&domain=' + escape(document.getElementById('domain').value) + '&freq=' + escape(document.getElementById('freq').value) + '&version=' + escape(document.getElementById('version').value) + '&redirects=' + escape(document.getElementById('redirects').value), 'result');"></input>
                            </td>
                            <td>
                                <br/><br/>
                            </td>
                        </tr>
                        <tr>
            			    <td>
            			        <br/>
            			    </td>
            			</tr>
                    </table>
                    </div>
                    
            		<div class="admin-header">SUBSCRIBE TO OPML FEED LIST</div>
                    <table class="admin-control" width="100%" >
                        <tr>
                            <td width="100px">file:</td>
                            <td>
                                <input type="text" id="opml" value="feed/test/data/"></input>
                            </td>
                            <td>
                                <span style="font-size:smaller">relative to server root</span>
                            </td>
                        </tr>
                        <tr>
                            <td>domain:</td>
                            <td> <input type="text" id="odomain" style="width:100px;" value=""></input> </td>
                            <td><span style="font-size:smaller">text</span></td>
                        </tr>
                        <tr>
                            <td>frequency:</td>
                            <td> <input type="text" id="ofreq" style="width:100px;" value="3600"> </input> </td>
                            <td><span style="font-size:smaller">0 - n</span></td>
                        </tr>
                        <tr>
                            <td>versioning:</td>
                            <td> <input type="text" id="oversion" style="width:50px;" value="false"></input></td>
                            <td><span style="font-size:smaller">true | false</span></td>
                        </tr>
                        <tr>
                            <td>item store:</td>
                            <td> <input type="text" id="ostore" value="all" style="width:50px;"></input></td>
                            <td> <span style="font-size:smaller">all | current | 0 - n</span></td>
                        </tr>
                        <tr>
                            <td>redirects:</td>
                            <td> <input type="text" id="oredirects" value="5" style="width:50px;"></input> </td>
                            <td><span style="font-size:smaller">0 - n</span></td>
                        </tr>  
                        <tr>
                        <td></td>
                        <td>
                            <input type="button" value="subscribe" onclick="window.open('../../lib/sub-opml.xqy?file=' + escape(document.getElementById('opml').value) + '&store=' + escape(document.getElementById('ostore').value)+ '&domain=' + escape(document.getElementById('odomain').value) + '&freq=' + escape(document.getElementById('ofreq').value) + '&version=' + escape(document.getElementById('oversion').value) + '&redirects=' + escape(document.getElementById('oredirects').value), 'result');"></input>
                        </td>
                        <td></td>
                        </tr>
               			<tr>
            			    <td>
            			        <br/>
            			    </td>
            			</tr>
                    </table>
            
            		<div class="admin-header">UNSUBSCRIBE</div>
                    <div class="admin-control" >
                        <table>
                        <tr>
                            <td width="100px">
                                feed:
                            </td>
                            <td>
                                <select id="unsub" style="width:200px;" multiple="true">
                                {
                                    for $s in fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-SUB]
                                    return
                                    <option value="{text{$s/@id}}">{fn:concat($s/feed:domain/text()," ",$s/feed:reference/text())}</option>
                                }
                                </select>
                             </td>
                        </tr>
                        <tr>
                            <td> 
                                archive:
                            </td>
                            <td>
                                 <input type="text" id="archive" value="false" style="width:50px;"></input>
                            </td>
                            <td>
                                <span style="font-size:smaller">true | false</span>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="button" value="unsubscribe" onclick="window.open('../../lib/sub-unsub.xqy?id=' + escape(document.getElementById('unsub').value) + '&archive=' + escape(document.getElementById('archive').value),'result');"></input>
                            </td>
                        </tr>
                        <tr>
            			    <td>
            			        <br/>
            			    </td>
            			</tr>
                    </table>
                    </div>
            
            		<div class="admin-header">RESUBSCRIBE</div>
                    <div class="admin-control" >
                        <table>
                            <tr>
                                <td width="100px">
                                    feed:
                                </td>
                                <td>
                                    <select id="resub" style="width:200px;" multiple="true">
                                    
                                    {
                                        for $s in fn:collection(feed:subscription())//feed:subscription[@status=$feed:SS-UNSUB]
                                        return
                                        <option value="{text{$s/@id}}">{fn:concat($s/feed:domain/text()," ",$s/feed:reference/text())}</option>
                                    }
                                    </select>
                                 </td>
                              </tr>
                              <tr>
                                  <td></td>
                                  <td>
                                      <input type="button" value="resubscribe" onclick="window.open('../../lib/sub-resub.xqy?id=' + escape(document.getElementById('resub').value),'result');"></input>
                                  </td>
                              </tr>
                              <tr>
                			  <td>
                			      <br/>
                			  </td>
                			</tr>
                          </table>
                    </div>
                    			
            		<div class="admin-header">DELETE</div>
            		<table class="admin-control" >
                        <tr>
                            <td width="140">
            			        <span>subscriptions</span>
            			    </td>
                            <td width="140">
            			        <span>descriptions</span>
            			    </td>
                            <td width="140">
            			        <span>items</span>
            			    </td>
            			</tr>
            
                        <tr>
                            <td>
            			        <span><a href="../../lib/sub-del-sub.xqy" target='result'>del col</a></span>
            			    </td>
                            <td>
            			        <span><a href="../../lib/sub-del-desc.xqy" target='result'>del col</a></span>
            			    </td>
                            <td>
            			        <span><a href="../../lib/sub-del-item.xqy" target='result'>del col</a></span>
            			    </td>
            			</tr>		
            
                        <tr>
                            <td>
            			        <span><a href="../../lib/sub-del-sub-doc.xqy" target='result'>del docs</a> </span>
            			    </td>
                            <td>
            			        <span><a href="../../lib/sub-del-desc-doc.xqy" target='result'>del docs</a> </span>
            			    </td>
                            <td>
            			        <span><a href="../../lib/sub-del-item-doc.xqy" target='result'>del docs</a> </span>
            			    </td>
            			</tr>
            			<tr>
            			    <td>
            			        <br/>
            			    </td>
            			</tr>
            	    </table>
            	    
                </td>
                </tr>
            </table>
        </td>
    <td>    
        <iframe id="result" name="result" height="100%" width="100%"
                marginheight="0"  marginwidth="0" frameborder="0">    
        </iframe>
    </td>
    </tr>
    </table>

	</body>
</html>