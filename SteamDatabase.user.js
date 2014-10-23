// ==UserScript==
// @version        2.0
// @name           Steam Database Integration
// @description    Adds Steam Database links on Steam Store
// @homepage       https://steamdb.info/
// @namespace      https://steamdb.info/extension/
// @icon           https://steamdb.info/static/logos/256.png
// @match          *://store.steampowered.com/app/*
// @match          *://store.steampowered.com/sub/*
// @updateURL      https://github.com/SteamDatabase/SteamDatabase/raw/master/SteamDatabase.user.js
// @grant          none
// ==/UserScript==

//
// This userscript is very stripped down.
// Please check https://steamdb.info/extension/ to see if we have a proper extension for your browser
//

var mainURL  = 'https://steamdb.info',
    pathName = location.pathname,
    element,
    container,

SteamDB =
{
	CurrentAppID: 0,
	
	RegexAppID: /\/([0-9]{1,6})\/?/,
	
	FindAppID: function( )
	{
		element = pathName.match( SteamDB.RegexAppID );
		
		if( element )
		{
			SteamDB.CurrentAppID = element[ 1 ];
		}
	},
	
	/**
	 * App store page
	 */
	InjectStoreApp: function( )
	{
		container = document.querySelector( '#demo_block' );
		
		if( !container )
		{
			return;
		}
		
		var link = document.createElement( 'a' );
		link.className = 'btnv6_blue_hoverfade btn_medium btn_steamdb';
		link.target = '_blank';
		link.href = mainURL + '/app/' + SteamDB.CurrentAppID + '/';
		
		element = document.createElement( 'span' );
		element.dataset.storeTooltip = 'View on Steam Database';
		link.appendChild( element );
		
		var image = document.createElement( 'img' );
		image.className = 'ico16';
		image.src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAMAAABhEH5lAAAAh1BMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9qkf8RAAAALHRSTlMA9av6xf1BBfHZkl9bVzAMz6+mK929a0smIxXj1Zl2ZDwZuLWFfkY3Acefe8hESa8AAADdSURBVBjTPZDZloQgDEQDCgKCCu67vffM8P/fNxFOd70lJ7lVCaCm3P00RMj215Rw6uKYD5rdnc5uAihEbCQv8+LmuM0F0NiRz2yrp55vniLpuTmrTshwXyvmF6jzIgMoTWFsEuY7gD+SKN0/bASQHacX+7g1LFq0nV0GxF8Rk9VG8wGBV8RLzw746mBeQu49W3WdnZN6RUAOoEXAVFUwFBqAC9orSYKbVD0VHFKfAqocxzNtKFMM9/7Q353HFsedSuEJWZGrCrc5wNjGmPGcdowf22naENKkdL9g+Q+kmBjmtA/0IQAAAABJRU5ErkJggg==';
		
		element.appendChild( image );
		
		container.insertBefore( link, container.firstChild );
		
		// Find each "add to cart" button
		container = document.querySelectorAll( 'input[name="subid"]' );
		
		var i = 0, appid = 0;
		
		for( i = 0; i < container.length; i++ )
		{
			element = container[ i ];
			
			appid = element.value; // It's subid, but let's reuse things
			
			element = element.parentElement.parentElement;
			
			element.insertAdjacentHTML( 'beforeEnd', '<a class="steamdb_sub_link" target="_blank" href="'+ mainURL + '/sub/' + appid + '/" style="' + ( element.querySelector( '.game_area_purchase_game_dropdown_left_panel' ) ? '' : 'float:left;' ) + 'color:#898A8C">View on Steam Database <i>(' + appid + ')</i></a>' );
		}
		
		if( document.querySelector( '.game_area_purchase_game_dropdown_selection' ) )
		{
			element = document.createElement( 'script' );
			element.id = 'steamdb_dropdown_hook';
			element.type = 'text/javascript'; 
			element.appendChild( document.createTextNode( '(' + SteamDB.InjectAppSubscriptions + ')();' ) );
			
			document.head.appendChild( element );
		}
	},
	
	/**
	 * Package store page
	 */
	InjectStorePackage: function( )
	{
		container = document.querySelector( '.game_meta_data' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'span' );
		element.appendChild( document.createTextNode( 'View on Steam Database' ) );
		
		var link = document.createElement( 'a' );
		link.className = 'action_btn';
		link.target = '_blank';
		link.href = mainURL + '/sub/' + SteamDB.CurrentAppID + '/';
		link.appendChild( element );
		
		element = document.createElement( 'div' );
		element.className = 'block';
		element.appendChild( link );
		
		container.insertBefore( element, container.firstChild );
	},
	
	/**
	 * This function is injected into store's app page
	 */
	InjectAppSubscriptions: function( )
	{
		var link, SteamDB_Hackery_dropdownSelectOption = window.dropdownSelectOption;
		
		window.dropdownSelectOption = function( dropdownName, subId, inCart )
		{
			try
			{
				link = document.getElementById( 'add_to_cart_' + dropdownName + '_description_text' );
				link = link.parentNode.querySelector( '.steamdb_sub_link' );
				
				link.href = 'https://steamdb.info/sub/' + subId + '/';
				link.innerHTML = 'View on Steam Database <i>(' + subId + ')</i>';
			}
			catch( e )
			{
				// Don't break website functionality if something fails above
			}
			
			SteamDB_Hackery_dropdownSelectOption( dropdownName, subId, inCart );
		};
	}
};

SteamDB.FindAppID( );

// Did we hit an error page?
container = document.getElementById( 'error_box' );

if( container )
{
	container.insertAdjacentHTML( 'beforeEnd', '<br><br><a target="_blank" href="'+ mainURL + '/app/' + SteamDB.CurrentAppID + '/">View on Steam Database</a>' );
}
else if( pathName.match( /^\/app\// ) )
{
	SteamDB.InjectStoreApp( );
}
else if( pathName.match( /^\/sub\// ) )
{
	SteamDB.InjectStorePackage( );
}
