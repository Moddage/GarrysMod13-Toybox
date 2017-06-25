<?php
	$unknown = '<div id="searchtarget"><div class="files_box"><h1>Unknown addon<br><a href="#" onclick="window.history.back();">Go Back</a></h1></div></div>';

	if(isset($_GET["id"]) && intval($_GET["id"]) > 0 && intval($_GET["id"]) < 2147483647){
		$id = intval($_GET["id"]);
	}else{
		die($unknown);
	}

	$result = mysqli_query($conn, "SELECT `type`,`name`,`description`,`uploader`,`uploadDate`,`goodRatings`,`badRatings`,`favourites`,`downloads` FROM `items` WHERE `id`=$id LIMIT 1");
	$addon = mysqli_fetch_assoc($result);

	if($addon == array()){
		die($unknown);
	}

	$addon["uploadDate"] = mysqli_time_format($addon["uploadDate"])." GMT";

	if(file_exists('../uploads/images/'.$id.'_thumb_128.jpg')){
		$image = '/uploads/images/'.$id.'_thumb_128.jpg';
	}else{
		$image = '/client/no_thumb_128.png';
	}

	$steam64id = $addon["uploader"];

	$result = mysqli_query($conn, "SELECT `display_name` FROM `accounts` WHERE `steam64id`=$steam64id");
	$data = mysqli_fetch_assoc($result);

	$user = "Unknown";

	if($data["display_name"] != ""){
		$user = $data["display_name"];
	}
?>
<div id="searchtarget">
	<div class="files_box" style="text-align: left;">
		<h1 style="margin-top:0;"><?php echo ucfirst($addon["type"]); ?>: <?php echo $addon["name"]; ?></h1>
		<img style="width: 128px; height: 128px; margin-right: 5px; float: left; vertical-align: middle; display: block;" src="<?php echo $image; ?>">
		<span style="display: block;">
			<b>Author: </b><?php echo $user; ?><br>
			<b>Upload date: </b><?php echo $addon["uploadDate"]; ?><br>
			<b>Good ratings: </b><?php echo $addon["goodRatings"]; ?><br>
			<b>Bad ratings: </b><?php echo $addon["badRatings"]; ?><br>
			<b>Favourites: </b><?php echo $addon["favourites"]; ?><br>
			<b>Downloads: </b><?php echo $addon["downloads"]; ?><br>
		</span>
		<br>
		<span><?php echo $addon["description"]; ?></span>
		<hr />
		<h1>Comments will go here</h1>
	</div>
</div>