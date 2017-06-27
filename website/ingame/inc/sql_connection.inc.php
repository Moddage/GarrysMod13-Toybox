<?php
	$servername = "localhost";
	$username = "kalebserver";
	$password = "fgwArMaMLB";
	$database = "kalebserver_funbox";
	
	$conn = mysqli_connect($servername, $username, $password, $database);
	if (!$conn) {
		die("Connection Failed: ".mysqli_error($conn));
	}
?>