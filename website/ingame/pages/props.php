<?php
	$per_page = 50;


	if(!isset($_GET["tiertwo"])) {
		$tiertwo = "popular";
	}else{
		$tiertwo = $_GET["tiertwo"];
	}

	if ($tiertwo != "popular" && $tiertwo != "newest") {
		$tiertwo = "popular";		
	}


	if(!isset($_GET["category"])) {
		$category = 0;
	}else{
		$category = preg_replace("#[^0-9]#", "", $_GET["category"]);
	}

	if ($category < 0) {
		$category = 0;
	}elseif ($category > 6) {
		$category = 6;
	}
?>

<div id="searchtarget">
	<div class="tier2nav">
		<ul>
			<li <?php if ($category == 0) {echo 'class="active"><a';}else{echo '><a href="./?show=props&amp;tiertwo='.$tiertwo.'&amp;category=0"';}?>>All</a></li>
			<li <?php if ($category == 1) {echo 'class="active"><a';}else{echo '><a href="./?show=props&amp;tiertwo='.$tiertwo.'&amp;category=1"';}?>>Fun</a></li>
			<li <?php if ($category == 2) {echo 'class="active"><a';}else{echo '><a href="./?show=props&amp;tiertwo='.$tiertwo.'&amp;category=2"';}?>>Building</a></li>
			<li <?php if ($category == 3) {echo 'class="active"><a';}else{echo '><a href="./?show=props&amp;tiertwo='.$tiertwo.'&amp;category=3"';}?>>Other Games</a></li>
			<li>|</li>
			<li <?php if ($tiertwo == "popular") {echo 'class="active"><a';}else{echo '><a href="./?show=props&amp;tiertwo=popular&amp;category='.$category.'"';}?>>Popular</a></li>
			<li <?php if ($tiertwo == "newest") {echo 'class="active"><a';}else{echo '><a href="./?show=props&amp;tiertwo=newest&amp;category='.$category.'"';}?>>Newest</a></li>
		</ul>
	</div>
	
<?php
	$category_sql = "";
	if ($category > 0) {
		$category_sql = " AND (category1=".$category." OR category2=".$category." OR category3=".$category.")";
	}

	$tiertwo_sql = "";
	if ($tiertwo == "popular") {
		$tiertwo_sql = "`items`.`downloads`";
	}elseif ($tiertwo == "newest") {
		$tiertwo_sql = "`items`.`uploadDate`";
	}

	$pages_querey = mysqli_query($conn, "SELECT COUNT('id') FROM `items` WHERE type='prop'".$category_sql);
	$pages = ceil(mysqli_fetch_row($pages_querey)[0]/$per_page);
	
	if ($pages <= 0){
		die('<div class="files_box"><h1>There are no props in this category!</h1></div>');
	}

	if(!isset($_GET["page"])) {
		$page = 1;
	}else{
		$page = preg_replace("#[^0-9]#", "", $_GET["page"]);
	}

	if ($page < 1) {
		$page = 1;
	}elseif ($page > $pages) {
		$page = $pages;
	}

	$start = (($page - 1)*$per_page);



	$db_retrived_items["prop"] = mysqli_query($conn, "SELECT * FROM `items` WHERE type='prop'".$category_sql." ORDER BY ".$tiertwo_sql." DESC LIMIT $start,$per_page");
	if (!$db_retrived_items["prop"]) {
		die ('Unable to get props: ' . mysqli_error($conn));
	}

	$props = array();
	while ($row = mysqli_fetch_assoc($db_retrived_items["prop"])) {
		array_push($props, array("id" => $row["id"], "type" => $row["type"], "name" => $row["name"], "description" => $row["description"], "uploader" => $row["uploader"], "uploadDate" => $row["uploadDate"], "goodRatings" => $row["goodRatings"], "badRatings" => $row["badRatings"], "favourites" => $row["favourites"], "downloads" => $row["downloads"], ));
	}


	$pagecontrolls = "";

	if ($page > 1) {
		$pagecontrolls .= '<a class="page" href="./?show=props&amp;tiertwo='.$tiertwo.'&amp;category='.$category.'&amp;page='.($page-1).'">&lt;</a> ';

		for ($i=$page-4; $i < $page; $i++) {
			if ($i > 0) {
				$pagecontrolls .= '<a class="page" href="./?show=props&amp;tiertwo='.$tiertwo.'&amp;category='.$category.'&amp;page='.$i.'">'.$i.'</a> ';
			}
		}
	}

	$pagecontrolls .= '<a class="page active">'.$page.'</a> ';

	for ($i = $page+1; $i <= $pages; $i++) {
		$pagecontrolls .= '<a class="page" href="/ingame/?show=props&amp;tiertwo='.$tiertwo.'&amp;category='.$category.'&amp;page='.$i.'">'.$i.'</a> ';
		if ($i >= $page+4) {
			break;
		}
	}

	if ($page != $pages) {
		$pagecontrolls .= '<a class="page" href="/ingame/?show=props&amp;tiertwo='.$tiertwo.'&amp;category='.$category.'&amp;page='.($page+1).'">&gt;</a> ';
	}
?>
	<div class="pages">
	<?php
		echo $pagecontrolls;
	?>
	</div>
	<div class="paged_inner">
		<div>
			<div class="files_box">
				<?php foreach ($props as $item): ?>
				<?php
					if(file_exists('../uploads/images/'.$item['id'].'_thumb_128.jpg')){
						$image = '/uploads/images/'.$item['id'].'_thumb_128.jpg';
					}else{
						$image = '/client/no_thumb_128.png';
					}
				?>
				<?php include("./inc/item.inc.php") ?>
				<?php endforeach; ?>
				<div class="clear">&nbsp;</div>
			</div>
			<div class="clear">&nbsp;</div>
		</div>
	</div>
	<div class="pages">
	<?php
		echo $pagecontrolls;
	?>
	</div>
</div>