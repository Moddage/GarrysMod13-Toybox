<?php
	include_once("../inc/sql_connection.inc.php");
	require '../../steamauth/steamauth.php';

	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$steam64id = 0;
		$name = "";

		if(!isset($_SESSION['steamid'])) {
			http_response_code(400);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Sorry but you have to be logged in to do that.</div>';
			exit;
		}else{
			include('../../steamauth/userInfo.php');
			$steam64id = $steamprofile['steamid'];
			$name = mysqli_real_escape_string($conn, $steamprofile['personaname']);

			if (strlen($name) > 32){
				$name = substr($name, 0, 32);
			}

			$name = strip_tags(trim($name));
		}		

		if($steam64id == 0 || $name == "")
		{
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Something went wrong and we couldn\'t create your account.</div>';
		}


		$result = mysqli_query($conn, "INSERT INTO `accounts` (`steam64id`, `display_name`) VALUES ($steam64id, '$name')");
		
		if ($result) {
			http_response_code(200);
			echo '<div class="alert alert-success fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Success!</strong> Your account has been created.</div><script type="text/javascript">window.setTimeout(function() {location.reload();}, 2000);</script>';
			$_SESSION["account_created"] = true;
		} else {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Something went wrong and we couldn\'t create your account. ('.mysqli_error($conn).')</div>';
		}
	} else {
		http_response_code(403);
		echo "There was a problem with your submission, please try again.";
	}

?>