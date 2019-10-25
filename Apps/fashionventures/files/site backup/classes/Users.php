<?php
class Users {

	public $data;
	public $id;

	function register($data)
	{
		global $sql;

		$this->data = $data;

		if ( $this->email_exists($data['email']) ){
			return 'Email address already exists';
		}
		if ( $data['email'] == '' || $data['password'] == ''){
			return 'Please provide email and password';
		}

		if(!$this->isValidEmail($data['email'])){
			return "E-mail is not valid";
		}

		$insert_data = array();
		$insert_data['FirstName'] = $data['first_name'];
		$insert_data['LastName'] = $data['last_name'];
		$insert_data['Email'] = $data['email'];
		$insert_data['Password'] = md5($data['password']);
		$insert_data['Photo'] = upload_image(0);

		$this->id = $sql->insert('users', $insert_data);
		$this->login($data);
	}

	function update($data, $id, $overwrite_session=true)
	{
		global $sql;

		$this->data = $data;

		$insert_data = array();
		$insert_data['FirstName'] = $data['first_name'];
		$insert_data['LastName'] = $data['last_name'];

		if ( $data['password'] != '')
		$insert_data['Password'] = md5($data['password']);

		if ( $_FILES['images']['name'][0] != '' )
		$insert_data['Photo'] = upload_image(0);

		$this->id = $sql->update('users', $insert_data, 'id='.mysql_real_escape_string($id));

		if ( $overwrite_session ){
			$_SESSION['userinfo'] = $this->get_user($id);
		}

		return 'Profile updated!!';
	}

	function login($data)
	{
		global $sql;

		$this->data = $data;

		if ( $data['email'] == '' || $data['password'] == ''){
			return 'Please provide email and password';
		}

		$result = $sql->fetchrow('select * from users where Email="'.mysql_real_escape_string($data['email']).'" AND Password="'.mysql_real_escape_string(md5($data['password'])).'"');
		if ( empty($result) ){
			return 'Invalid email/password';
		}else{
			$_SESSION['userinfo'] = $result;
			header('location: '.SITE_URL);
			exit();
		}
	}

	function get_user($id)
	{
		global $sql;

		$result = $sql->fetchrow('select * from users where ID="'.$id.'"');

		if ( empty($result) ){
			return false;
		}else{
			return $result;
		}
	}

	function follow_user($id)
	{
		global $sql;

		$insert_data = array();
		$insert_data['UserID'] = $_SESSION['userinfo']->ID;
		$insert_data['FriendID'] = $id;

		$sql->insert('friends', $insert_data);
		return 'Done!!';
	}

	function get_friends($id)
	{
		global $sql;

		$result = $sql->fetchall('select a.*,b.* from friends a join users b on a.FriendID=b.ID where a.UserID='.mysql_real_escape_string($id));

		if ( empty($result) ){
			return false;
		}else{
			return $result;
		}
	}

	function is_following($user_id, $friend_id)
	{
		global $sql;

		$result = $sql->fetchrow('select * from friends where UserID='.$user_id.' AND FriendID='.$friend_id);
		if (empty($result)){
			return false;
		}else{
			return $result;
		}
	}

	function email_exists($email)
	{
		global $sql;

		$result = $sql->fetchrow('select * from users where email="'.$email.'"');
		if (empty($result)){
			return false;
		}else{
			return $result;
		}
	}

	function isValidEmail($email){
	return eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $email);
}
}
?>
