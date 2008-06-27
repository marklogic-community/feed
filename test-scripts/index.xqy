default element namespace="http://www.w3.org/1999/xhtml"

<html>
	<head>
	    <link rel="stylesheet" href="../admin/style/feed.css" type="text/css"></link>
	    <!-- ENCODINGS
            $ 24
            & 26
            + 2B
            , 2C
            / 2F
            : 3A
            ; 3B
            = 3D
            ? 3F
            @ 40
        -->
	</head>
	<body  LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">

		<!-- FEED -->
		<div>FEED DOCUMENT</div>
        <div>
            <input type="text" id="req"></input>
            <input type="button" value="request" onclick="window.location.href=('request.xqy?url=' + escape(document.getElementById('req').value));"></input>
            <input type="button" value="request title" onclick="window.location.href=('request-title.xqy?url=' + escape(document.getElementById('req').value));"></input>
            API
        </div>
        <div>
            <input type="text" id="req00"></input>
            <input type="button" value="req bin" onclick="window.location.href=('feed-request-bin.xqy?url=' + escape(document.getElementById('req00').value));"></input>
            binary, other options default
        </div>
        <div>
            <input type="text" id="req0"></input>
            <input type="button" value="req text iso " onclick="window.location.href=('feed-request-text-iso.xqy?url=' + escape(document.getElementById('req0').value));"></input>
            <input type="button" value="req text iso save $enc" onclick="window.location.href=('feed-request-text-iso-save-enc.xqy?url=' + escape(document.getElementById('req0').value));"></input>  
            <input type="button" value="req text iso save utf8" onclick="window.location.href=('feed-request-text-iso-save-utf8.xqy?url=' + escape(document.getElementById('req0').value));"></input>
            <input type="button" value="req text iso save iso" onclick="window.location.href=('feed-request-text-iso-save-iso.xqy?url=' + escape(document.getElementById('req0').value));"></input>          
            <input type="button" value="req text iso title" onclick="window.location.href=('feed-request-text-iso-title.xqy?url=' + escape(document.getElementById('req0').value));"></input>
        </div>
        <div>
            <input type="text" id="req1"></input>
            <input type="button" value="request1" onclick="window.location.href=('feed-request1.xqy?url=' + escape(document.getElementById('req1').value));"></input>
            <input type="button" value="request1 title" onclick="window.location.href=('feed-request1_title.xqy?url=' + escape(document.getElementById('req1').value));"></input>
            xml, full repair, ISO-8859-1
        </div>
        <div>
            <input type="text" id="req2"></input>
            <input type="button" value="request2" onclick="window.location.href=('feed-request2.xqy?url=' + escape(document.getElementById('req2').value));"></input>
            xml, full repair, GB2312
        </div>
        <div>
            <input type="text" id="req10"></input>
            <input type="button" value="request10" onclick="window.location.href=('feed-request10.xqy?url=' + escape(document.getElementById('req10').value));"></input>
            text, UTF-8 (default)
        </div>
        <div>
            <input type="text" id="req11"></input>
            <input type="button" value="request11" onclick="window.location.href=('feed-request11.xqy?url=' + escape(document.getElementById('req11').value));"></input>
            <input type="button" value="request11 title" onclick="window.location.href=('feed-request11_title.xqy?url=' + escape(document.getElementById('req11').value));"></input>
            text, ISO-8859-1
        </div>
        <div>
            <input type="text" id="req12"></input>
            <input type="button" value="request12" onclick="window.location.href=('feed-request12.xqy?url=' + escape(document.getElementById('req12').value));"></input>
            <input type="button" value="request12 title" onclick="window.location.href=('feed-request12_title.xqy?url=' + escape(document.getElementById('req12').value));"></input>
            text, GB2312
        </div>        
        <div>
            <input type="text" id="req20"></input>
            <input type="button" value="request20" onclick="window.location.href=('feed-request20.xqy?url=' + escape(document.getElementById('req20').value));"></input>
            text, UTF-8 (default), tidy
        </div>
        <div>
            <input type="text" id="req21"></input>
            <input type="button" value="request21" onclick="window.location.href=('feed-request21.xqy?url=' + escape(document.getElementById('req21').value));"></input>
            <input type="button" value="request21 title" onclick="window.location.href=('feed-request21_title.xqy?url=' + escape(document.getElementById('req21').value));"></input>
            text, ISO-8859-1, tidy
        </div>
        <div>
            <input type="text" id="req22"></input>
            <input type="button" value="request22" onclick="window.location.href=('feed-request22.xqy?url=' + escape(document.getElementById('req22').value));"></input>
            <input type="button" value="request22 title" onclick="window.location.href=('feed-request22_title.xqy?url=' + escape(document.getElementById('req22').value));"></input>
            text, GB2312, tidy
        </div>
        <div>
            <input type="text" id="req50"></input>
            <input type="button" value="request50" onclick="window.location.href=('feed-request50.xqy?url=' + escape(document.getElementById('req50').value));"></input>
            <input type="button" value="request50 title" onclick="window.location.href=('feed-request50_title.xqy?url=' + escape(document.getElementById('req50').value));"></input>
            text, no encoding, tidy
        </div>
		<div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">request</a> </span>
			<span> rss 2.0, local file</span>
		</div>
		
	    <div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">request</a> </span>
			<span> rss 2.0, remote</span>
		</div>
		<div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml">request</a> </span>
			<span> atom 1.0, local file</span>
		</div>
		<div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://feeds.feedburner.com/redeyevc">request</a> </span>
			<span> atom 1.0, remote file</span>
		</div>	

	    <div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml">request</a> </span>
			<span> rss 1.0, local file</span>
		</div>
	
		<div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">request</a> </span>
			<span> rss 1.0, remote file</span>
		</div>
	    <div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml">request</a> </span>
			<span> rss 0.9, local file</span>
		</div>
	
		<div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://rss.slashdot.org/Slashdot/slashdot/to">request</a> </span>
			<span> rss 0.9, remote file</span>
		</div>
		<div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://localhost:8010/feed/test-scripts/data/future%20play.xml">request- bad filename </a> </span>
			<span> atom 1.0, local file, space in filename</span>
		</div>
		<div>
			<span>Feed  Request </span>
			<span> <a href="request.xqy?url=http://localhost:8010/feed/test-scripts/data/NOFILE">request - 404</a> </span>
			<span> atom 1.0, local file, 404</span>
		</div>
		<div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://news.google.com/news/miss">request - 404</a> </span>
			<span> atom 0.3, remote, 404</span>
		</div>
		<div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://slashdot.org/slashdot.rdf"> request - server redirect  </a> </span>
			<span> rss 0.9, remote, 300 (redirect) http://slashdot.org/slashdot.rdf -> http://rss.slashdot.org/Slashdot/slashdot/to</span>
		</div>
		<div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://slashdot.org/slashdot.rdf"> request - server redirect  </a> </span>
			<span> rss 1.0, remote, 300 (redirect) http://slashdot.org/slashdot.rss -> http://rss.slashdot.org/Slashdot/slashdot</span>
		</div>
		<div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://www.wired.com/news_drop/netcenter/netcenter.rdf"> request - redirect relative  </a> </span>
			<span> rss 2.0, remote,  redirect 302 (perm) http://www.wired.com/news_drop/netcenter/netcenter.rdf->  http://www.wired.com/rss/index.xml -> http://feeds.wired.com/wired/topheadlines </span>
		</div>	  
		<div>
			<span>Feed Request </span>
			<span> <a href="request.xqy?url=http://www.wired.com/rss/index.xml"> request - redirect full (part 2)</a> </span>
			<span> rss 2.0, remote,  redirect 301 (temp) http://www.wired.com/rss/index.xml ->	http://feeds.wired.com/wired/topheadlines </span>
		</div>
		<div>FEED DOCUMENT: OTHER FEEDS THAT FAILED (ALL SHOULD WORK)</div>
		<div>
		<a href="request.xqy?url=http://www.globalsecurity.org/globalsecurity-org.xml">http://www.globalsecurity.org/globalsecurity-org.xml</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.languagehat.com/index.rdf">	    http://www.languagehat.com/index.rdf</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://simple.wikipedia.org/w/index.php%3Ftitle%3DSpecial%3ARecentchanges%26feed%3Drss">	    http://simple.wikipedia.org/w/index.php?title=Special:Recentchanges&feed=rss</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.iht.com/rss/africa.xml">	    http://www.iht.com/rss/africa.xml</a>	    
	    </div>
		<div>
		    <a href="request.xqy?url=http://feeds.folha.uol.com.br/folha/emcimadahora/rss091.xml">http://feeds.folha.uol.com.br/folha/emcimadahora/rss091.xml</a> encoded as ISO but does not display as such	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.macworld.com/rss.xml	">    http://www.macworld.com/rss.xml</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.makezine.com/blog/index.xml">	    http://www.makezine.com/blog/index.xml</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://rss.news.yahoo.com/rss/entertainment">	    http://rss.news.yahoo.com/rss/entertainment</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://id.wikipedia.org/w/index.php%3Ftitle%3DIstimewa%3APerubahan_terbaru%26feed%3Drss">	    http://id.wikipedia.org/w/index.php?title=Istimewa:Perubahan_terbaru&feed=rss</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://feeds.newsweek.com/newsweek/TopNews">	    http://feeds.newsweek.com/newsweek/TopNews</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.weather.gov/nwsheadlines.xml">	    http://www.weather.gov/nwsheadlines.xml</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.newscientist.com/feed.ns%3Findex%3Donline-news">	    http://www.newscientist.com/feed.ns?index=online-news</a>	    
	    </div>
		<div>
		<a href="	    request.xqy?url=http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml">	    http://newsrss.bbc.co.uk/rss/chinese/simp/news/rss.xml</a> GB2312	    
	    </div>
	    <div>
	    <a href="request.xqy?url=http://rss.alexa.com/top_500.zh_gb2312.xml">http://rss.alexa.com/top_500.zh_gb2312.xml</a> gb2312
	    </div>
		<div>
		<a href="	    request.xqy?url=http://www.pbs.org/wgbh/nova/sciencenow/rss/nsn.xml	">    http://www.pbs.org/wgbh/nova/sciencenow/rss/nsn.xml</a>	    
	    </div>
	    <!-- FEED TITLE -->
		<br/>
		<div>FEED TITLE</div>
        <div>
            <input type="text" id="feed-title"></input>
            <input type="button" value="get title" onclick="window.location.href=('feed-title.xqy?url=' + escape(document.getElementById('feed-title').value));"></input>
        </div>
		<div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">feed title</a> </span>
			<span> rss 2.0, local</span>
		</div>
		<div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">feed title</a> </span>
			<span> rss 2.0, remote</span>
		</div>
		<div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml">feed title</a> </span>
			<span> atom 1.0, local</span>
		</div>
		<div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://feeds.feedburner.com/redeyevc">feed title</a> </span>
			<span> atom 1.0, remote</span>
		</div>		
        <div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml">feed title</a> </span>
			<span>rss 1.0, local</span>
		</div>
        <div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">feed title</a> </span>
			<span>rss 1.0, remote</span>
		</div>
        <div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml">feed title</a> </span>
			<span>rss 0.9x, local</span>
		</div>
        <div>
			<span>Feed Title </span>
			<span><a href="feed-title.xqy?url=http://rss.slashdot.org/Slashdot/slashdot/to">feed title</a> </span>
			<span>rss 0.9x, remote</span>
		</div>
					
		<!-- FEED LINK -->
		<br/>
		<div>FEED LINK</div>
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">feed link</a> </span>
			<span>rss 2.0, local</span>
		</div>
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">feed link</a> </span>
			<span>rss 2.0, remote</span>
		</div>	
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml">feed link</a> </span>
			<span>atom 1.0, local</span>
		</div>
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://feeds.feedburner.com/redeyevc">feed link</a> </span>
			<span>atom 1.0, remote</span>
		</div>		
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml">feed link</a> </span>
			<span>rss 1.0, local</span>
		</div>
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">feed link</a> </span>
			<span>rss 1.0, remote</span>
		</div>
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml">feed link</a> </span>
			<span>rss 0.9, local</span>
		</div>
		<div>
			<span>Feed Link </span>
			<span><a href="feed-link.xqy?url=http://rss.slashdot.org/Slashdot/slashdot/to">feed link</a> </span>
			<span>rss 0.9, remote</span>
		</div>
				
		<!-- FEED PUB DATE -->
		<br/>
		<div>FEED PUB DATE</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">pubdate</a> </span>
			<span>rss 2.0, local, no date</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">pubdate</a> </span>
			<span>rss 2.0, remote, no date</span>
		</div>		

		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://localhost:8010/feed/test-scripts/data/techmeme.xml">pubdate</a> </span>
			<span>rss 2.0, local, has date</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://www.techmeme.com/index.xml">pubdate</a> </span>
			<span>rss 2.0, remote, has date</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml">pubdate</a> </span>
			<span>atom 2.0, local</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://feeds.feedburner.com/redeyevc">pubdate</a> </span>
			<span>atom 2.0, remote</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml">pubdate</a> </span>
			<span>rss 1.0, local</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">pubdate</a> </span>
			<span>rss 1.0, remote</span>
		</div>
		<div>
			<span>Feed Pub Date </span>
			<span><a href="feed-pubdate.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml">pubdate</a> </span>
			<span>rss 0.9, local, no date</span>
		</div>

		<!-- FEED DESCRIPTION -->
		<br/>
		<div>FEED DESCRIPTION</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">description</a> </span>
			<span>rss 2.0, local</span>
		</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://localhost:8010/feed/test-scripts/data/techmeme.xml">description</a> </span>
			<span>rss 2.0, local</span>
		</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://www.techmeme.com/index.xml">description</a> </span>
			<span>rss 2.0, remote</span>
		</div>		
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml">description</a> </span>
			<span>atom 2.0, local</span>
		</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://feeds.feedburner.com/CreativeArchive">description</a> </span>
			<span>atom 2.0, remote</span>
			
		</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml">description</a> </span>
			<span>rss 1.0, local</span>
		</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">description</a> </span>
			<span>rss 1.0, remote</span>
		</div>
		<div>
			<span>Feed Description </span>
			<span><a href="feed-description.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml">description</a> </span>
			<span>rss 0.9, local, no date</span>
		</div>
								
		<!-- FEED FAVICON LINK -->
	    <br/>
		<div>FAVICON LINK</div>
		<div>
			<span>Favicon Link </span>
			<span><a href="favicon-link.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">get engadget favicon link</a> </span>
			<span>rss 2.0, remote</span>
		</div>
		<div>
			<span>Favicon Link </span>
			<span><a href="favicon-link.xqy?url=http://feeds.feedburner.com/techcrunch">get techcrunch favicon link</a> </span>
			<span>rss 2.0, remote</span>
		</div>
		<div>
			<span>Favicon Link </span>
			<span><a href="favicon-link.xqy?url=http://feeds.feedburner.com/redeyevc">get redeye favicon link</a> </span>
			<span>atom 1.0, remote</span>
		</div>	
		<div>
			<span>Favicon Link </span>
			<span><a href="favicon-link.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">get slashdot favicon link</a> </span>
			<span>rss 1.0, remote</span>
		</div>
		<div>
			<span>Favicon Link </span>
			<span><a href="favicon-link.xqy?url=http://slashdot.org/slashdot.rdf">get slashdot favicon link</a> </span>
			<span>rss 0.9, remote, redirected</span>
		</div>				
		<!-- FEED ITEM COUNT -->
		<br/>
		<div>ITEM COUNT</div>
		<div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">item count</a> </span>
			<span> rss 2.0, local</span>
		</div>
		<div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">item count</a> </span>
			<span> rss 2.0, remote</span>
		</div>
        <div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml">item count</a> </span>
			<span> atom 1.0, local</span>
		</div>
        <div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://feeds.feedburner.com/redeyevc">item count</a> </span>
			<span> atom 1.0, remote</span>
		</div>		
		<div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml">item count</a> </span>
			<span> rss 1.0, local</span>
		</div>
		<div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml">item count</a> </span>
			<span> rss 0.9, local</span>
		</div>
		<div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">item count</a> </span>
			<span> rss 1.0, remote</span>
		</div>
		<div>
			<span>Item Count </span>
			<span><a href="feed-item-count.xqy?url=http://slashdot.org/slashdot.rdf">item count</a> </span>
			<span> rss 1.0, remote, redirected, rdf namespace items</span>
		</div>

		
		<!-- FEED ITEM BY NUMBER-->
		<br/>
		<div>ITEM DOCUMENT</div>
        <div>
            <input type="text" id="feed-item"></input>
            <input type="button" value="get item doc" onclick="window.location.href=('feed-item.xqy?num=1&url=' + escape(document.getElementById('feed-item').value));"></input>
        </div>
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml&num=1">get engadget feed item 1</a> </span>
			<span> rss 2.0, local</span>
		</div>
		
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&num=1">get engadget feed item 1</a> </span>
			<span> rss 2.0, remote</span>
		</div>		
		
	    <div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml&num=1">get redeye feed item 1</a> </span>
			<span> atom 1.0, local</span>
		</div>
		
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://feeds.feedburner.com/redeyevc&num=1">get redeye feed item 1</a> </span>
			<span> atom 1.0, remote</span>
		</div>	
		
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml&num=1">get slashdot feed item 1</a> </span>
			<span> rss 1.0, local</span>
		</div>
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml&num=1">get slashdot feed item 1</a> </span>
			<span> rss 0.9, local</span>
		</div>
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://rss.slashdot.org/Slashdot/slashdot&num=1">get slashdot feed item 1</a> </span>
			<span> rss 1.0, remote</span>
		</div>
		<div>
			<span>Feed Item </span>
			<span><a href="feed-item.xqy?url=http://slashdot.org/slashdot.rdf&num=1">get slashdot feed item 1</a> </span>
			<span> rss 0.9, remote, redirect</span>
		</div>


		<!-- FEED ITEM TITLE - WITH AND WITHOUT HTML/QUOTE -->
		<br/>
		<div>ITEM TITLE</div>
		<div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml&num=1"> feed item 1 title</a> </span>
			<span> rss 2.0, local, quoted string</span>
		</div>
		
	    <div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&num=1"> feed item 1 title</a> </span>
			<span> rss 2.0, remote</span>
		</div>

	    <div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml&num=1"> feed item 1 title</a> </span>
			<span> atom 1.0, local, raw text</span>
		</div>
	    <div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://feeds.feedburner.com/CreativeArchive&num=1"> feed item 1 title</a> </span>
			<span> atom 1.0, remote, raw text</span>
		</div>
	    <div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml&num=1"> feed item 1 title</a> </span>
			<span> rss 1.0, local, raw text</span>
		</div>
	    <div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://rss.slashdot.org/Slashdot/slashdot&num=1"> feed item 1 title</a> </span>
			<span> rss 1.0, remote, raw text</span>
		</div>
	    <div>
			<span>Item Title </span>
			<span><a href="item-title.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml&num=1"> feed item 1 title</a> </span>
			<span> rss 0.9, local, raw text</span>
		</div>		
		
		
		
		<!-- FEED ITEM LINK -->
		<br/>
		<div>ITEM LINK</div>
		<div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml&num=1"> feed item 1 link</a> </span>
			<span> rss 2.0, local, guid is true</span>
		</div>		

		<div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://localhost:8010/feed/test-scripts/data/nyt.xml&num=1"> feed item 1 link</a> </span>
			<span> rss 2.0, local, guid is false</span>
		</div>
		
		<div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml&num=1"> feed item 1 link</a> </span>
			<span> atom 1.0, local</span>
		</div>
		<div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://feeds.feedburner.com/CreativeArchive&num=1"> feed item 1 link</a> </span>
			<span> atom 1.0, remote</span>
		</div>
		<div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml&num=1"> feed item 1 link</a> </span>
			<span> rss 1.0, local</span>
		</div>
		<div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://rss.slashdot.org/Slashdot/slashdot&num=1"> feed item 1 link</a> </span>
			<span> rss 1.0, remote</span>
		</div>
	    <div>
			<span>Item Link </span>
			<span><a href="item-link.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml&num=1"> feed item 1 title</a> </span>
			<span> rss 0.9, local</span>
		</div>			
		
		
		<!-- FEED ITEM DESCRIPTION - WITH AND WITHOUT HTML -->
		<br/>
		<div>ITEM DESCRIPTION</div>
        <div>
            <input type="text" id="item-desc"></input>
            <input type="button" value="get item description" onclick="window.location.href=('item-description.xqy?num=1&url=' + escape(document.getElementById('item-desc').value));"></input>
        </div>
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml&num=1">feed item 1 description</a> </span>
			<span> rss 2.0, local, contains HTML</span>
		</div>
		
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/nyt.xml&num=1">feed item 1 description</a> </span>
			<span> rss 2.0, local, contains text</span>
		</div>
		
	    <div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&num=1">feed item 1 description</a> </span>
			<span> rss 2.0, remote, contains HTML</span>
		</div>
		
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/redeye.xml&num=1">feed item 1 description</a> </span>
			<span> atom 1.0, local, contains HTML as content element</span>
		</div>
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://onepicaday.blogspot.com/feeds/posts/default&num=1">feed item 1 description</a> </span>
			<span> atom 1.0, remote</span>
		</div>		
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot.xml&num=1">feed item 1 description</a> </span>
			<span> rss 1.0, local, contains HTML</span>
		</div>
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://rss.slashdot.org/Slashdot/slashdot&num=1">feed item 1 description</a> </span>
			<span> rss 1.0, remote, contains HTML</span>
		</div>
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/slashdot_rdfns.xml&num=1">feed item 1 description</a> </span>
			<span> rss 0.9, local, contains HTML</span>
		</div>
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/rww_item4_error.xml&num=4">feed item 4 description</a> </span>
			<span> rss 2.0, local, description error item 4, XDMP-UNEOF </span>
		</div>
		<div>
			<span>Item Description </span>
			<span><a href="item-description.xqy?url=http://localhost:8010/feed/test-scripts/data/bloglines.xml&num=5">feed item 5 description</a> </span>
			<span> rss 2.0, local, description error item 5, XDMP-STARTTAGCHAR </span>
		</div>		
		<!-- SUBSCRIBE -->
		<br/>
		<div>SUBSCRIBE</div>
        <div>
            <input type="text" id="sub"></input>
            <input type="button" value="subscribe" onclick="window.location.href=('sub.xqy?url=' + escape(document.getElementById('sub').value));"></input>
        </div>
	    <div>
			<span>Subscribe to Feed</span>
			<span><a href="sub.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">subscribe</a> </span>
			<span> rss 2.0, remote</span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml">subscribe</a> </span>
			<span> rss 2.0, local</span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml&domain=eng">subscribe</a> </span>
			<span> rss 2.0, local, domain</span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://feeds.feedburner.com/TypePadNews&freq=1200">subscribe</a> </span>
			<span> atom 1.0, remote</span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">subscribe</a> </span>
			<span> rss 1.0, remote</span> 
			<span> <a href="sub-unsub.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">unsub</a></span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://slashdot.org/slashdot.rdf">subscribe</a> </span>
			<span> rss 0.9, remote</span>
			<span> <a href="sub-unsub.xqy?url=http://slashdot.org/slashdot.rdf">unsub</a></span>
		</div>		
		
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&freq=300&store=all">subscribe</a> </span>
			<span> rss 2.0, remote, 5 minute frequency, store all, ENGADGET MAIN</span> 
			<span> <a href="sub-unsub.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">unsub</a></span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&freq=300&store=all">subscribe</a> </span>
			<span> rss 2.0, remote, 5 minute frequency, store all, NYT HEADLINE NEWS</span>
			<span> <a href="sub-unsub.xqy?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml">unsub</a></span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&store=all">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store all, GOOG HEADLINE NEWS </span>
			<span> <a href="sub-unsub.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom">unsub</a></span>
		</div>		
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://rss.slashdot.org/Slashdot/slashdot&freq=300&store=all">subscribe</a> </span>
			<span> rss 1.0, remote, 5 minute frequency, store all, SLASHDOT MAIN</span> 
			<span> <a href="sub-unsub.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">unsub</a></span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://slashdot.org/slashdot.rdf&freq=300&store=all">subscribe</a> </span>
			<span> rss 0.9, remote, 5 minute frequency, store all, SLASHDOT MAIN</span>
			<span> <a href="sub-unsub.xqy?url=http://slashdot.org/slashdot.rdf">unsub</a></span>
		</div>
	    <div>SUBSCRIBE: ITEM STORE</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&domain=eng&store=all">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store all GOOG HEADLINE NEWS </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&store=40&domain=eng2">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store 40, GOOG HEADLINE NEWS </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&store=10&domain=eng3">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store 10, GOOG HEADLINE NEWS </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&store=current&domain=eng4">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store current, GOOG HEADLINE NEWS </span>
		</div>
	    <div>SUBSCRIBE: VERSION</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&freq=300&store=all&version=true&domain=ver">subscribe</a> </span>
			<span> rss 2.0, remote, 5 minute frequency, store all, version, ENGADGET MAIN</span> 
			<span> <a href="sub-unsub.xqy?url=http://feeds.engadget.com/weblogsinc/engadget">unsub</a></span>
		</div>
    	<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&freq=300&store=all&version=true&domain=ver">subscribe</a> </span>
			<span> rss 2.0, remote, 5 minute frequency, store all, version NYT HEADLINE NEWS </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&store=all&version=true&domain=ver">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store all, version GOOG HEADLINE NEWS </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://news.google.com/news%3Fned%3Dus%26output%3Datom&freq=300&store=10&version=true&domain=ver">subscribe</a> </span>
			<span> atom 0.3, remote, 5 minute frequency, store 10, version GOOG HEADLINE NEWS </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://rss.slashdot.org/Slashdot/slashdot&freq=300&store=all&version=true&domain=ver">subscribe</a> </span>
			<span> rss 1.0, remote, 5 minute frequency, store all, version, SLASHDOT MAIN</span> 
			<span> <a href="sub-unsub.xqy?url=http://rss.slashdot.org/Slashdot/slashdot">unsub</a></span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://slashdot.org/slashdot.rdf&freq=300&store=all&version=true&domain=ver">subscribe</a> </span>
			<span> rss 0.9, remote, 5 minute frequency, store all, version, SLASHDOT MAIN</span>
			<span> <a href="sub-unsub.xqy?url=http://slashdot.org/slashdot.rdf">unsub</a></span>
		</div>

        <div>SUBSCRIBE: EDGE CASES</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://slashdot.org/slashdot.rdf">subscribe</a> </span>
			<span> rss 0.9, remote, multi redirects</span>
			<span> <a href="sub-unsub.xqy?url=http://slashdot.org/slashdot.rdf">unsub</a></span>
		</div>		
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://localhost:8010/feed/test-scripts/data/engadget.xml&freq=10">subscribe</a> </span>
			<span> rss 2.0, local, 10 second frequency</span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub-opt.xqy?url=http://www.stikkit.com/stikkits.atom%3Fapi_key%3Ded93115ae0c1a1162d32cc0bb940f30e&freq=3600">subscribe</a> </span>
			<span> atom 1.0 (minimum), remote</span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub.xqy?url=http://localhost:8010/feed/test-scripts/data/kottke.xml">subscribe</a> </span>
			<span> rss 2.0, local, incomplete tags in title </span>
		</div>
		<div>
			<span>Subscribe to Feed</span>
			<span><a href="sub.xqy?url=http://www.apple.com/main/rss/hotnews/hotnews.rss">subscribe</a> </span>
			<span> rss 2.0, remote, had conflicting item updates </span>
		</div>
		<br/>
		<div>UNSUBSCRIBE</div>
		<div>
			<span>Unsubscribe from Feed</span>
			<span>&nbsp;<a href="sub-opt.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&freq=300&store=all&version=true&domain=unsub">sub</a></span>
			<span>&nbsp;<a href="sub-unsub.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&dom=unsub&arch=true">unsub arch</a> </span>
			<span>&nbsp;<a href="sub-unsub.xqy?url=http://feeds.engadget.com/weblogsinc/engadget&dom=unsub&arch=false">unsub no arch</a> </span>
		</div>
	    <br/>
		<div>BULK SUBSCRIPTION</div>
        <div>
            <input type="text" id="opml" value="feed/test-scripts/data/"></input>
            <input type="button" value="subscribe" onclick="window.location.href=('sub-opml.xqy?file=' + escape(document.getElementById('opml').value));"></input>
        </div>
		<div>	
			<span>100</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_cnet100.opml&store=all">sub cnet 100</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>	
			<span>300+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_google-reader.opml&store=all">sub goog</a>&nbsp;&nbsp;&nbsp;</span>
		</div>   
		<div>
			<span>550+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_scoble.opml&store=all">sub scoble</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>
			<span>100+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_volume.opml&store=all">sub volume</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>
			<span>100+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_women.opml&store=all">sub women bloggers</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>
			<span>20+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_podcast.opml&store=all">sub podcasts</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>
			<span>30+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_nptech.opml&store=all">sub non-profit tech</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>
			<span>60+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_digg.opml&store=all">sub digg feeds</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<div>
			<span>90+</span>
			<span><a href="sub-opml.xqy?file=feed/test-scripts/data/opml_winer.opml&store=all">sub winer</a>&nbsp;&nbsp;&nbsp;</span>
		</div>
		<br/>
		<div>SUBSCRIPTION LOOP</div>
        <div>
			<span>subscriptions request - once</span>
			<span><a href="../subscription-check.xqy">run</a></span>
		</div>
		<br/>
		<div>SUBSCRIPTION LISTS</div>
        <div>
			<span>subscription</span>
			<span>&nbsp;<a href="sub-list-sub.xqy">list</a></span>
			<span>&nbsp;<a href="sub-col-sub.xqy">col</a></span>
			<span>&nbsp;<a href="sub-doc-sub.xqy">doc</a></span>
		</div>
        <div>
			<span>description</span>
			<span>&nbsp;<a href="sub-list-desc.xqy">list</a></span>
			<span>&nbsp;<a href="sub-col-desc.xqy">col</a></span>
			<span>&nbsp;<a href="sub-doc-desc.xqy">doc</a></span>
		</div>
        <div>
			<span>item</span>
			<span>&nbsp;<a href="sub-list-item.xqy">list</a></span>
			<span>&nbsp;<a href="sub-col-item.xqy">col</a></span>
			<span>&nbsp;<a href="sub-doc-item.xqy">doc</a></span>
		</div>
		<br/>
		<div>DELETE</div>
		    <div>
			        <span>subscriptions</span>
			        <span>&nbsp;<a href="sub-del-sub.xqy">del col</a></span>
			        <span>&nbsp;<a href="sub-del-sub-doc.xqy">del docs</a></span>
			</div>
			<div>
			        <span>descriptions</span>
			        <span>&nbsp;<a href="sub-del-desc.xqy">del col</a></span>
			        <span>&nbsp;<a href="sub-del-desc-doc.xqy">del docs</a> </span>
			</div>
			<div>
			        <span>items</span>
			        <span>&nbsp;<a href="sub-del-item.xqy">del col</a></span>
			        <span>&nbsp;<a href="sub-del-item-doc.xqy">del docs</a> </span>
            </div>

	</body>
</html>