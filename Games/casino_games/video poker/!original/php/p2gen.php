<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 2.00                                                             #
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
error_reporting(0);
require('../scripts/connect.php');

//////////////////////  if script doesn`t get correct data it exits  //////////////////////////
if( isset($_POST["et"]) ){ $stage=$_POST["et"]; }else{ exit; }
if( isset($_POST["bt"]) ){ $total_bet=$_POST["bt"]; }else{ exit; }
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=41; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

$total_bet = sprintf ("%01.2f", $total_bet); 

//Genuine User Check
if ($userid == 0) { exit; }

///////////////////////////// objects //////////////////////////////////////
class Card{
	var $worth=-1;
	var $suit=-1;
	var $num=-1;
	function Card($w,$s,$n){
		$this->worth=$w;
		$this->suit=$s;
		$this->num=$n;
	}
}
///////////////////////////// functions ////////////////////////////////////
// calculate casino balance and define max posible winning
function calWinLimit(){
	if ($_POST["tp"]==41){
		$result=mysql_query("select * from `settings` where `type`='41'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==42){
		$result=mysql_query("select * from `settings` where `type`='42'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==43){
		$result=mysql_query("select * from `settings` where `type`='43'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==44){
		$result=mysql_query("select * from `settings` where `type`='44'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else{
		$result=mysql_query("select * from `settings` where `type`='42'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}

	// Get max. win. amount
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` where `date`>$xdate AND (`type`='w' OR `type`='co' OR `type`='l')"));
	$balance=-$balance;

	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }
	return $maxwin;
}

// make cards from string got from .swf file
function makeCards($card_str){
	$cards=array();
	$temp_worth=array();
	$temp_suit=array();
	$temp=explode("!", $card_str);
	foreach($temp as $crd){
		if($crd){
			$temp2=explode("@",$crd);
			array_push($temp_worth, $temp2[0]);
			array_push($temp_suit, $temp2[1]);
		}
	}

	$num=count($temp_worth);
	for($i=0;$i<$num;$i++){
		switch($temp_worth[$i]){
			case "c_2": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 2 ) ); break;
			case "c_3": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 3 ) ); break;
			case "c_4": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 4 ) ); break;
			case "c_5": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 5 ) ); break;
			case "c_6": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 6 ) ); break;
			case "c_7": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 7 ) ); break;
			case "c_8": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 8 ) ); break;
			case "c_9": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 9 ) ); break;
			case "c_10": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 10 ) ); break;
			case "c_J": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 11 ) ); break;
			case "c_Q": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 12 ) ); break;
			case "c_K": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 13 ) ); break;
			case "c_A": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 14 ) ); break;
		}
	}
	return $cards;
}
// generate random card and make sure it is unique
function generateCards(){
	global $all_cards;
	$card=0;
	do{
		$suit=rand(1,4);
		$worth=rand(0,12);
		switch($worth){
			case 0: $card=new Card( "c_2", $suit, 2); break;
			case 1: $card=new Card( "c_3", $suit, 3); break;
			case 2: $card=new Card( "c_4", $suit, 4); break;
			case 3: $card=new Card( "c_5", $suit, 5); break;
			case 4: $card=new Card( "c_6", $suit, 6); break;
			case 5: $card=new Card( "c_7", $suit, 7); break;
			case 6: $card=new Card( "c_8", $suit, 8); break;
			case 7: $card=new Card( "c_9", $suit, 9); break;
			case 8: $card=new Card( "c_10", $suit, 10); break;
			case 9: $card=new Card( "c_J", $suit, 11); break;
			case 10: $card=new Card( "c_Q", $suit, 12); break;
			case 11: $card=new Card( "c_K", $suit, 13); break;
			case 12: $card=new Card( "c_A", $suit, 14); break; 
		}

		// check is it unique
		$is_new=true;
		for($i=0; $i<count($all_cards); $i++){
			if( ($all_cards[$i]->worth==$card->worth)&&($all_cards[$i]->suit==$card->suit) ){ $is_new=false; }
		}
	}while(!$is_new); // if card not unique - generate it again
	array_push($all_cards, $card);
	return $card;
}
//
function DefineHands($cards){
	$hands=array("Royal Flush", "Strait Flush", "Four of a kind", "Full House", "Flush", "Strait", "Three of a kind", "Two Pair", "Tens or Better");
	$hand="No hands";
	$worthes=array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	$worth=array();
	$suit=array();
	for($i=0; $i<5; $i++){
		$n=$cards[$i]->num;
		$worthes[$n]++;
		array_push($worth, $n);
		array_push($suit, $cards[$i]->suit);
	}
	sort($worth);
	$Three=false;
	$Pair=false;
	for($i=2; $i<=14; $i++){
		if($worthes[$i]==4){ $hand=$hands[2]; $worthes[$i]=0; break; }
		if($worthes[$i]==3){ $Three=true; $worthes[$i]=0; break; }
		if($worthes[$i]==2){ $Pair=$i; $worthes[$i]=0; break; }
	}
	$Pair2=false;
	for($i=2; $i<=14; $i++){
		if($worthes[$i]==3){ $Three=true; $worthes[$i]=0; break; }
		if($worthes[$i]==2){ $Pair2=true; $worthes[$i]=0; break; }
	}
	if($Pair){
		if($Pair2){ $hand=$hands[7]; }
		else{ 
			if($Pair>9){ $hand=$hands[8]; }
		}
	}
	if($Three){
		if($Pair2||$Pair){ $hand=$hands[3]; }
		else{ $hand=$hands[6]; }
	}
	// define is it Strait
	$strait=false;
	$frst=$worth[0];
	if( ($worth[1]==($frst+1))&&($worth[2]==($frst+2))&&($worth[3]==($frst+3))&&($worth[4]==($frst+4)) ){
		$strait=true;
		$hand=$hands[5];
	}
	elseif($worth[4]==14){ // if there is Ace
			$frst=1; // count Ace as 1
			if( ($worth[0]==2)&&($worth[1]==3)&&($worth[2]==4)&&($worth[3]==5) ){
				$strait=true;
				$hand=$hands[5];
			}
	}
	// define is it Flush
	$flush=false;
	if( ($suit[0]==$suit[1])&&($suit[1]==$suit[2])&&($suit[2]==$suit[3])&&($suit[3]==$suit[4]) ){
		$flush=true;
		$hand=$hands[4];
	}	
	// define is it Strait Flush or Royal Flush
	if( $strait&&$flush ){
		$hand=$hands[1];
		if($worth[0]==10){ $hand=$hands[0]; }
	}	
	return $hand;
}

////////////////////////////// MAIN /////////////////////////////////////////////////////////////////////////////////////////
if($stage==1){ // user start game
	// start transaction
	$maxwin=calWinLimit();
	$win_limit = sprintf ("%01.2f", $maxwin); 
	$tm=time();
	mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");
	mysql_query("insert into `games` values('', '$userid', '$tm', '$total_bet', '-1', 'l', '-$total_bet','$game_type')");
	$gameid=mysql_insert_id();
	mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', 'l', '-$total_bet','$win_limit')");
	$trans_id=mysql_insert_id();

	// user balance

list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

	//Adding max win checking for the initial 5 cards
	$maxwin=calWinLimit();
	// generate 5 cards and save them to DB
do{
	$all_cards=array();
	for($i=0; $i<5; $i++){ generateCards(); }
	$cards="";
	foreach($all_cards as $card){ $cards.=$card->worth."@".$card->suit."!"; }
	$hand=DefineHands($all_cards);
	$win=0;
	$hd=99;
	switch($hand){
		case "Royal Flush":     $win=$total_bet*250; $hd=0; if($total_bet==5){ $win=5000; }; break;
		case "Strait Flush":    $win=$total_bet*50;  $hd=1; break;
		case "Four of a kind":  $win=$total_bet*20;  $hd=2; break;
		case "Full House":      $win=$total_bet*7;   $hd=3; break;
		case "Flush":           $win=$total_bet*5;   $hd=4; break;
		case "Strait":          $win=$total_bet*4;   $hd=5; break;
		case "Three of a kind": $win=$total_bet*3;   $hd=6; break;
		case "Two Pair":        $win=$total_bet*2;   $hd=7; break;
		case "Tens or Better": $win=$total_bet*1;   $hd=8; break;
	}
	$diff=$win-$total_bet;
}while($diff>$maxwin); // Deal new cards.
//}while($hd<7); // Deal new cards. Initial deal can not be better than "Ten or Better

	mysql_query("update `games` set `bet`='$cards' where `gameid`='$gameid'");
	// send to client transaction id, 5 card, new user balance
	echo "&ans=OK1&ti=".$trans_id."&cd=".$cards."&ub=".$user_balance;
}


elseif($stage==2){ // user hold some cards and wait for new ones
	// take cards from DB
	$trans_id=$_POST["ti"];
	$result=mysql_query("select `gameid` from `transactions` where `transid`='$trans_id'");
	$gameid=mysql_result($result, 0, 0);
	$result=mysql_query("select `bet` from `games` where `gameid`='$gameid'");
	$cards=mysql_result($result, 0, 0);
	$maxwin=calWinLimit();
do{
	$all_cards=makeCards($cards);
	// generate new cards in place of user not holded
	$holded=explode("!", $_POST["holded"]);
	$new_cards=array();
	for($i=0; $i<5; $i++){
		$new_cards[$i]=generateCards();
	}
	$h=count($holded)-1;
	for($j=0; $j<$h; $j++){
		$i=$holded[$j];
		$new_cards[$i]=$all_cards[$i];
	}
	// update cards in DB
	$cards="";
	foreach($new_cards as $card){ $cards.=$card->worth."@".$card->suit."!"; }
	mysql_query("update `games` set `bet`='$cards' where `gameid`='$gameid'");
	// calculate game result
	$hand=DefineHands($new_cards);
	$win=0;
	$hd=99;
	switch($hand){
		case "Royal Flush":     $win=$total_bet*250; $hd=0; if($total_bet==5){ $win=5000; }; break;
		case "Strait Flush":    $win=$total_bet*50;  $hd=1; break;
		case "Four of a kind":  $win=$total_bet*20;  $hd=2; break;
		case "Full House":      $win=$total_bet*7;   $hd=3; break;
		case "Flush":           $win=$total_bet*5;   $hd=4; break;
		case "Strait":          $win=$total_bet*4;   $hd=5; break;
		case "Three of a kind": $win=$total_bet*3;   $hd=6; break;
		case "Two Pair":        $win=$total_bet*2;   $hd=7; break;
		case "Tens or Better": $win=$total_bet*1;   $hd=8; break;
	}
	$diff=$win-$total_bet;
}while($diff>$maxwin); // Deal new cards that will not cause winning over maxwin

	// if user lost - close transaction
	if($win==0){ mysql_query("update `games` set `bet`='$total_bet' where `gameid`='$gameid'"); }
	
	// send to client new cards, transaction id, game result
	echo "&ans=OK2&ti=".$trans_id."&cd=".$cards."&w=".$win."&h=".$hd;
}
elseif($stage==3){ // user press `collect` and get his win
	// update user balance
	// close transaction
	$trans_id=$_POST["ti"];
	$win=$_POST["w"];
	$amount=$win-$total_bet;
	if($amount>0){ $type="w"; }else{ $type="l"; }
	mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");
	mysql_query("update `transactions` set `amount`='$amount', `type`='$type' where `transid`='$trans_id'");

	//user balance
	list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
	$user_balance = sprintf ("%01.2f", $user_balance); 

	$result=mysql_query("select `gameid` from `transactions` where `transid`='$trans_id'");
	$gameid=mysql_result($result, 0, 0);
	mysql_query("update `games` set `bet`='$total_bet', `amount`='$amount', `result`='$type' where `gameid`='$gameid'");
	echo "&ans=OK3&ub=".$user_balance;
}
elseif($stage==4){ // user press `double` and start double game
	// generate one card and update cards in DB
	$trans_id=$_POST["ti"];
	$all_cards=array();
do{
	$card=generateCards();
	$cd=$card->worth."@".$card->suit."!";
}while($card->worth == "c_2"); // Make the double card != 2, so player can loose
	$result=mysql_query("select `gameid` from `transactions` where `transid`='$trans_id'");
	$gameid=mysql_result($result, 0, 0);
	mysql_query("update `games` set `bet`='$cd' where `gameid`='$gameid'");
	// send to client one card, transaction id
	echo "&ans=OK4&ti=".$trans_id."&cd=".$cd;
}
elseif($stage==5){ // user press `deal` and wait double game result
	$trans_id=$_POST["ti"];
	$ccard=$_POST["crd"];
	$win=$_POST["w"];
	$result=mysql_query("select `gameid` from `transactions` where `transid`='$trans_id'");
	$gameid=mysql_result($result, 0, 0);
	$result=mysql_query("select `bet` from `games` where `gameid`='$gameid'");
	$cards=mysql_result($result, 0, 0);
	$maxwin=calWinLimit();
do{
	$win=$_POST["w"];
	$all_cards=array();
	$all_cards=makeCards($cards);
	// generate 4 cards
	// calculate game result
	for($i=0; $i<4; $i++){
		$new_cards[$i]=generateCards();
	}
	$num1=$all_cards[0]->num;
	$num2=$all_cards[$ccard]->num;
	if($num1>$num2){ $res=0; $win=0; }      	// player lost
	elseif($num1==$num2){ $res=1; } 		// draw game
	else{ $res=2; $win*=2; }                  // player win
	$diff=$win-$total_bet;
}while($diff>$maxwin); 					// Double can win only is double < maxwin

	// if user lost - close transaction
	if($res==0){ mysql_query("update `games` set `bet`='$total_bet' where `gameid`='$gameid'"); }
	// send to client 4 new cards, transaction id, game result
	$cards="";
	for($i=1; $i<5; $i++){
		$cards.=$all_cards[$i]->worth."@".$all_cards[$i]->suit."!";
	}
	echo "&ans=OK5&ti=".$trans_id."&cd=".$cards."&w=".$win."&res=".$res;
}
?>