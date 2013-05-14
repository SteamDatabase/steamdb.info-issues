// ==UserScript==
// @version        1.6.0
// @name           Steam Database Integration
// @description    Adds Steam Database link across Steam Community and Store
// @homepage       http://steamdb.info
// @namespace      http://steamdb.info/userscript/
// @icon           http://steamdb.info/static/logo_144px.png
// @match          http://store.steampowered.com/app/*
// @match          http://store.steampowered.com/sub/*
// @match          http://store.steampowered.com/video/*
// @match          http://steamcommunity.com/app/*
// @match          http://steamcommunity.com/games/*
// @match          http://steamcommunity.com/id/*
// @match          http://steamcommunity.com/profiles/*
// @updateURL      https://github.com/SteamDatabase/SteamDatabase/raw/master/SteamDatabase.user.js
// ==/UserScript==

var mainURL  = 'http://steamdb.info',
    pathName = location.pathname,
    element,
    container,

    IMAGE_GROUP = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAeFBMVEUAAAD7+vvBwMHa2dj6+vvAv8GenZ/Z2djBv7/AwcDY2Nq/v8D6+vqdnp7Y2difnp7Awb/5+vnAv8C/v8Gdn5+enp7Z2NnBwMC/wL+fnZ6fn56en5/6+frZ2dnZ2NjY2dn5+/r7+fnY2Nj7+vr6+/qenp/AwMCen55YC6VhAAAAAXRSTlMAQObYZgAAAExJREFUeNq1zrcBgDAMAEEyJoPJwdmW9t+QBVTC11d89E9emynOWu28cQ8ptj5VQopalspaUhzz2FTAkpzvAKQIeK5D0eGC1x2+GX8BaDwE0HkrefEAAAAASUVORK5CYII=',
    IMAGE_STORE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARYAAAAlCAMAAACwCjbKAAABGlBMVEUAAAD7+vv6+vvBv7/a2djAwcD6+vrY2NrBwMHZ2djAv8HY2dj5+vm/v8CenZ+dnp7Av8Cfnp7Awb/Z2Nmdn5/BwMC/v8Genp6/wL+fnZ6fn576+fqen5+Bf3vZ2dnZ2NjY2dn5+/r7+vr7+fnY2Nj6+/qenp+WlJFsammtq6ipp6Slo6Cgnpycmph9e3iGhIFxbmx1cnBoZmN5d3SPjYptamiYlpOUko+CgH07OTnAwMCen55oZWNraGZlYmBiX11/fHmxr6yLiYZ9e3dpZ2RsamdmZGFua2l7eXZjYF5vbWpxb2xgXVt6eHRycG11c3B3dXF0cm54dnNPTEtfXFpdWlhaV1VbWVdXVFJYVlRVUlFUUU9ST05RTk1/9Yr5AAAAAXRSTlMAQObYZgAAAQhJREFUeNrt0NVWAgEUBdAxUTFAMTDo7o4ZyjFAUcHC/v/f0OV58N5nH+fsT9jGj9QpSSnjVzpp059kGi2ZAQknGbRkz0jKoiU3IimHlvwtSXm0NB5IaqClOSWpiZbahKQaWux7kmy0FO9IKqKlNSaphZbCNUkFtFSHJFXRUr4gqYyWUleKh6Prc/PL4Ug8GjnqOlEJLfVzkupoqXSkHfdiKBAMuIKroVis40QVtFyShpaecrC3vbFkLqyseXZNs+dIaLkiDS19JWH5972bW5bPOjxO9B0JLTekoeWJNLQ8k4aWF9LQMiMNLW+koeWVNLS8k4aWD9LQ8kkaWr5IQ0v7kaS2QUT/9Q1Dy8tw8txFbQAAAABJRU5ErkJggg==';

var SteamDB =
{
	CurrentAppID: 0,
	
	FindAppID: function( )
	{
		element = pathName.match( /(\d)+/g );
		
		if( element )
		{
			SteamDB.CurrentAppID = SteamDB.CurrentAppID[ 0 ];
		}
	},
	
	/**
	 * Game hubs
	 */
	InjectGameHub: function( )
	{
		container = document.querySelector( '.apphub_OtherSiteInfo' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'a' );
		element.className = 'btn_blue_white_innerfade btn_medium';
		element.href = mainURL + '/app/' + SteamDB.CurrentAppID + '/';
		element.target = '_blank';
		element.innerHTML = '<span>Steam Database</span>';
		
		container.insertBefore( element, container.firstChild );
	},
	
	/**
	 * Official game groups
	 */
	InjectGameGroup: function( )
	{
		// Some game groups fancy custom urls
		if( !SteamDB.CurrentAppID )
		{
			// Let's try to find game hub link, what possibly could go wrong?
			container = document.querySelector( 'a[href*="http://steamcommunity.com/app/"]' );
			
			if( !container )
			{
				return;
			}
			
			SteamDB.CurrentAppID = container.href.match( /(\d)+/g )[ 0 ];
		}
		
		container = document.querySelector( '#rightActionBlock' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'div' );
		element.className = 'actionItem';
		element.innerHTML = '<div class="actionItemIcon"><img src="' + IMAGE_GROUP + '" width="16" height="16" alt=""></div><a class="linkActionMinor" target="_blank" href="' + mainURL + '/app/' + SteamDB.CurrentAppID + '/">View on Steam Database</a>';
		
		container.insertBefore( element, null );
		
		// While we're here, let's fix this annoyance
		element = document.querySelector( '#oggLogo img' );
		
		if( element )
		{
			element.style.height = '208px';
		}
	},
	
	/**
	 * App store page
	 */
	InjectStoreApp: function( )
	{
		container = document.querySelector( '#demo_block .block_content_inner' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'div' );
		element.className = 'demo_area_button';
		element.innerHTML = '<a class="game_area_wishlist_btn" target="_blank" href="' + mainURL + '/app/' + SteamDB.CurrentAppID + '/" style="background-image:url(' + IMAGE_STORE + ')">View on Steam Database</a>';
		
		container.insertBefore( element, container.firstChild );
		
		// Find each "add to cart" button
		container = document.querySelectorAll( 'input[name="subid"]' );
		
		var i = 0, appid = 0;
		
		for( i = 0; i < container.length; i++ )
		{
			element = container[ i ];
			
			appid = element.value; // It's subid, but let's reuse things
			
			element.parentElement.parentElement.insertAdjacentHTML( 'beforeEnd', '<a target="_blank" href="'+ mainURL + '/sub/' + appid + '/" style="float:left;color:#898A8C">View on Steam Database <i>(' + appid + ')</i></a>' );
		}
		
		// While we're here, let's fix this broken url
		element = document.querySelector( '.apphub_OtherSiteInfo a' );
		
		if( element && element.href.charAt( 26 ) === '/' )
		{
			element.href = element.href.replace( /\/\/app\//, '/app/' ) + '/';
		}
	},
	
	/**
	 * Package store page
	 */
	InjectStorePackage: function( )
	{
		container = document.querySelector( '.share' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'div' );
		element.className = 'demo_area_button';
		element.innerHTML = '<a class="game_area_wishlist_btn" target="_blank" href="' + mainURL + '/sub/' + SteamDB.CurrentAppID + '/" style="background-image:url(' + IMAGE_STORE + ')">View on Steam Database</a>';
		
		container.insertBefore( element, container.firstChild );
		
		
	},
	
	/**
	 * Trailer/movie store page
	 */
	InjectStoreVideo: function( )
	{
		container = document.querySelector( '.game_details .block_content_inner' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'div' );
		element.innerHTML = '<a class="game_area_wishlist_btn" target="_blank" href="' + mainURL + '/app/' + SteamDB.CurrentAppID + '/" style="background-image:url(' + IMAGE_STORE + ')">View on Steam Database</a>';
		
		container.insertBefore( element, null );
	},
	
	/**
	 * Inventory page
	 */
	InjectProfileInventory: function( )
	{
		if( !document.getElementById( 'inventory_link_753' ) )
		{
			// There is no Steam inventory, so don't bother hooking
			return;
		}
		
		element = document.createElement( 'script' );
		element.id = 'steamdb_inventory_hook';
		element.type = 'text/javascript'; 
		element.appendChild( document.createTextNode( '(' + SteamDB.InsaneInventoryHackery + ')();' ) );
		
		document.head.appendChild( element );
	},
	
	/**
	 * This function is injected into DOM
	 */
	InsaneInventoryHackery: function( )
	{
		var i, link, SteamDB_Hackery_PopulateActions = window.PopulateActions;
		
		window.PopulateActions = function( elActions, rgActions, item )
		{
			var foundState = 0;
			
			try
			{
				if( item.appid === 753 )
				{
					if( rgActions )
					{
						for( i = 0; i < rgActions.length; i++ )
						{
							link = rgActions[ i ];
							
							if( link.steamdb )
							{
								foundState = 2;
								break;
							}
							else if( link.link && link.link.match( /\.com\/app\// ) )
							{
								foundState = 1;
							}
						}
						
						if( foundState === 1 )
						{
							for( i = 0; i < rgActions.length; i++ )
							{
								link = rgActions[ i ].link;
								
								if( link && link.match( /\.com\/app\// ) )
								{
									rgActions.push( {
										steamdb: true,
										link: 'http://steamdb.info/app/' + link.match( /(\d)+/g ) + '/', // mainURL is not accessible from here
										name: 'View on Steam Database'
									} );
									
									foundState = 2;
									
									break;
								}
							}
						}
					}
					else if( !item.actions && item.type === 'Gift' ) // This function gets called with owner_actions too
					{
						item.actions = rgActions = [ {
							steamdb: true,
							link: 'http://steamdb.info/search/?a=sub&q=' + encodeURIComponent( item.name ), // mainURL is not accessible from here
							name: 'Search on Steam Database'
						} ];
						
						foundState = 2;
					}
				}
			}
			catch( e )
			{
				// Don't break website functionality if something fails above
			}
			
			SteamDB_Hackery_PopulateActions( elActions, rgActions, item );
			
			// We want our links to be open in new tab
			if( foundState === 2 )
			{
				link = elActions.querySelector( '.item_action[href^="http://steamdb.info"]' );
				
				if( link )
				{
					link.target = '_blank';
				}
			}
		};
	}
};

SteamDB.FindAppID( );

if( location.hostname === 'steamcommunity.com' )
{
	if( pathName.match( /^\/app\// ) )
	{
		SteamDB.InjectGameHub( );
	}
	else if( pathName.match( /^\/games\// ) )
	{
		SteamDB.InjectGameGroup( );
	}
	else if( pathName.match( /^\/(id|profiles)\/[\S]+\/inventory\// ) ) // /^\/(id|profiles)\//
	{
		SteamDB.InjectProfileInventory( );
	}
}
else
{
	// Did we hit an error page?
	container = document.getElementById( 'error_box' );
	
	if( container )
	{
		container.insertAdjacentHTML( 'beforeEnd', '<br><br><a target="_blank" href="'+ mainURL + '/app/' + SteamDB.CurrentAppID + '/">View on Steam Database</a>' );
		
		return;
	}
	
	if( pathName.match( /^\/app\// ) )
	{
		SteamDB.InjectStoreApp( );
	}
	else if( pathName.match( /^\/sub\// ) )
	{
		SteamDB.InjectStorePackage( );
	}
	else if( pathName.match( /^\/video\// ) )
	{
		SteamDB.InjectStoreVideo( );
	}
}
