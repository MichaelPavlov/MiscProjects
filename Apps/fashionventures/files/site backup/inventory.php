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
<?php
$query = mysql_query("SELECT * FROM Inventory ORDER BY ID DESC");
while ($row = mysql_fetch_assoc($query))
{
$id = $row['ID'];  
$name = $row['Name'];
$description = $row['Description'];
$photo = $row['Photo'];
$brand = $row['Brand'];
$category = $row['Category'];
$color = $row['Color'];
$price = $row['Price'];
$url = $row['URL'];
$themes = $row['Themes'];
$timestamp = $row['Timestamp'];

echo ("
<tr>
 <td><img src='$photo' width='250'></td>
 <td width='500'>
  <b><span class='headline'>$name</span></b><br>
  <span class='text'>$description</span><br>
  <span class='text'><b>$brand</b></span><br>
  <span class='text'>$category</span><br>
  <span class='text'>Color: $color</span><br>
  <span class='text'>$$price</span><br>
  <a href='$url' class='buynow'>Buy Now</a><br>
  <span class='text'>$themes</span>
 </td>
</tr>
");
}
?>
</table>
</body>
</html>
<?php ob_end_flush(); ?>