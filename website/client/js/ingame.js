function DoRating( panel, id, rating, hash )
{
	var RatingReplyPanel = $( panel ).parent().parent();
	$( RatingReplyPanel ).html( '..' );
	
	var func = function( data )
	{ 
		$( RatingReplyPanel ).html( data ); 
	}
	
	$.post( "/cloudscript/rate/", { action: rating, scriptid: id, hash: hash }, func, "html" );	
	
	return false;
}

function ToggleFavorite( panel, id, hash )
{
	var RatingReplyPanel = $( panel ).parent();
	$( RatingReplyPanel ).html( '..' );
	
	var func = function( data )
	{ 
		$( RatingReplyPanel ).html( data ); 
		ForceRedraw();
		$("#Favourite_ReplyMessage").dialog({
				modal: true,
				buttons: {
					Ok: function() 
					{
						$(this).dialog('close');
						$("#Favourite_ReplyMessage").remove();
					}
				}
			});
		ForceRedraw();
	}
	
	$.post( "/cloudscript/rate/", { action: 'fave', scriptid: id, hash: hash }, func, "html" );
	
	
	return false;
}

function OnHoverName( uid )
{
	$( '#INFO_' + uid ).show();
}

function OnHoverNameEnd( uid )
{
	$( '#INFO_' + uid ).hide();
}

function SendLua( lua )
{
	window.location = "lua://client/" + lua;
}

function StartSpawnmenuFocus( lua )
{
	window.location = "gmod://startspawnmenufocus/";
}

function EndSpawnmenuFocus( lua )
{
	window.location = "gmod://endspawnmenufocus/";
}

function ReceiveCategory( data )
{
	$( "body" ).css( 'background-image', 'none' );
	
	$( "#canvas" ).html( data );
	$( "#canvas" ).fadeIn( 'fast' );
}

function SwitchCategory( id, type )
{
	$.post( "/ingame/ajax/switchcategory/", { action: 'switchcat', id: id, type: type }, ReceiveCategory, "html" );	
	
	$( "#canvas" ).html('<div class="middle"><br/><br/><br/><br/><br/><img src="/client/loading.gif"><br/></div>' );
	
	// This little hack forces webkit to redraw the whole thing when the #canvas changes.
	$( "body" ).css( 'background-image', 'url( \'/client/loading.gif\' )' );
		
	return false;
}

function AddComment( form )
{
	var values = {};
	$.each( $( form ).serializeArray(), function(i, field) { values[field.name] = field.value;} );
	
	var text = $( form ).find( 'textarea' ).val();
	if ( text == "" ) return;
	
	var func = function( data )
	{
		if ( data )
		{
			$( "#commentform" ).before( data );
		}
		
		$( form ).find( '.submit' ).attr( 'disabled', '' );
		$( form ).find( '.submit' ).attr( 'value', 'Post Comment' );
		$( form ).find( 'textarea' ).val( '' );
		
	}
	
	$.post( "/ingame/ajax/postcomment/", values, func, "html" );	
	
	$( form ).find( '.submit' ).attr( 'disabled', 'disabled' );
	$( form ).find( '.submit' ).attr( 'value', 'Posting..' );
}


function OnButtonHover( pnl )
{
	$( pnl ).find( '.hover_overlay' ).show();
	//$( pnl ).parent().find( '.author' ).show();
}

function OnButtonHoverEnd( pnl )
{
	$( pnl ).find( '.hover_overlay' ).hide();
	//$( pnl ).parent().find( '.author' ).hide();
}

function OnMapClicked( name )
{
	$( '.' + name ).addClass( 'downloading' );
}

function OnMapSelected( name )
{
	$( '.script_box' ).removeClass( 'selected' );
	$( '.' + name ).removeClass( 'downloading' );
	
	$( '.' + name ).addClass( 'selected' );
	
}

var g_SearchOldContents = "";

function RestoreSearch()
{
	if ( g_SearchOldContents.length == "" ) return;
	
	$( "#searchtarget" ).html( g_SearchOldContents );
	
	$(".use_tooltip").tooltip( { position: 'bottom center', predelay: 500 } ).dynamic();
	$(".use_tooltip_top").tooltip( { position: 'top center', predelay: 500 } ).dynamic();
		
	g_SearchOldContents = "";
	
}

var g_RedrawedBool = false;

function ForceRedraw()
{
	if ( g_RedrawedBool )
		$( "BODY" ).css( "background-color", "#36393E" );
	else
		$( "BODY" ).css( "background-color", "#36393F" );
	
	g_RedrawedBool = !g_RedrawedBool;
	
	//setTimeout("timedCount()",1000);
}

function DoSearch( search, category )
{
	$('.tooltip').hide();

	if ( search.length < 2 )
		return RestoreSearch();
	
	if ( g_SearchOldContents == "" )
		g_SearchOldContents = $( "#searchtarget" ).html();
	
	var func = function( data )
	{
		if ( g_SearchOldContents == "" ) return;
		$('.tooltip').remove();
		$( "#searchtarget" ).html( data );
		
		$(".use_tooltip").tooltip( { position: 'bottom center', predelay: 500 } ).dynamic();
		$(".use_tooltip_top").tooltip( { position: 'top center', predelay: 500 } ).dynamic();
		
		ForceRedraw();
	}
	
	$.get( "/IG/AJAX_search.php", { search: search, type: category }, func, "html" );	
}

function DeleteScriptInline( id )
{
	$( "#script_" + id ).fadeOut( 'slow' );
	$.post( "/ingame/ajax/deletescript/", { id: id }, false, "html" );	
}

function LuaPrint(str)
{
	console.log("RUNLUA:print( \""+str+"\" )")
}

function LuaDownload(id, user, name)
{
	console.log("RUNLUA:funboxDownload( \""+id+"\", \""+user+"\", \""+name+"\" )")
}

function IngameCheck(id, user, name)
{
	if (ingame == true) {
		LuaDownload(id, user, name)
	}else{
		confirm("", function () {window.location.href = "?show=addon&id="+id;}, id);
	}
}