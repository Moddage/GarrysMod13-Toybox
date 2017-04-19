<?php
	$search_term = htmlspecialchars($_POST["q"])
?>

<div id="searchtarget">
	<?php
		echo "<h1>Search: ".$search_term."</h1>";
	?>
</div>