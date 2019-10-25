<?php
function check_login()
{
	if ( !logged_in() ){
		header('location: login.php');
		exit();
	}
}

function logged_in()
{
	if ( !isset($_SESSION['userinfo']) ){
		return false;
	}else{
		return true;
	}
}

function upload_image($key)
{
	if ( $_FILES['images']['name'][$key] != '' ){
		$link_image = '';
		$image = new Upload;
		$image->set_max_size(2048000000);
		$upload_dir = SITE_PATH.'uploads/';
		$image->set_directory($upload_dir);
		$image->set_tmp_name($_FILES['images']['tmp_name'][$key]);
		$image->set_file_size($_FILES['images']['size'][$key]);
		$image->set_file_type($_FILES['images']['type'][$key]);
		$filename = random_string().'_'.$_FILES['images']['name'][$key];
		$image->set_file_name($filename);
		$image->start_copy();
		if ( $image->is_ok() ){
			return $filename;
		}else{
			return false;
		}
	}
}

function random_string($length='8')
	{
		$ran_string = "";
		$chars = array("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "A", "b", "B", "c",
		"C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", "k", "K", "l",
		"L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u",
		"U", "v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z");

		$count = count($chars) - 1;
		srand((double)microtime() * 1000000);
		for ($i = 0; $i < $length; $i++)
		{
			$ran_string .= $chars[rand(0, $count)];
		}
		return($ran_string);
	}
?>