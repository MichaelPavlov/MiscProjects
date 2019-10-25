<?php
session_start();
require('includes/config.php');
check_login();
require('header.php');

if ( isset($_POST['save']) ){
	$user = new Users();
	$msg = $user->update($_POST, $_SESSION['userinfo']->ID);	
}
?>
	<div id="center">
	<h2 align="center">Register</h2>
	<h4 align="center"><?php if (isset($msg)){echo $msg;} ?></h4>
	<form method="POST" action="" enctype="multipart/form-data">
	<fieldset>
	<p><label for="first_name">First name: </label><input type="text" name="first_name" id="first_name" value="<?php echo $_SESSION['userinfo']->FirstName; ?>"></p>
	<p><label for="last_name">Last name: </label><input type="text" name="last_name" id="last_name" value="<?php echo $_SESSION['userinfo']->LastName; ?>"></p>
	<p><label for="password">Password: </label><input type="password" name="password" id="password"></p>
	<p><label for="photo">Photo: </label><input type="file" name="images[]"></p>
	<p><input type="submit" name="save" value="Save"></p>
	<p>&nbsp;</p>
	</fieldset>
	</form>
	</div>
</div>