<?php require '../steamauth/steamauth.php'; ?>
<div id="toybox_navbar">
	<div id="searcharea">
		<ul style="float: right">
			<form action="?show=search" method="post">
				<input id="searchbox" name="q">
				<input id="searchbtn" type="submit" value="Search">
			</form>
		</ul>
		<?php
			if(!isset($_SESSION['steamid'])) {
				echo "<ul style=\"float: right; margin-top: 2px; margin-right: 2px;\">".steamlogin()."</ul>";
			}else{
				include ('../steamauth/userInfo.php');
				echo "<ul style=\"float: right; margin-top: 5.5px;\">".$steamprofile['personaname']."&nbsp;<a href=\"?show=settings\"><img src=\"\client\dortmund-16x16\settings.png\" style=\"vertical-align: top;\"></a>&nbsp;</ul>";
			}
		?>		
	</div>

	<ul>
		<li>
			<a<?php if ($show != "home") {echo ' href="/ingame/?show=home"';}?>>
				<img src="/client/navbar/home.png">
				<br><span<?php if ($show == "home") {echo ' class="active"';}?>>Home</span>
			</a>
		</li>
		<li>
			<a<?php if ($show != "mine") {echo ' href="/ingame/?show=mine"';}?>>
				<img src="/client/navbar/mine.png">
				<br><span<?php if ($show == "mine") {echo ' class="active"';}?>>Mine</span>
			</a>
		</li>
		<li>
			<a<?php if ($show != "favourites") {echo ' href="/ingame/?show=favourites"';}?>>
				<img src="/client/navbar/favourites.png">
				<br><span<?php if ($show == "favourites") {echo ' class="active"';}?>>Favourites</span>
			</a>
		</li>
		<li>
			<a<?php if ($show != "entities") {echo ' href="/ingame/?show=entities"';}?>>
				<img src="/client/navbar/entities.png">
				<br><span<?php if ($show == "entities") {echo ' class="active"';}?>>Entities</span>
			</a>
		</li>
		<li>
			<a<?php if ($show != "weapons") {echo ' href="/ingame/?show=weapons"';}?>>
				<img src="/client/navbar/weapons.png">
				<br><span<?php if ($show == "weapons") {echo ' class="active"';}?>>Weapons</span>
			</a>
		</li>
		<li>
			<a<?php if ($show != "props") {echo ' href="/ingame/?show=props"';}?>>
				<img src="/client/navbar/props.png">
				<br><span<?php if ($show == "props") {echo ' class="active"';}?>>Props</span>
			</a>
		</li>
		<li>
			<a<?php if ($show != "savemap") {echo ' href="/ingame/?show=savemap"';}?>>
				<img src="/client/navbar/saves.png">
				<br><span<?php if ($show == "savemap") {echo ' class="active"';}?>>Saves</span>
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