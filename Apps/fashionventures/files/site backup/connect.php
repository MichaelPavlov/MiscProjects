<?php

$db_host="myfashiondaily.db.6138070.hostedresource.com";
$db_name="myfashiondaily";
$user="myfashiondaily";
$password="g0ssipG1rl";

$db_con=mysql_connect($db_host,$user,$password);
$connection_string=mysql_select_db($db_name);
mysql_connect($db_host,$user,$password);
mysql_select_db($db_name);

if (!$db_con)
  {
  die('Could not connect: ' . mysql_error());
  }

?>