<?php include ("connect.php"); ?>
<html>
<table>
<tr><td height='10'><h1>Inventory Upload Tool</h1></td></tr>

<?php
if ($_POST['submit'])
{
$name = $_FILES['myfile']['name'];
$tmp_name = $_FILES['myfile']['tmp_name'];

$title = $_POST['title'];
$description = $_POST['description'];
$brand = $_POST['brand'];
$category = $_POST['category'];
$color = $_POST['color'];
$price = $_POST['price'];
$url = $_POST['url'];
$themes = $_POST['themes'];

$location = "images/$name";
move_uploaded_file($tmp_name,$location);

$query = mysql_query("INSERT INTO Inventory(Name, Description, Photo, Brand, Category, Color, Price, URL, Themes)
                      VALUES('$title','$description','$location','$brand','$category','$color','$price','$url','$themes')");

echo("<tr><td><img src='images/boo.jpg'> <b>You go girl!</b></td></tr>");
}
?>

<form action='inventory_upload.php' method='POST' enctype='multipart/form-data'>
<table cellpadding='3'>
<tr><td align='right' width='100'><b>Name</b></td><td><input type='text' name='title'></td></tr>
<tr><td align='right'><b>Description</b></td><td><input type='text' name='description'></td></tr>
<tr><td align='right'><b>Photo</b></td><td><input type='file' name='myfile' class='imageupload'></td></tr>
<tr><td align='right'><b>Brand</b></td><td><input type='text' name='brand'></td></tr>
<tr><td align='right'><b>Category</b></td><td><input type='text' name='category'></td></tr>
<tr><td align='right'><b>Color</b></td><td><input type='text' name='color'></td></tr>
<tr><td align='right'><b>Price</b></td><td><input type='text' name='price'></td></tr>
<tr><td align='right'><b>URL</b></td><td><input type='text' name='url'></td></tr>
<tr><td align='right'><b>Themes</b></td><td><input type='text' name='themes'></td></tr>
<tr><td></td><td><input type='submit' name='submit' value='Upload'></td></tr>
</table>
</form>
</html>