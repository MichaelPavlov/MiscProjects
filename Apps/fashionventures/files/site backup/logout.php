<?php
session_start();
require('includes/config.php');

$_SESSION = array();
header('location: '.SITE_URL);
?>