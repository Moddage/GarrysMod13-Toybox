<?php
	$servername = "localhost";
	$username = "root";
	$password = "";
	$database = "toybox";
	
	$conn = mysqli_connect($servername, $username, $password, $database);
	if (!$conn) {
		die("Connection Failed: ".mysqli_error($conn));
	}
?>