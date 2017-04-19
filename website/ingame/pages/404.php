<?php http_response_code(404); ?>
<div id="searchtarget">
	<div class="files_box">
		<h1>Error 404: File not found</h1>
		<p>Sorry but the page '<?php echo $oldPage; ?>' doesn't exist.</p>
		<a href="#" onclick="window.history.back();">Go Back</a>		
	</div>
</div>