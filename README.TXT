This is the README file for the Mark Logic Feed API
Feed API version 1.0


This API provides a library to access and subscribe to feeds.
It supports RSS 2.0, RSS 1.0, and Atom 1.0
It requires Mark Logic Server 3.2 or later and the dates module from commons
available here: http://xqzone.marklogic.com/svn/commons/trunk/dates/


INSTALLATION
Install the feed directory at the root level of the application server.
The Task Server 'time limit' must be configured to allow reasonable time 
to make http requests for feed documents.

This API requires the dates module from commons. The dates module should 
also be installed at the server root.

Both the feed and dates modules can be installed in other directories, but the
references to the modules must be modified accordingly.

This API requires a directory that the library can read and write to.
Currently this directory is set to /var/tmp.
This setting can be changed in feed/lib/feed.xqy

This API requires xdmp:eval, xdmp:invoke, xdmp:spawn, and xdmp:save permissions.


OVERVIEW
This API contains three sub-directories: lib, test-scripts, and sample-app

lib
	lib contains the feed API modules
	feed.xqy is the primary module containing functions used to process and access feed documents.
	all of the documented API calls are found in this module. Supporting functions are found in lib/actions.
	
	lib/actions/subscription-request.xqy is used by external modules or programs to request an update to a subscription.
	the admin sub-directory contains an example (feed/sample-app/lib/subscription-check.xqy).
	when it is time to check for the latest feed document of a particular subscription, this module
	should be called.
	
	the other modules are simple helper modules used to manage transactions when requesting feeds.

test-scripts	
	test-scripts contains a set of raw testing links. in order to access the tests via a browser
	set up an app server that points to the mark logic server root. the test scripts can then be accessed here:
	<app-server-root>/feed/test
	
sample-app
	sample-app contains a simple administration application for the feed API that also illustrates
	how to use the feed API. in order to access it an app server must be set up that points to the
	mark logic server root. the admin application can then be accessed here: <app-server-root>/feed/admin

	the admin application has at least one example for each of the api calls. it also has an example
	that shows how to update feed subscriptions once they have been created. The calling of the 
	subscription update query is teh responsibility of the API programmer rather than be embedded in the API itself. All of
	the code can be found in feed/admin/lib. The example that updates the subscriptions is
	feed/admin/lib/subscription-check.xqy. this process can be automated through the use of wget and a cron job.
	
	there are several sub-directories in sample-app aside from lib. lib contains the XQuery modules
	that map to the admin functions. style contains a stylesheet for web rendering. xhtml contains
	.xqy modules that generate XHTML pages.
	

PERFORMANCE TUNING
When using this library to subscribe and then later access large numbers of
feed items, the following configurations are suggested

   Database Configuration
   stemmed searches: advanced
   word searches: true
   word positions: true  
   fast phrase searches: true   
   fast element word searches: true
   element word positions: true
   fast element phrase searches: true   
   trailing wildcard searches: true
   trailing wildcard word positions: true
   three character wsearches: true
   reindexer enable: true
   reindexer throttle: 5
     
   Element Range Index
   scalar: dateTime
   namespace: http://marklogic.com/xdmp/feed
   local name: published
   
   Attribute Range Index
   scalar: unsignedLong
   namespace: http://marklogic.com/xdmp/feed
   local element name: subscription
   local attribute name: id
   
   Attribute Range Index
   scalar: unsignedLong
   namespace: http://marklogic.com/xdmp/feed
   local element name: description
   local attribute name: id
   
   Attribute Range Index
   scalar: unsignedLong
   namespace: http://marklogic.com/xdmp/feed
   local element name: item
   local attribute name: id
   
   scalar: string
   namespace: http://marklogic.com/xdmp/feed
   local element name: subscription
   local attribute name: status
   
   Word Query 
   Includes
   local name: title         namespace: http://marklogic.com/xdmp/feed
   local name: detail        namespace: http://marklogic.com/xdmp/feed 