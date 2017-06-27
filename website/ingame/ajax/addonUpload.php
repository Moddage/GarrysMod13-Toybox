<?php
	include_once("../inc/sql_connection.inc.php");
	require '../../steamauth/steamauth.php';

	function return_bytes($val) {
		$val = trim($val);
		$last = strtolower($val[strlen($val)-1]);
		switch($last) {
			// The 'G' modifier is available since PHP 5.1.0
			case 'g':
				$val *= 1024;
			case 'm':
				$val *= 1024;
			case 'k':
				$val *= 1024;
		}

		return $val;
	}

	function resize_image($file, $w, $h, $crop=FALSE) {
		list($width, $height) = getimagesize($file);
		$r = $width / $height;
		if ($crop) {
			if ($width > $height) {
				$width = ceil($width-($width*abs($r-$w/$h)));
			} else {
				$height = ceil($height-($height*abs($r-$w/$h)));
			}
			$newwidth = $w;
			$newheight = $h;
		} else {
			if ($w/$h > $r) {
				$newwidth = $h*$r;
				$newheight = $h;
			} else {
				$newheight = $w/$r;
				$newwidth = $w;
			}
		}
		$src = imagecreatefromjpeg($file);
		$dst = imagecreatetruecolor($newwidth, $newheight);
		imagecopyresampled($dst, $src, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);

		return $dst;
	}


	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$title = strip_tags(trim($_POST["addonTitle"]));
		$title = str_replace(array("\r","\n"),array(" "," "),$title);
		$desc = strip_tags(trim($_POST["addonDescription"]));
		$recaptcha = $_POST['g-recaptcha-response'];
		$type = strip_tags(trim($_POST["addonType"]));
		$type = str_replace(array("\r","\n"),array(" "," "),$type);

		if(!isset($_SESSION['steamid'])) {
			http_response_code(400);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Sorry but you have to be logged in to do that.</div>';
			exit;
		}else{
			include('../../steamauth/userInfo.php');
			$steam64id = $steamprofile['steamid'];
		}	

		if($steam64id == 0)
		{
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Something went wrong and we couldn\'t upload your addon.</div>';
			exit;
		}

		if($_SESSION["account_created"] == false)
		{
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Sorry but you first have to make an account <a href="?show=settings">here</a>.</div>';
			exit;
		}

		if($type != "entity" && $type != "weapon" && $type != "prop") {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Invalid type specified.</div>';
			exit;
		}

		if($title == "" || $desc == "") {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> No title or description.</div>';
			exit;
		}

		if(strlen($title) < 3) {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Title must be longer than 3 characters.</div>';
			exit;
		}

		if(strlen($desc) < 5) {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Description must be longer than 5 characters.</div>';
			exit;
		}

		if(!isset($_FILES["addonFile"])) {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> No addon file specified.</div>';
			exit;
		}

		$hasImage = true;
		if(isset($_FILES['addonImg']['error']) && $_FILES['addonImg']['error'] != 0) {
			$hasImage = false;
		}else{
			$check = getimagesize($_FILES["addonImg"]["tmp_name"]);
			if(!$check) {
				http_response_code(500);
				echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Invalid image specified.</div>';
				exit;
			}

			if ($_FILES["addonImg"]["size"] > return_bytes(ini_get('upload_max_filesize'))) {
				http_response_code(500);
				echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Uploaded image is to big.</div>';
				exit;
			}

			if(($check[0] > 128) || ($check[1] > 128)) {
				http_response_code(500);
				echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Size must be smaller than 128x128.</div>';
				exit;
			}

			$addonImageType = pathinfo($_FILES["addonImg"]["name"], PATHINFO_EXTENSION);
			if($addonImageType != "jpeg" && $addonImageType != "jpg") {
				http_response_code(500);
				echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Invalid image specified must be jpeg.</div>';
				exit;
			}
		}

		$addonFileType = pathinfo($_FILES["addonFile"]["name"], PATHINFO_EXTENSION);
		if($addonFileType != "gma") {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Invalid addon file type specified.</div>';
			exit;
		}

		if ($_FILES["addonFile"]["size"] > return_bytes(ini_get('upload_max_filesize'))) {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Uploaded file is to big.</div>';
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


		$result = mysqli_query($conn, "INSERT INTO `items` (`type`, `name`, `description`, `uploader`) VALUES ('$type', '$title', '$desc', $steam64id)");
		$idSQL = mysqli_query($conn, "SELECT `id` FROM `items` WHERE `uploader`=$steam64id AND `type`='$type' AND `name`='$title' AND `description`='$desc' LIMIT 1");
		$data = mysqli_fetch_assoc($idSQL);
		
		$gotID = true;
		if($data == array()){
			$gotID = false;
		}

		if ($result && $gotID) {
			$id = $data["id"];

			$target_dir = "../../uploads/files/";
			$target_file = $target_dir . basename($id.".".$addonFileType);

			move_uploaded_file($_FILES["addonFile"]["tmp_name"], $target_file);

			if($hasImage) {
				$target_dir = "../../uploads/images/";
				$target_file = $target_dir . basename($id."_thumb_128.jpg");

				move_uploaded_file($_FILES["addonImg"]["tmp_name"], $target_file);
				$img = resize_image($target_file, 128, 128);
				imagejpeg($img, $target_file);
			}

			http_response_code(200);
			echo '<div class="alert alert-success fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Success!</strong> Your addon has been uploaded.</div><script type="text/javascript">window.setTimeout(function() {location.href="?show=addon&id='.$id.'";}, 2000);</script>';
		} else {
			http_response_code(500);
			echo '<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> Something went wrong and we couldn\'t upload your addon.</div>';
		}
	} else {
		http_response_code(403);
		echo "There was a problem with your submission, please try again.";
	}

?>