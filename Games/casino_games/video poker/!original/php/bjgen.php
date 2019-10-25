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
require("../scripts/connect.php");
//////////////////////  if script doesn`t get correct data it exits  //////////////////////////
if( isset($_POST["et"]) ){ $stage=$_POST["et"]; }else{ exit; }
if( isset($_POST["bt"]) ){ $total_bet=$_POST["bt"]; }else{ exit; }
if ( isset($_POST["ti"]) ) { $trans_id=$_POST["ti"]; }
if ( isset($_POST["gi"]) ) { $gameid=$_POST["gi"]; }
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=23; }

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

$total_bet = sprintf ("%01.2f", $total_bet); 
$tm=time();

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
	if ($_POST["tp"]==21){
		$result=mysql_query("select * from `settings` where `type`='21'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==22){
		$result=mysql_query("select * from `settings` where `type`='22'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==23){
		$result=mysql_query("select * from `settings` where `type`='23'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==24){
		$result=mysql_query("select * from `settings` where `type`='24'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else{
		$result=mysql_query("select * from `settings` where `type`='23'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}

	// Get max. win. amount
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `games` where `date`>$xdate"));
	$balance=-$balance;
	list($cashout) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` where `date`>$xdate AND `type`='co'"));
	$balance=($balance-$cashout);

// Every XX game is lost automatically.
/*
	$result=mysql_query("select * from `transactions` where `date`>$xdate AND (`type`='l' OR `type`='w' OR `type`='co') ");
	$max=mysql_num_rows($result);

	if( !($max%15) ){ $maxwin=-1; } // Every 15th game is lost automatically.
	else{ $maxwin=$balance*$coef/100; }
*/
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
			case "c_J": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 10 ) ); break;
			case "c_Q": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 10 ) ); break;
			case "c_K": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 10 ) ); break;
			case "c_A": array_push( $cards, new Card( $temp_worth[$i], $temp_suit[$i], 11 ) ); break;
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
			case 9: $card=new Card( "c_J", $suit, 10); break;
			case 10: $card=new Card( "c_Q", $suit, 10); break;
			case 11: $card=new Card( "c_K", $suit, 10); break;
			case 12: $card=new Card( "c_A", $suit, 11); break; 
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

////////////////////////////// MAIN /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Take off bet from user balance in DB /////////////////////////////////////////////////////////
// user press `Deal` and start game - remove bet from his balance and start transaction
if($stage==17){
	mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");
	// write game and transaction

	mysql_query("insert into `games` values('', '$userid', '$tm', '$total_bet', '-1', 'l', '-$total_bet','$game_type')");
	$gameid=mysql_insert_id();
	mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', 'l', '-$total_bet','BJ_NEW')");
	$trans_id=mysql_insert_id();

	// send to client side transaction id
	echo "&ans=OK&ti=".$trans_id."&gi=".$gameid;
}
// each time user press `Split` or `Double` buttons
if($stage==18){
	// update transaction amount, add 1/2 of the doubled bet
	$maxwin=calWinLimit();
	mysql_query("update `transactions` set `amount`=`amount`-$total_bet/2, `comments`='$win_limit' where `transid`='$trans_id'");
	mysql_query("update `games` set `amount`=`amount`-$total_bet where `gameid`='$gameid'");

	echo "&ans=OK&ti=".$trans_id."&gi=".$gameid;
}

// user get over 21 - game lost
elseif($stage==45){
	$maxwin=calWinLimit();
	$win_limit = sprintf ("%01.2f", $maxwin); 
	mysql_query("update `transactions` set `date`='$tm', `comments`='$win_limit' where `transid`='$trans_id'");

	echo "&ans=Ov";
}

// user get insurance
elseif($stage==19){
	$insurance=$_POST["ins"];
	$ptb=$_POST["pbt"];
//	$trans_id=$_POST["ti"];

	// update transaction amount - remove imsurance

	mysql_query("update `transactions` set `amount`=`amount`-$insurance, `comments`='$win_limit'  where `transid`='$trans_id'");
	mysql_query("update `games` set `amount`=`amount`-$insurance where `gameid`='$gameid'");

	$dealer_cards=makeCards($_POST["dc"]);
	array_push($dealer_cards, generateCards());

	$dealer_score=$dealer_cards[0]->num+$dealer_cards[1]->num;
	$dealer_bj=0;
	if( (count($dealer_cards)==2)&&($dealer_score==21) ){ $dealer_bj=1; }
	
	// dealer has blackjack - end game
	if($dealer_bj){	
		// mark transaction as game lost - `l` and set it`s time
		mysql_query("update `transactions` set `date`='$tm', `type`='w', `amount`=0 , `comments`='$win_limit' where `transid`='$trans_id'");
		mysql_query("update `games` set `result`='w', `amount`=0 where `gameid`='$gameid'");
	}

list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

	$dc2 = $dealer_cards[1]->worth."@".$dealer_cards[1]->suit;
	mysql_query("update `transactions` set `comments`='$dc2' where `transid`='$trans_id'");
	$cd="";
	foreach($dealer_cards as $card){
		$cd.=$card->worth."@".$card->suit."!";
	}
	$answer="&ans=Ins&cd=".$cd."&dbj=".$dealer_bj."&ti=".$trans_id."&ub=".$user_balance."&gi=".$gameid;
	echo $answer;
}

////////////////////////////// Generate game results /////////////////////////////////////////////////////////
elseif($stage==23){ 

	//////////////////////  get data  //////////////////////////
	$player1_cards=makeCards($_POST["pc"]);
	$player1_score=$_POST["psc"];
	$player1_bet=$_POST["pbt"];
	$player1_bj=$_POST["pbj"];
	if($player1_bj=="false"){ $player1_bj=0; }
	$player1_insurance=$_POST["pi"];
	if($player1_insurance=="false"){ $player1_insurance=0; }
	
	if( $_POST["p2c"] ){
		$player2=true;
		$player2_cards=makeCards($_POST["p2c"]);
		$player2_score=$_POST["p2sc"];
		$player2_bet=$_POST["p2bt"];
		$player2_bj=$_POST["p2bj"];
		if($player2_bj=="false"){ $player2_bj=0; }
	}
	else{ $player2=false; }

	$dealer_cards=makeCards($_POST["dc"]);

	$all_cards=array_merge($player1_cards, $dealer_cards);
	if($player2){ $all_cards=array_merge($all_cards, $player2_cards); }
	
	// keep this state for case dealer play again (if win more that max posible win)
	$first_all_cards=$all_cards;
	$first_dealer_cards=$dealer_cards;
	do{
		do{
			// generate card for dealer  
			array_push($dealer_cards, generateCards());
	
			// count dealer score
			$sc=0; // calculate score (without Aces)
			$num_ace=0; // how much Aces player has
			foreach($dealer_cards as $dcard){
				$dsc1+=$dcard->num;
				if($dcard->worth=="c_A"){ $num_ace++; }
				else{ $sc+=$dcard->num; }
			}
			$add_to_sc_1=0;
			$add_to_sc_2=0;
			switch($num_ace){
				case 0: // player has no Aces - score not changed
					$add_to_sc_1=0;
					$add_to_sc_2=0;
				break;
				case 1: // player has one Ace - add to score 1 or 11
					$add_to_sc_1=1;
					$add_to_sc_2=11;
				break;
				case 2: // player has two Aces - add to score 1+1 or 1+11
					$add_to_sc_1=2;
					$add_to_sc_2=12;
				break;
				case 3: // player has three Aces - add to score 1+1+1 or 1+1+11
					$add_to_sc_1=3;
					$add_to_sc_2=13;
				break;
				case 4: // player has four Aces - add to score 1+1+1+1 or 1+1+1+11
					$add_to_sc_1=4;
					$add_to_sc_2=14;
				break;
				// no more Aces in deck
			}
			$sc1=$sc+$add_to_sc_1;
			$sc2=$sc+$add_to_sc_2;
			if( $sc2<=21 ){ $dealer_score=$sc2; }
			else{ $dealer_score=$sc1; }

			if($player1_bj){ break; } // if player has black jack dealer need only one card
// Check dealer score =<17
			if ($dealer_score >= 17) { break; }
		}while($dealer_score<17);

		// check is dealer has blackjack
		$dealer_bj=0;
		if( (count($dealer_cards)==2)&&($dealer_score==21) ){ $dealer_bj=1; }	


		// calculate winnings
		$total_win=0;
		$win1=0;
		$win2=0;
		if( $player1_score>21 ){ $win1=0; $player1_result=1; }
		elseif( $dealer_score>21 ){ 
			if($player1_insurance){  $win1=$player1_bet*4/3; $player1_result=2; }
			else{ $win1=$player1_bet*2; $player1_result=2;  }
		}
		elseif( $player1_score>$dealer_score ){
			if($player1_insurance){  $win1=$player1_bet*4/3; $player1_result=2; }
			else{ $win1=$player1_bet*2; $player1_result=2; }
		}
		elseif( $player1_score==$dealer_score){ $win1=$player1_bet; $player1_result=3; }
		else{ $win1=0; $player1_result=1; }
	
		// check for black jack
		if( $player1_bj&&(!$dealer_bj) ){ $win1=$player1_bet*2.5; $player1_result=2; }
		if( (!$player1_bj)&&$dealer_bj ){ 
			if($player1_insurance){ $win1=$player1_bet; $player1_result=3; }
			else{ $win1=0; $player1_result=1; }
		}
		if( $player1_bj&&$dealer_bj){ $win=$player1_bet; $player1_result=3; }

		$total_bet=$player1_bet;
		$total_win=$win1;

		if($player2){
			$win2=0;
			if( $player2_score>21 ){ $win2=0; $player2_result=1;  }
			elseif( $dealer_score>21 ){ $win2=$player2_bet*2; $player2_result=2;  }
			elseif( $player2_score>$dealer_score ){ $win2=$player2_bet*2; $player2_result=2; }
			elseif( $player2_score==$dealer_score){ $win2=$player2_bet; $player2_result=3; }
			else{ $win2=0;  $player2_result=1; }
	
			// check for black jack
			if( $player2_bj&&(!$dealer_bj) ){ $win2=$player2_bet*2.5; $player2_result=2; }
			if( (!$player2_bj)&&$dealer_bj ){ $win2=0; $player2_result=1; }
			if( $player2_bj&&$dealer_bj){ $win2=$player2_bet; $player2_result=3; }

			$total_bet+=$player2_bet;
			$total_win+=$win2;
		}
// let's make the win number 10.00 format instead of 10.001
	$total_win = sprintf ("%01.2f", $total_win); 
	$total_bet = sprintf ("%01.2f", $total_bet); 
		$diff=$total_win-$total_bet;
		$maxwin=calWinLimit();
		$play_again=false;
		if( ($diff>$maxwin)&&(!$player1_bj) ){ 
			$all_cards=$first_all_cards;
			$dealer_cards=$first_dealer_cards;
			$play_again=true; 
		}
		if( $player1_insurance&&$dealer_bj ){ 
			$all_cards=$first_all_cards;
			$dealer_cards=$first_dealer_cards;
			$play_again=true; 
		}
		
	}while($play_again);
	
	//////////////////////  update DB  //////////////////////////
//	$trans_id=$_POST["ti"];
	$win_limit = sprintf ("%01.2f", $maxwin); 
	$diff = sprintf ("%01.2f", $diff); 

	if($diff>=0){$rg="w";}else{$rg="l";}
	$tm=time();
	mysql_query("update `games` set `amount`=`amount`+$total_win, `result`='$rg' where `gameid`='$gameid'");
	mysql_query("update `transactions` set `date`='$tm', `type`='$rg', `amount`=`amount`+$total_win, `comments`='$win_limit' where `transid`='$trans_id'");

//user balance

list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

	//////////////////////  send answer  //////////////////////////
	$cd="";
	foreach($dealer_cards as $card){
		$cd.=$card->worth."@".$card->suit."!";
	}
	$answer="&ans=Res&cd=".$cd."&dsc=".$dealer_score."&dbj=".$dealer_bj."&ub=".$user_balance."&p1r=".$player1_result."&p2r=".$player2_result."&w1=".$win1."&w2=".$win2."&ti=-1&gi=-1";
	echo $answer;
}
else{exit;}
?>
