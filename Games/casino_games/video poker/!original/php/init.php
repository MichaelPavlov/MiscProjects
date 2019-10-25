<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 2.0                                                              #
# REVISION: 000										     #
# DATE    : 01/06/2006                                                       #
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

if ($_SERVER["SERVER_NAME"] != "www.3-red.com") { exit; }
$tm=time();
$dm=date("m", $tm);
//if (($dm!='03') && ($dm!='04')) {exit;}

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
require("../scripts/connect.php");

$diff=time()-3600;
mysql_query("delete from `session` where `time`<$diff");
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");

if(mysql_num_rows($result)){ // session correct
	$userid=mysql_result($result, 0, "userid");
	mysql_query("update `session` set `time`=".time()." where `sid`='$sid'");

	//user balance
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
	$balance = sprintf ("%01.2f", $balance); 

	echo "rbl=valid&bln=".$balance."&u=".$sid;
}else{ // session is over
	mysql_query("delete from `session` where `sid`='$sid'");
	echo "rbl=ivalid";
}
?>


