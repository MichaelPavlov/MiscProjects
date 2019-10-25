<?php
session_start();
require('includes/config.php');
check_login();
require('header.php');
?>
<table>
<tr><td>
<div id="flashContent">
			<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="750" height="475" id="preLoader" align="middle">
				<param name="movie" value="preLoader.swf" />
				<param name="quality" value="high" />
				<param name="bgcolor" value="#ffffff" />
				<param name="play" value="true" />
				<param name="loop" value="true" />
				<param name="wmode" value="window" />
				<param name="scale" value="showall" />
				<param name="menu" value="true" />
				<param name="devicefont" value="false" />
				<param name="salign" value="" />
				<param name="allowScriptAccess" value="sameDomain" />
				<!--[if !IE]>-->
				<object type="application/x-shockwave-flash" data="preLoader.swf" width="750" height="475">
					<param name="movie" value="preLoader.swf" />
					<param name="quality" value="high" />
					<param name="bgcolor" value="#ffffff" />
					<param name="play" value="true" />
					<param name="loop" value="true" />
					<param name="wmode" value="window" />
					<param name="scale" value="showall" />
					<param name="menu" value="true" />
					<param name="devicefont" value="false" />
					<param name="salign" value="" />
					<param name="allowScriptAccess" value="sameDomain" />
				<!--<![endif]-->
					<a href="http://www.adobe.com/go/getflash">
						<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
					</a>
				<!--[if !IE]>-->
				</object>
				<!--<![endif]-->
			</object>
		</div>
</td>
<td>

		 <?php if ($_SESSION['userinfo']->Photo != ''){ ?>
	     <img src="uploads/<?php echo $_SESSION['userinfo']->Photo; ?>" >
	     <?php }else{ ?>
	     <img src="images/default.jpg" >
	     <?php } ?>
		<h4><?php echo $_SESSION['userinfo']->FirstName; ?> <?php echo $_SESSION['userinfo']->LastName; ?></h4>	
	    <p>&nbsp;</p>
	    <p>&nbsp;</p>
	    <h3>Friends</h3>
	    <div id="friends">
	    <?php
	    $user = new Users;
	    if ( $friends = $user->get_friends($_SESSION['userinfo']->ID) ){
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

</td>
</tr>
</table>