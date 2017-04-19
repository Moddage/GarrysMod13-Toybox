<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<script type="text/javascript">
			var ingame = false;
		</script>

		<?php include_once("./inc/includes.inc.php") ?>

		<link href="/favicon.ico" rel="shortcut icon" type="image/x-icon" />
		<meta name="description" content="Garrysmod Toybox revival by rtm516.">

		<title>The Cloud</title>
	</head>
	<body>
		<div id="content">
			<?php require '../steamauth/steamauth.php'; ?>
			<div id="toybox_navbar">
				<div id="searcharea">
					<ul style="float: right">
						<form action="?show=search" method="post" style="display: table-row;">
							<div class="input-group">
								<input type="text" class="form-control" placeholder="Search" name="q" id="srch-term" style="height: 15px;">
								<div class="input-group-btn">
									<button class="btn btn-default" type="submit" style="height: 29px;"><span class="glyphicon glyphicon-search"></span></button>
								</div>
							</div>
						</form>
					</ul>
					<?php
						if(!isset($_SESSION['steamid'])) {
							echo "<ul style=\"float: right; margin-top: 2px; margin-right: 2px;\">".loginbutton()."&nbsp;</ul>";
						}else{
							include ('../steamauth/userInfo.php');

							if (!isset($_SESSION["account_created"])){
								$steam64id = $steamprofile['steamid'];

								$result=mysqli_query($conn, "SELECT count(*) as total from `accounts` WHERE `steam64id`=$steam64id");
								$data=mysqli_fetch_assoc($result);

								if(intval($data['total']) >= 1){
									$_SESSION["account_created"] = true;
								}else{
									$_SESSION["account_created"] = false;
								}
							}

							if (!isset($_SESSION["nickname"])){
								$steam64id = $steamprofile['steamid'];

								$name = "";
								$name = $steamprofile['personaname'];

								$result=mysqli_query($conn, "SELECT `display_name` FROM `accounts` WHERE `steam64id`=$steam64id");
								$data=mysqli_fetch_assoc($result);

								if($data['display_name'] != ""){
									$_SESSION["account_created"] = $data['display_name'];
								}else{
									$_SESSION["account_created"] = $name;
								}
							}

							$steamprofile['personaname'] = $_SESSION["account_created"];

							echo "<ul style=\"float: right; margin-top: 5.5px;\">".$steamprofile['personaname']."&nbsp;<a href=\"?show=settings\" class=\"use_tooltip\" title=\"User settings\"><img src=\"..\client\dortmund-16x16\settings.png\" style=\"vertical-align: top;\"></a>&nbsp;<a href=\"?show=upload\" class=\"use_tooltip\" title=\"Upload\"><img src=\"..\client\dortmund-16x16\sign-up.png\" style=\"vertical-align: top;\"></a>&nbsp;<a href=\"?logout\" class=\"use_tooltip\" title=\"Sign Out\"><img src=\"..\client\dortmund-16x16\sign-out.png\" style=\"vertical-align: top;\"></a>&nbsp;</ul>";
						}
					?>		
				</div>

				<ul>
					<li>
						<a<?php if ($show != "home") {echo ' href="?show=home"';}?>>
							<img src="../client/navbar/home.png">
							<br><span<?php if ($show == "home") {echo ' class="active"';}?>>Home</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "mine") {echo ' href="?show=mine"';}?>>
							<img src="../client/navbar/mine.png">
							<br><span<?php if ($show == "mine") {echo ' class="active"';}?>>Mine</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "favourites") {echo ' href="?show=favourites"';}?>>
							<img src="../client/navbar/favourites.png">
							<br><span<?php if ($show == "favourites") {echo ' class="active"';}?>>Favourites</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "entities") {echo ' href="?show=entities"';}?>>
							<img src="../client/navbar/entities.png">
							<br><span<?php if ($show == "entities") {echo ' class="active"';}?>>Entities</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "weapons") {echo ' href="?show=weapons"';}?>>
							<img src="../client/navbar/weapons.png">
							<br><span<?php if ($show == "weapons") {echo ' class="active"';}?>>Weapons</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "props") {echo ' href="?show=props"';}?>>
							<img src="../client/navbar/props.png">
							<br><span<?php if ($show == "props") {echo ' class="active"';}?>>Props</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "savemap") {echo ' href="?show=savemap"';}?>>
							<img src="../client/navbar/saves.png">
							<br><span<?php if ($show == "savemap") {echo ' class="active"';}?>>Saves</span>
						</a>
					</li>
					<li>
						<a<?php if ($show != "about") {echo ' href="?show=about"';}?>>
							<img src="../client/navbar/about.png">
							<br><span<?php if ($show == "about") {echo ' class="active"';}?>>About</span>
						</a>
					</li>
				</ul>
			</div>

<!--
<script>
	$("#searchbox").keyup(function() {
		DoSearch($("#searchbox").val(), "ingame");
	});
</script>
-->