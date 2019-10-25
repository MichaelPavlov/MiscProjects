<?php
session_start();
require('includes/config.php');

if ( isset($_POST['login']) ){
	$user = new Users();
	$msg = $user->login($_POST);	
}

require('header.php');
?>
	<div id="center">
	<h2 align="center">Login</h2>
	<h4 align="center"><?php if (isset($msg)){echo $msg;} ?></h4>
	<form method="POST" action="">
	<fieldset>
	<p><label for="email">Email: </label><input type="text" name="email" id="email"></p>
	<p><label for="password">Password: </label><input type="password" name="password" id="password"></p>
	<p><input type="submit" name="login" value="Login"></p>
	<p>&nbsp;</p>
	</fieldset>
	</form>
	</div>
</div>