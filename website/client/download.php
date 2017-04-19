<?php
    if(!isset($_GET["id"])) {
		$id = 0;
	}else{
		$id = preg_replace("#[^0-9]#", "", $_GET["id"]);
	}

	header('Content-Type: text/plain; charset=iso-8859-1');

    if (($id <= 0) || (file_exists("../uploads/files/".$id.".gma") == false)) {
        die("Unknown addon");
    }else{
		include_once("../ingame/inc/sql_connection.inc.php");
		mysqli_query($conn, "UPDATE `items` SET downloads=downloads+1 WHERE id=$id");
		print(file_get_contents("../uploads/files/".$id.".gma"));
	}
?>