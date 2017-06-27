<?php
	include_once("../inc/sql_connection.inc.php");
	require '../../steamauth/steamauth.php';

	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$name = strip_tags(trim($_POST["userDisplayName"]));
		$name = str_replace(array("\r","\n"), array(" "," "), $name);
		$name = mysqli_real_escape_string($conn, $name);
		$steam64id = 0;
		$recaptcha = $_POST['g-recaptcha-response'];

		if(!isset($_SESSION['steamid'])) {
			http_response_code(400);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Sorry but you have to be logged in to do that.</div>';
			exit;
		}else{
			include('../../steamauth/userInfo.php');
			$steam64id = $steamprofile['steamid'];
		}

		if (empty($name)) {
			http_response_code(400);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> There was a problem with your submission. Please complete the form and try again.</div>';
			exit;
		}

		if(!empty($recaptcha)) {
			$google_url="https://www.google.com/recaptcha/api/siteverify";
			$secret='6LfHoyYUAAAAAFOcK1nU0II1iNk8AT01jzIFb_HF';
			$ip=$_SERVER['REMOTE_ADDR'];
			$url=$google_url."?secret=".$secret."&response=".$recaptcha."&remoteip=".$ip;
			$res=file_get_contents($url);
			$res=json_decode($res, true);

			if(!$res['success']) {
				http_response_code(400);
				echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Please re-enter your reCAPTCHA.</div>';
				exit;
			}
		}else{
			http_response_code(400);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Please enter your reCAPTCHA.</div>';
			exit;
		}
		

		if($steam64id == 0)
		{
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Something went wrong and we couldn\'t change your settings.</div>';
		}
		

		$result = mysqli_query($conn, "UPDATE `accounts` SET `display_name`='$name' WHERE `steam64id`=$steam64id");

		
		if ($result) {
			http_response_code(200);
			echo '<div class="alert alert-success fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Success!</strong> Your settings have been changed.</div>';
		} else {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Something went wrong and we couldn\'t change your settings. ('.mysqli_error($conn).')</div>';
		}
	} else {
		http_response_code(403);
		echo "There was a problem with your submission, please try again.";
	}

?>