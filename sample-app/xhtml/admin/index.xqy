default element namespace="http://www.w3.org/1999/xhtml"

import module namespace feed="http://marklogic.com/xdmp/feed" at "../../../lib/feed.xqy"

<html>
	<head>
	    <link rel="stylesheet" href="../../style/feed.css" type="text/css"></link>
	</head>
	<body  LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">

	<table width="100%" height="91%">
	<tr height="100%">
    	<td width="420px" height="100%">	
        	<iframe src="index-admin-control.xqy" id="admin-control" name="admin-body" height="100%" width="100%"
        	        marginheight="0"  marginwidth="0" frameborder="0">    
            </iframe>
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