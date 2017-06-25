<?php
	function getProfileInfo($user_id) {
		$json_playerinfo = file_get_contents("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=*APIKEYREMOVED*&steamids=".$user_id);
		$playerinfo = json_decode($json_playerinfo);
		$playerinfo = (array) $playerinfo;
		$playerinfo = (array) $playerinfo["response"];
		$playerinfo = (array) $playerinfo["players"];
		if (count($playerinfo) >= 1) {
			$playerinfo = (array) $playerinfo[0];
			return $playerinfo;
		}else{
			$playerinfo = array( "personaname" => "Unknown", "profileurl" => "");
			return $playerinfo;
		}
	}

	function mysqli_time_format($str) {
		$time = strtotime($str);
		$output = date("m/d/y g:iA", $time);
		return $output;
	}
?>
