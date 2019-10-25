<?php
session_start();
require('includes/config.php');
check_login();
require('header.php');
?>
<html>
<style type="text/css">
table.main {-moz-border-radius: 5px; -webkit-border-radius: 5px;}
.headline {font-family:arial; font-size:27px; font-weight:bold;}
.text {font-family:arial;}
a.buynow {font-family:arial; font-size:17px; font-weight:bold;}
</style>
<body>
<table align='center' width='800' bgcolor='white' cellpadding='10' cellspacing='10' class='main'>
<tr>
 <td colspan='2' class='text'>
  <b>About Us</b><br>
  myfashiondaily.com is a website we started because we have no time to shop due to our busy lifestyles. Instead of spending
  hours online searching for a certain item or shopping in the store we have decided to store all of our favorite fashion items
  in one place so that we can then come back to the site and find what we need instantly for any upcoming event. This site
  represents not only our own personal style preferences, but what we believe other people will like as well.
  <br><br>
  We hope you enjoy our picks!
  <br><br>
  Jenny and MK
 </td>
</tr>
<tr><td colspan='2' height='50'></td></tr>
</table>
</body>
</html>
<?php ob_end_flush(); ?>