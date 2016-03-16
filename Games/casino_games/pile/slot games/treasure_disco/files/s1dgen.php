<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 2.03                                                             #
# REVISION: 015										     #
# DATE    : 01/11/2008                                                       #
##############################################################################
# All source code, images, programs, files included in this package          #
# Copyright (c) 2003-2010                                                    #
#		    XLNET Ltd.		  						     #
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
// demo generator

///////////////////// functions //////////////////////
function Gen(){
	$res=rand(0, 680);
	if( $res<50 ){ $n=6; }
	if( ($res>=50)&&($res<250) ){ $n=5; }
	if( ($res>=250)&&($res<400) ){ $n=4; }
	if( ($res>=400)&&($res<500) ){ $n=3; }
	if( ($res>=500)&&($res<600) ){ $n=2; }
	if ($res >= 600 && ($res < 650)) { $n = 1; }
	if ($res >= 650) { $n = 7; }
	return $n;
}
//

function countLine($a, $b, $c){
	global $win, $bet;
	if( ($a==$b)&&($b==$c) ){
		switch ($a){
			case 1: $win = 1000 * $bet; break;
			case 2: $win = 500 * $bet; break;
			case 3: $win = 200 * $bet; break;
			case 4: $win = 100 * $bet; break;
			case 5: $win = 50 * $bet; break;
			case 6: $win = 20 * $bet; break;
			case 7: $win = 10 * $bet; break;
			//case 7: $win = bonus; break; // Bonus game here
		}
	}else{		
		if (($a == 4) || ($b == 4) || ($c == 4)) {
			$win = $bet;
		} //1x
	}
}

///////////////////// MAIN //////////////////////
//error_reporting(E_ALL);
//include("../scripts/config.php");
//$connection=mysql_connect($host,$user,$password);
//if(!$connection){ exit; }
//mysql_select_db($dbname);

if( !isset($_POST["b"]) ){ exit; }
$bet=$_POST["b"];
$bet = sprintf ("%01.2f", $bet); 

// start game;
	$win=0;
	$n1=Gen();
	$n2=Gen();
	$n3=Gen();
	$n4=Gen();
	$n5=Gen();
	$n6=Gen();
	$n7=Gen();
	$n8=Gen();
	$n9=Gen();
//remove 2 bonuses in a row
	if (($n1==0)&&($n4==0)){$n1=Gen();}
	if (($n4==0)&&($n7==0)){$n7=Gen();}
	if (($n2==0)&&($n5==0)){$n2=Gen();}
	if (($n5==0)&&($n8==0)){$n8=Gen();}
	if (($n3==0)&&($n6==0)){$n3=Gen();}
	if (($n6==0)&&($n9==0)){$n9=Gen();}
	countLine($n4, $n5, $n6);
$win = sprintf ("%01.2f", $win); 
// send answer
$answer="&ans=res&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9;
echo $answer;
?>