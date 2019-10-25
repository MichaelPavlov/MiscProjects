<?php
session_start();
require('includes/config.php');
check_login();
require('header.php');

$user = new Users();

if ($details = $user->get_user($_REQUEST['id'])){
	if ( isset($_REQUEST['action']) && $_REQUEST['action'] == 'follow'){
		$msg = $user->follow_user($_REQUEST['id']);	
	}
?>
<h4 align="center"><?php if (isset($msg)){echo $msg;} ?></h4>
	<div id="right">
		 <?php if ($details->Photo != ''){ ?>
	     <img src="uploads/<?php echo $details->Photo; ?>" >
	     <?php }else{ ?>
	     <img src="images/default.jpg" >
	     <?php } ?>
		<h4><?php echo $details->FirstName; ?> <?php echo $details->LastName; ?></h4>	
	    <p>&nbsp;</p>
	    <p>&nbsp;</p>
	    <?php if ( !$user->is_following($_SESSION['userinfo']->ID, $_REQUEST['id']) ){ ?>
	    <div id="follow_button"><a href="profile.php?id=<?php echo $_REQUEST['id']; ?>&action=follow">Follow <?php echo $details->FirstName; ?></a></div>
	    <?php } ?>
	    <h3>Friends</h3>
	    <div id="friends">
	    <?php
	    $user = new Users();
	    if ( $friends = $user->get_friends($details->ID) ){
	    	foreach ($friends as $the_friend){
	    ?>
	    <a href="profile.php?id=<?php echo $the_friend->ID; ?>">
	     <?php if ($the_friend->Photo != ''){ ?>
	     <img src="uploads/<?php echo $the_friend->Photo; ?>" >
	     <?php }else{ ?>
	     <img src="images/default.jpg" >
	     <?php } ?>
	     </a>
	   <?php
	    	}
	    }
	   ?>
	    </div>
	</div>
<?php
}
?>
</div>