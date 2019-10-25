<link href="css/style.css" rel="stylesheet" media="screen">
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<div id="container">
<h1>MyFashionDaily</h1>
<div id="top_bar">
<a href="./">Home</a><?php if (logged_in()){echo '<a href="edit.php">Edit Profile</a> <a href="inventory.php">Inventory</a> <a href="about.php">About Us</a> <a href="logout.php">Logout</a>';} ?>
</div>