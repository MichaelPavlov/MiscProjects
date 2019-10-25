<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 1.7                                                              #
# REVISION: 000										     #
# DATE    : 17/08/2005                                                       #
##############################################################################
# All source code, images, programs, files included in this package          #
# Copyright (c) 2003-2004                                                    #
#		    XL Corp.		  						     #
#           www.xlcorp.co.uk                                                 #
#           www.start-your-casino.com                                        #
#           All Rights Reserved.                                             #
##############################################################################
#                                                                            #
#    While we distribute the source code for our scripts/software and you    #
#    are allowed to edit them to better suit your needs, we do not           #
#    support modified code.  Please see the license prior to changing        #
#    anything. You must agree to the license terms before using this         #
#    software package or any code contained herein.                          #
#                                                                            #
#    Any redistribution without permission of XL Corp.                       #
#    is strictly forbidden.                                                  #
#                                                                            #
##############################################################################

//error_reporting(0);
session_start();
require('../scripts/connect.php');

if ( isset ($_REQUEST['mode'])) { $mode=$_REQUEST['mode']; }
if ( isset ($_REQUEST['type'])) { $type=$_REQUEST['type']; }

if ( $mode != "DEMO" ){
if( !isset($_SESSION["enter"])||!isset($_SESSION["userid"]) ){ header("location:$siteurl/login.php"); }
}

$userid=$_SESSION["userid"];

$sid=session_id();
mysql_query("replace into `session` values('$sid', $userid, ".time()." )");

?>
<html>

<head>
<title><?=$sitename?>!</title>
<meta name="Copyright" content="<?=$sitename?> © All Rights Reserved">
<link href="../html/style.css" type="text/css" rel="stylesheet">

<style>
body {
  margin:0;
  border:0;
  padding:0;
  height:100%; 
  max-height:100%; 
  overflow: hidden; 
  }
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#000000" background="../images/bg2.gif">

<script language="JavaScript">
<!--
self.resizeTo(750,550);
window.status='';
function click() {
if (event.button==2) {
alert('Copyright content © by <?=$sitename?>.')
}}
document.onmousedown=click

// -->
</script>

<? if (!$type){ 
include('lobby.php');
} ?>

<table width="100%" height="90%" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
<tr align="center">

<? if ( ( $_REQUEST['type'] >= 1) && ( $_REQUEST['type'] <= 4) ) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="roulette.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="roulette.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if ( ( $_REQUEST['type'] >= 11) && ( $_REQUEST['type'] <= 14) ) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="baccarat.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="baccarat.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if ( ( $_REQUEST['type'] >= 21) && ( $_REQUEST['type'] <= 24) ) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="blackjack.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="blackjack.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if ( ( $_REQUEST['type'] >= 31) && ( $_REQUEST['type'] <= 34) ) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="keno.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="keno.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 41) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="poker2.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="poker2.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 42) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="poker.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="poker.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 43) { 
$result=mysql_query("select `amount` from `jackpot` where `type`=$type");
$jackpot=mysql_result($result, 0, "amount");
?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="poker2jp.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>&jp=<?=$jackpot?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="poker2jp.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>&jp=<?=$jackpot?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 44) { 
$result=mysql_query("select `amount` from `jackpot` where `type`=$type");
$jackpot=mysql_result($result, 0, "amount");
?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="pokerjp.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>&jp=<?=$jackpot?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="pokerjp.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>&jp=<?=$jackpot?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 51) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="slots2.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="slots2.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 50) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="slots.swf?u=<?=$sid?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="slots.swf?u=<?=$sid?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } if( $_REQUEST['type'] == 54) { ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="slotsjp.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<embed src="slotsjp.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } ?>

</tr>
</table>
<? include('footer.php'); ?>
</body>

</html>
