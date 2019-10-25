<?php
//absolute path to site root
define('SITE_PATH', "/home/content/m/y/f/myfashiondaily/html/");
//site root url
define('SITE_URL', "http://myfashiondaily.com/");

function __autoload($class_name) {
   require_once SITE_PATH.'classes/'.$class_name . '.php';
}
require_once(SITE_PATH.'includes/functions.php');

//database server
define('DB_SERVER', "myfashiondaily.db.6138070.hostedresource.com");
//database login name
define('DB_USER', "myfashiondaily");
//database login password
define('DB_PASS', "g0ssipG1rl");
//database name
define('DB_DATABASE', "myfashiondaily");

$sql = new Database(DB_SERVER, DB_USER, DB_PASS, DB_DATABASE); 
?>