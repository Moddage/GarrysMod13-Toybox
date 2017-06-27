<script src='//www.google.com/recaptcha/api.js'></script>

<div id="searchtarget">
	<div class="files_box" style="text-align: left;">
		<?php
			if(!isset($_SESSION['steamid'])):
				die('<h1>Sorry but you have to bee logged in to do that</h1>');
			else:
		?>
		<h1 style="margin-top:0;">User Settings:</h1>
		<div id="userSettingsForm-messages"></div>
		<?php

				$account_created = $_SESSION["account_created"];
				$disabled = "";
				if($account_created == false){
					$disabled = " disabled";
					echo '<form id="userCreateForm" method="post" action="./ajax/userCreate.php"><button type="submit" class="btn btn-success">Create account</button></form><hr />';
				}
		?>
		<div style="float: left; text-align: left;">
			<form id="userSettingsForm" method="post" action="./ajax/userSettings.php">
				<div class="form-group">
					<label for="userDisplayName">Display name:</label>
					<input type="text" class="form-control" name="userDisplayName" value="<?php echo $steamprofile['personaname']; ?>"<?php echo $disabled; ?>>
				</div>

				
				<div class="form-group">
					<label for="inputCaptcha">Captcha:</label>
					<?php if($disabled == ""): ?>
					<div class="g-recaptcha" data-sitekey="6LfHoyYUAAAAAOWXyeqwlTYr9rqJoJVjpuvPCriX"></div>
					<?php else: ?>
					*DISABLED*
					<?php endif; ?>
				</div>
				
				<button type="submit" class="btn btn-success"<?php echo $disabled; ?>>Update info</button>
			</form>
		</div>
		<?php
			endif;
		?>
	</div>
</div>