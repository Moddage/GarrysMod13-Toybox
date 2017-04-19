<?php
	require("./inc/functions.inc.php");

	if(isset($_GET["show"])) {
		$show = htmlspecialchars($_GET["show"]);
	}else{
		$show = "home";
	}
	
	$pages = array(
		"404" => array(
				"name" => "Error 404",
				"url" => "./pages/404.php"
			),
		"home" => array(
				"name" => "Home",
				"url" => "./pages/home.php"
			),
		"mine" => array(
				"name" => "Home",
				"url" => "./pages/not_implemented.php"
			),
		"favourites" => array(
				"name" => "Home",
				"url" => "./pages/not_implemented.php"
			),
		"entities" => array(
				"name" => "Home",
				"url" => "./pages/entities.php"
			),
		"weapons" => array(
				"name" => "Home",
				"url" => "./pages/weapons.php"
			),
		"props" => array(
				"name" => "Home",
				"url" => "./pages/props.php"
			),
		"savemap" => array(
				"name" => "Home",
				"url" => "./pages/not_implemented.php"
			),
		"settings" => array(
				"name" => "Home",
				"url" => "./pages/user_settings.php"
			),
		"search" => array(
				"name" => "Home",
				"url" => "./pages/search.php"
			),
		"addon" => array(
				"name" => "Addon",
				"url" => "./pages/addon.php"
			),
		"upload" => array(
				"name" => "Upload addon",
				"url" => "./pages/upload.php"
			),
		"about" => array(
				"name" => "About",
				"url" => "./pages/about.php"
			),
	);
	include_once("./inc/sql_connection.inc.php");

	include_once("./inc/header.inc.php");

	$oldPage = "unknown";
	if(isset($pages[$show])) {
		include($pages[$show]["url"]);
	}else{
		$oldPage = $show;
		include($pages["404"]["url"]);
	}

	include_once("./inc/footer.inc.php");
?>