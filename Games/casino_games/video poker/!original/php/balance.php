<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 1.05                                                             #
# REVISION: 001										     #
# DATE    : 24/03/2005                                                       #
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

error_reporting(0);
require('../scripts/connect.php');
if( isset($_POST["uid"]) ){ $userid=$_POST["uid"]; }else{ exit; }

//Get Balance
list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$balance = sprintf ("%01.2f", $balance);

//Check for UserID 0
if ($userid==0){
$balance=0;
}

//Send Answer
$answer="&ans=OK&amount=".$balance;
echo $answer;
?>