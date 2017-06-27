<script src='//www.google.com/recaptcha/api.js'></script>

<div id="searchtarget">
	<div class="files_box" style=" text-align: left;">
		<?php
			if(!isset($_SESSION['steamid'])):
				die('<h1>Sorry but you have to bee logged in to do that</h1>');
			else:
		?>
		<h1 style="margin-top:0;">Post an addon:</h1>
		<div id="addonUploadForm-messages"></div>

		<?php
				$account_created = $_SESSION["account_created"];
				$disabled = "";
				if($account_created == false){
					$disabled = " disabled";
					echo 'Please head to settings to create an account before continuing<br><a class="btn btn-success" href="?show=settings">Account settings</a><br><br>';
				}
		?>

		<div style="float: left; text-align: left;">
			<form id="addonUploadForm" method="POST" action="./ajax/addonUpload.php" enctype="multipart/form-data">
				<div class="form-group">
					<label for="addonType">Type: *</label>
					<select class="form-control" id="addonType" name="addonType" required<?php echo $disabled; ?>>
						<option value="entity">Entity</option>
						<option value="weapon">Weapon</option>
						<option value="prop">Prop</option>
					</select>
				</div>

				<div class="form-group">
					<label for="addonTitle">Title: *</label>
					<input type="text" class="form-control" id="addonTitle" name="addonTitle" required<?php echo $disabled; ?>/>
				</div>

				<div class="form-group">
					<label for="addonImg">Addon image (128x128 jpeg/jpg, <?php echo ini_get('upload_max_filesize'); ?> limit):</label>
					<input type="file" id="addonImg" name="addonImg" accept="image/jpeg" <?php echo $disabled; ?>/>
				</div>
				
				<div class="form-group">
					<label for="addonDescription">Description: *</label>
					<textarea class="form-control" id="addonDescription" name="addonDescription" rows="4" required<?php echo $disabled; ?>></textarea>
				</div>
				
				<div class="form-group">
					<label for="addonFile">GMA File (<?php echo ini_get('upload_max_filesize'); ?> limit): *</label>
					<input type="file" id="addonFile" name="addonFile" accept=".gma" required<?php echo $disabled; ?>/>
				</div>
				
				<div class="form-group">
					<label for="inputCaptcha">Captcha: *</label>
					<?php if($disabled == ""): ?>
					<div class="g-recaptcha" data-sitekey="6LfHoyYUAAAAAOWXyeqwlTYr9rqJoJVjpuvPCriX"></div>
					<?php else: ?>
					*DISABLED*
					<?php endif; ?>
				</div>
				
				<button type="submit" class="btn btn-success"<?php echo $disabled; ?>>Upload addon</button>
			</form>
			<small>* = required</small>
		</div>
		<?php endif; ?>
	</div>
</div>