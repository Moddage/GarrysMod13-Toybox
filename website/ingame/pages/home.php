<?php
	###START ITEM LOAD###
	$db_retrived_items = array();
	$db_retrived_items["entity"] = mysqli_query($conn, "SELECT * FROM `items` WHERE type='entity' ORDER BY `items`.`uploadDate` DESC LIMIT 10");
	if (!$db_retrived_items["entity"]) {
		die ('Unable to get entitys: ' . mysqli_error($conn));
	}
	$db_retrived_items["weapon"] = mysqli_query($conn, "SELECT * FROM `items` WHERE type='weapon' ORDER BY `items`.`uploadDate` DESC LIMIT 10");
	if (!$db_retrived_items["weapon"]) {
		die ('Unable to get weapons: ' . mysqli_error($conn));
	}
	$db_retrived_items["prop"] = mysqli_query($conn, "SELECT * FROM `items` WHERE type='prop' ORDER BY `items`.`uploadDate` DESC LIMIT 10");
	if (!$db_retrived_items["prop"]) {
		die ('Unable to get props: ' . mysqli_error($conn));
	}
	$db_retrived_items["save"] = mysqli_query($conn, "SELECT * FROM `items` WHERE type='save' ORDER BY `items`.`uploadDate` DESC LIMIT 10");
	if (!$db_retrived_items["save"]) {
		die ('Unable to get saves: ' . mysqli_error($conn));
	}

	$entitys = array();
	while ($row = mysqli_fetch_assoc($db_retrived_items["entity"])) {
		array_push($entitys, array("id" => $row["id"], "type" => $row["type"], "name" => $row["name"], "description" => $row["description"], "uploader" => $row["uploader"], "uploadDate" => $row["uploadDate"], "goodRatings" => $row["goodRatings"], "badRatings" => $row["badRatings"], "favourites" => $row["favourites"], "downloads" => $row["downloads"], ));
	}

	$weapons = array();
	while ($row = mysqli_fetch_assoc($db_retrived_items["weapon"])) {
		array_push($weapons, array("id" => $row["id"], "type" => $row["type"], "name" => $row["name"], "description" => $row["description"], "uploader" => $row["uploader"], "uploadDate" => $row["uploadDate"], "goodRatings" => $row["goodRatings"], "badRatings" => $row["badRatings"], "favourites" => $row["favourites"], "downloads" => $row["downloads"], ));
	}
	
	$props = array();
	while ($row = mysqli_fetch_assoc($db_retrived_items["prop"])) {
		array_push($props, array("id" => $row["id"], "type" => $row["type"], "name" => $row["name"], "description" => $row["description"], "uploader" => $row["uploader"], "uploadDate" => $row["uploadDate"], "goodRatings" => $row["goodRatings"], "badRatings" => $row["badRatings"], "favourites" => $row["favourites"], "downloads" => $row["downloads"], ));
	}

	$saves = array();
	while ($row = mysqli_fetch_assoc($db_retrived_items["save"])) {
		array_push($saves, array("id" => $row["id"], "type" => $row["type"], "name" => $row["name"], "description" => $row["description"], "uploader" => $row["uploader"], "uploadDate" => $row["uploadDate"], "goodRatings" => $row["goodRatings"], "badRatings" => $row["badRatings"], "favourites" => $row["favourites"], "downloads" => $row["downloads"], ));
	}
	###END ITEM LOAD###
?>



			<div id="searchtarget">
				<?php if (count($entitys) >= 1): ?>
				<div class="column" style="float: left; width: 140px;">NEWEST ENTITIES<br>
					<div class="files_box">
						<?php foreach ($entitys as $item): ?>
						<?php
							if(file_exists('../uploads/images/'.$item['id'].'_thumb_128.jpg')){
								$image = '/uploads/images/'.$item['id'].'_thumb_128.jpg';
							}else{
								$image = '/client/no_thumb_128.png';
							}
						?>
						<?php include("./inc/item.inc.php") ?>
						<?php endforeach; ?>

						<div class="clear">&nbsp;</div>
					</div>
				</div>
				<?php endif; ?>
				<?php if (count($weapons) >= 1): ?>
				<div class="column" style="float: left; width: 140px;">NEWEST WEAPONS
					<br>
					<div class="files_box">
						<?php foreach ($weapons as $item): ?>
						<?php
							if(file_exists('../uploads/images/'.$item['id'].'_thumb_128.jpg')){
								$image = '/uploads/images/'.$item['id'].'_thumb_128.jpg';
							}else{
								$image = '/client/no_thumb_128.png';
							}
						?>
						<?php include("./inc/item.inc.php") ?>
						<?php endforeach; ?>

						<div class="clear">&nbsp;</div>
					</div>
				</div>
				<?php endif; ?>
				<?php if (count($props) >= 1): ?>
				<div class="column" style="float: left; width: 140px;">NEWEST PROPS
					<br>
					<div class="files_box">
						<?php foreach ($props as $item): ?>
						<?php
							if(file_exists('../uploads/images/'.$item['id'].'_thumb_128.jpg')){
								$image = '/uploads/images/'.$item['id'].'_thumb_128.jpg';
							}else{
								$image = '/client/no_thumb_128.png';
							}
						?>
						<?php include("./inc/item.inc.php") ?>
						<?php endforeach; ?>

						<div class="clear">&nbsp;</div>
					</div>
				</div>
				<?php endif; ?>
				<?php if (count($saves) >= 1): ?>
				<div class="column" style="float: left; width: 140px;">NEWEST SAVES
					<br>
					<div class="files_box">
						<?php foreach ($saves as $item): ?>
						<?php
							if(file_exists('../uploads/images/'.$item['id'].'_thumb_128.jpg')){
								$image = '/uploads/images/'.$item['id'].'_thumb_128.jpg';
							}else{
								$image = '/client/no_thumb_128.png';
							}
						?>
						<?php include("./inc/item.inc.php") ?>
						<?php endforeach; ?>
						
						<div class="clear">&nbsp;</div>
					</div>
				</div>
				<?php endif; ?>
			</div>