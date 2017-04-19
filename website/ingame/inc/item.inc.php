<?php
	$steam64id = $item['uploader'];

	$result = mysqli_query($conn, "SELECT `display_name` FROM `accounts` WHERE `steam64id`=$steam64id");
	$data = mysqli_fetch_assoc($result);

	$user = "Unknown";

	if($data["display_name"] != ""){
		$user = $data["display_name"];
	}

	$uploader_profile = array( "personaname" => $user, "profileurl" => "https://steamcommunity.com/profiles/".$steam64id);
?>
<div class="script_box use_tooltip" id="script_<?php echo $item['id'] ?>" title='<div style="width: 200px;"><div class="inner"><?php echo $item['description'] ?></div><div><div style="float: right;">by <a href="<?php echo $uploader_profile["profileurl"]; ?>" ><?php echo $uploader_profile["personaname"]; ?></a></div><img src="/client/icon_downloads.png"> <?php echo $item['downloads'] ?> </div></div>'>
	<div class="image_thumb" style="background-image: url(&quot;<?php echo $image; ?>&quot;);"><img src="/client/overlay_128_<?php if($show == "home"){echo "dark";}else{echo "light";} ?>.png" width="128" height="100"></div>
	<div class="image_overlay" onmouseover="OnButtonHover( this );" onmouseout="OnButtonHoverEnd( this );">
		<div class="hover_overlay" style="display: none;">
			<div class="ratings">
				<div class="rating"><?php echo $item['goodRatings'] ?>
					<br>
					<a alt="Good" href="#" onclick="return DoRating( this, '<?php echo $item['id'] ?>', 'good', 'invalid' );"><img src="/client/ratings/good.png"></a>
				</div>
				<div class="rating"><?php echo $item['badRatings'] ?>
					<br>
					<a alt="Bad" href="#" onclick="return DoRating( this, '<?php echo $item['id'] ?>', 'bad', 'invalid' );"><img src="/client/ratings/bad.png"></a>
				</div>
			</div>
			<div class="favourite"><?php echo $item['favourites'] ?>
				<br>
				<a href="#" onclick="return ToggleFavorite( this, '<?php echo $item['id'] ?>', 'invalid' );"><img src="/client/ratings/love.png"></a>
			</div>
			<div class="comments">??
				<br>
				<a href="/ingame/?show=addon&amp;id=<?php echo $item['id'] ?>"><img src="/client/ratings/comments.png"></a>
			</div>
		</div>
		<!-- modal content -->
		<div class="confirm" id='confirm<?php echo $item["id"] ?>'>
			<div class='header' id="header<?php echo $item["id"] ?>"><span>Confirm</span></div>
			<div class='message' id="message<?php echo $item["id"] ?>">Please open in game to download this item. Or click the button at the bottom to view the item page.</div>
			<div class='buttons' id="buttons<?php echo $item["id"] ?>">
				<div class='yes' id="yes<?php echo $item["id"] ?>" style="padding-left: 7px; padding-right: 7px;">Open item page</div><div class='no simplemodal-close' id="no<?php echo $item["id"] ?>">Close</div>
			</div>
		</div>

		<a href='#' onclick='IngameCheck(<?php echo $item["id"].",\"".$user."\",\"".$item['name']."\""; ?>);'>
			<img src="/client/p.gif" width="128" height="100">
		</a>
	</div>
	<div class="title"><a href="/ingame/?view=<?php echo $item['id'] ?>"><?php echo $item['name'] ?></a></div>
	<div class="meta"></div>
</div>