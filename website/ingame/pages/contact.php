<div id="searchtarget">
	<div class="files_box" style=" text-align: left;">
		<script src='//www.google.com/recaptcha/api.js'></script>
		<h1 style="margin-top:0;">Post an addon:</h1>
		<div id="contactForm-messages"></div>
		<form class="" id="contactForm" method="post" action="./ajax/contact.php" style="float: left;">
			<div class="form-group">
				<label for="addonTitle" class="control-label">Title <span class="glyphicon glyphicon-question-sign" aria-hidden="true" data-toggle="tooltip" data-placement="top" title="Your name"></span></label>
				
					<input type="text" class="form-control" id="addonTitle" name="addonTitle" placeholder="......" required>
				
			</div>
			<div class="form-group">
				<label for="addonDescription" class="control-label">Description <span class="glyphicon glyphicon-question-sign" aria-hidden="true" data-toggle="tooltip" data-placement="top" title="The content of your message"></span></label>
				
					<textarea class="form-control" id="addonDescription" name="addonDescription" rows="6" placeholder="......" required></textarea>
				
			</div>
			<div class="form-group">
				<label for="inputCaptcha" class="control-label">Captcha</label>
				<div class="">
					<div class="g-recaptcha" data-sitekey="*SITEKEYREMOVED*"></div>
				</div>
			</div>
			<div class="form-group">
				<div class="">
					<button type="submit" class="btn btn-primary">Upload addon</button>
				</div>
			</div>
		</form>
	</div>
</div>
