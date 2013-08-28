// ==UserScript==
// @version        1.7.1
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
// @match          http://steamcommunity.com/market/*
// @match          http://steamcommunity.com/sharedfiles/filedetails*
// @match          http://steamcommunity.com/workshop/browse*
// @match          http://steamcommunity.com/workshop/discussions*
// @updateURL      https://github.com/SteamDatabase/SteamDatabase/raw/master/SteamDatabase.user.js
// ==/UserScript==

var mainURL  = 'http://steamdb.info',
    pathName = location.pathname,
    element,
    container,

    IMAGE_PROFILE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAACTElEQVR42p2UO2hTURjHr/XRQCtSWnyAOBWEVumQRXBSqTiUOqiL6CBZBCedpEtAhEJXoUPERbDo0slSUDSWFBQMQiSQ182TvG8Sktw8m3t7/J2QDKGxtl748f/O97rnfPdwFeUfjxDiDFyuVquTyv88FI92Op2bpmm+gi/YDsMwbuMfP3ATiq7BN9AoNkH0tITvZ6vVkg2PDS0ul8sTzWbzRrvd/gw7IPaD3O+NRuMuDafgiJLNZsfq9foizg1o8jZxCNo0/Eq9Tc5iBMOq6/omKg6JUavVXGzg6sDxaDYL65VKRUMNvpQYgkmsyCi20Ov7fq1CoTBP4goNg2CCkOBLoqulUmkhGo1aBgrtdvuI1+s9QfB+sVh8nc/nbTSzuN3u4xRN03QJ/za6jM7I2LD87rA1TXtBYhmEhOBv9An+c3KG/Reqqno6l8vdIf6DuAG7oLN+290V3U+xuEeSA9LYspnBS37Bc+xb6FNw9WICu0LuGjyIx+MTA8eU5yYwl06n34CeyWQEuoMWoNlbt+A9WP1+/8k9Q5Zdw+HwhWQyOSkvWCgUOo/tgEQqldIhg/0hkUhcGpaveDyeMZyLsAEqiZ/Qx5FI5CIJR9E51g/Z7RX5AdCz5DzC97GfH4vFbN0h4rBSsIkKCYE6qPhe9rfPXMbZwTMaqcR08nbBYO1CBy8kx5klsE6Bhho0EthZ/O/4YmG5BhOKsIXv7xeSotFgMDhP0goEwQQhIZaEVeILTqfTcqBfiZwHxdM+n28pEAhswzJNZvbc6N7zB4IDJhjugBeWAAAAAElFTkSuQmCC',
    IMAGE_GROUP   = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAeFBMVEUAAAD7+vvBwMHa2dj6+vvAv8GenZ/Z2djBv7/AwcDY2Nq/v8D6+vqdnp7Y2difnp7Awb/5+vnAv8C/v8Gdn5+enp7Z2NnBwMC/wL+fnZ6fn56en5/6+frZ2dnZ2NjY2dn5+/r7+fnY2Nj7+vr6+/qenp/AwMCen55YC6VhAAAAAXRSTlMAQObYZgAAAExJREFUeNq1zrcBgDAMAEEyJoPJwdmW9t+QBVTC11d89E9emynOWu28cQ8ptj5VQopalspaUhzz2FTAkpzvAKQIeK5D0eGC1x2+GX8BaDwE0HkrefEAAAAASUVORK5CYII=',
    IMAGE_STORE   = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARYAAAAlCAMAAACwCjbKAAABGlBMVEUAAAD7+vv6+vvBv7/a2djAwcD6+vrY2NrBwMHZ2djAv8HY2dj5+vm/v8CenZ+dnp7Av8Cfnp7Awb/Z2Nmdn5/BwMC/v8Genp6/wL+fnZ6fn576+fqen5+Bf3vZ2dnZ2NjY2dn5+/r7+vr7+fnY2Nj6+/qenp+WlJFsammtq6ipp6Slo6Cgnpycmph9e3iGhIFxbmx1cnBoZmN5d3SPjYptamiYlpOUko+CgH07OTnAwMCen55oZWNraGZlYmBiX11/fHmxr6yLiYZ9e3dpZ2RsamdmZGFua2l7eXZjYF5vbWpxb2xgXVt6eHRycG11c3B3dXF0cm54dnNPTEtfXFpdWlhaV1VbWVdXVFJYVlRVUlFUUU9ST05RTk1/9Yr5AAAAAXRSTlMAQObYZgAAAQhJREFUeNrt0NVWAgEUBdAxUTFAMTDo7o4ZyjFAUcHC/v/f0OV58N5nH+fsT9jGj9QpSSnjVzpp059kGi2ZAQknGbRkz0jKoiU3IimHlvwtSXm0NB5IaqClOSWpiZbahKQaWux7kmy0FO9IKqKlNSaphZbCNUkFtFSHJFXRUr4gqYyWUleKh6Prc/PL4Ug8GjnqOlEJLfVzkupoqXSkHfdiKBAMuIKroVis40QVtFyShpaecrC3vbFkLqyseXZNs+dIaLkiDS19JWH5972bW5bPOjxO9B0JLTekoeWJNLQ8k4aWF9LQMiMNLW+koeWVNLS8k4aWD9LQ8kkaWr5IQ0v7kaS2QUT/9Q1Dy8tw8txFbQAAAABJRU5ErkJggg==';

var SteamDB =
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
	 * Game hubs
	 */
	InjectGameHub: function( bSharedFile, bHackyGameURL )
	{
		container = document.querySelector( '.apphub_OtherSiteInfo' );
		
		if( !container )
		{
			return;
		}
		
		if( bSharedFile || bHackyGameURL )
		{
			element = document.querySelector( '.apphub_sectionTab' );
			
			if( !element )
			{
				return;
			}
			
			SteamDB.CurrentAppID = element.href.match( SteamDB.RegexAppID )[ 1 ];
		}
		
		element = document.createElement( 'a' );
		element.className = 'btn_darkblue_white_innerfade btn_medium';
		element.href = mainURL + '/app/' + SteamDB.CurrentAppID + '/';
		element.target = '_blank';
		element.innerHTML = '<span>Steam Database</span>';
		
		if( bSharedFile )
		{
			// Steam piston blocks button, and can't be clicked
			element.style.position = 'relative';
			element.style.zIndex = 1;
		}
		
		container.insertBefore( element, container.firstChild );
		
		// fix AppName madness
		element = document.querySelector( '.apphub_AppName' );
		
		if( element )
		{
			element.style.paddingRight = '30px';
			element.style.maxWidth = 'none';
			element.style.float = 'none';
		}
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
			
			SteamDB.CurrentAppID = container.href.match( SteamDB.RegexAppID )[ 1 ];
		}
		
		// Uh oh, if we are in game hub with a fancy /games/ url, we should use game hub code instead
		if( document.querySelector( '.apphub_OtherSiteInfo' ) !== null )
		{
			SteamDB.InjectGameHub( false, true );
			
			return;
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
			
			element = element.parentElement.parentElement;
			
			element.insertAdjacentHTML( 'beforeEnd', '<a class="steamdb_sub_link" target="_blank" href="'+ mainURL + '/sub/' + appid + '/" style="' + ( element.querySelector( '.game_area_purchase_game_dropdown_left_panel' ) ? '' : 'float:left;' ) + 'color:#898A8C">View on Steam Database <i>(' + appid + ')</i></a>' );
		}
		
		// While we're here, let's fix this broken url
		element = document.querySelector( '.apphub_OtherSiteInfo a' );
		
		if( element && element.href.charAt( 26 ) === '/' )
		{
			element.href = element.href.replace( /\/\/app\//, '/app/' ) + '/';
		}
		
		if( !document.querySelector( '.game_area_purchase_game_dropdown_selection' ) )
		{
			// There are no dropdowns, so don't bother hooking
			return;
		}
		
		element = document.createElement( 'script' );
		element.id = 'steamdb_dropdown_hook';
		element.type = 'text/javascript'; 
		element.appendChild( document.createTextNode( '(' + SteamDB.InjectAppSubscriptions + ')();' ) );
		
		document.head.appendChild( element );
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
	 * Profile page
	 */
	InjectProfile: function( )
	{
		container = document.querySelector( '#profile_action_dropdown .popup_body' );
		
		if( !container )
		{
			return;
		}
		
		// Can't access g_rgProfileData inside sandbox
		var steamID = pathName.match( /^\/(id|profiles)\/([^\s/]+)\/?$/ );
		
		if( !steamID )
		{
			// wtf?
			return;
		}
		
		element = document.createElement( 'a' );
		element.href = mainURL + '/calculator/?player=' + steamID[ 2 ];
		element.target = '_blank';
		element.className = 'popup_menu_item';
		element.innerHTML = '<img src="' + IMAGE_PROFILE + '">&nbsp; SteamDB Calculator';
		
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
	 * Market page
	 */
	InjectMarketInventory: function( )
	{
		element = document.createElement( 'script' );
		element.id = 'steamdb_market_hook';
		element.type = 'text/javascript'; 
		element.appendChild( document.createTextNode( '(' + SteamDB.InsaneMarketHackery + ')();' ) );
		
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
				if( item.appid == 753 )
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
							else if( link.link && link.link.match( /\.com\/(app|sub)\// ) )
							{
								foundState = 1;
							}
						}
						
						if( foundState === 1 )
						{
							for( i = 0; i < rgActions.length; i++ )
							{
								link = rgActions[ i ].link;
								
								if( !link )
								{
									continue;
								}
								
								link = link.match( /\.com\/(app|sub)\/([0-9]{1,6})/ );
								
								if( link )
								{
									rgActions.push( {
										steamdb: true,
										link: 'http://steamdb.info/' + link[ 1 ] + '/' + link[ 2 ] + '/', // mainURL is not accessible from here
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
					
					if( item.tags )
					{
						for( i = 0; i < item.tags.length; i++ )
						{
							link = item.tags[ i ];
							
							if( ( link.internal_name === 'cardborder_1' || link.internal_name === 'droprate_1' || link.internal_name === 'droprate_2' ) && link.name.substring( 0, 5 ) !== '<span' )
							{
								item.tags[ i ].name = '<span style="color:#f39c12">' + link.name + '</span>';
							}
						}
					}
				}
			}
			catch( e )
			{
				// Don't break website functionality if something fails above
				console.log( e );
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
	},
	
	InsaneMarketHackery: function( )
	{
		var SteamDB_Hackery_BuildHover = window.BuildHover;
		
		window.BuildHover = function( prefix, item, owner )
		{
			try
			{
				if( item.classid )
				{
					var found = false;
					
					if( !Array.isArray( item.fraudwarnings ) )
					{
						item.fraudwarnings = [ ];
					}
					else
					{
						// We have to search if we inserted already because Steam's economy code re-uses things weirdly
						for( var i = 0; i < item.fraudwarnings.length; i++ )
						{
							if( item.fraudwarnings[ i ].substring( 0, 7 ) === 'ClassID' )
							{
								found = true;
								
								break;
							}
						}
					}
					
					if( !found )
					{
						item.fraudwarnings.push( 'ClassID: ' + item.classid );
						
						if( item.instanceid > 0 )
						{
							item.fraudwarnings.push( 'InstanceID: ' + item.instanceid );
						}
						
						if( item.app_data && item.app_data.def_index )
						{
							item.fraudwarnings.push( 'DefIndex: ' + item.app_data.def_index );
						}
					}
				}
			}
			catch( e )
			{
				// Don't break website functionality if something fails above
				console.log( e );
			}
			
			SteamDB_Hackery_BuildHover( prefix, item, owner );
		};
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
				link = document.getElementById('add_to_cart_' + dropdownName + '_description_text');
				link = link.parentNode.querySelector( '.steamdb_sub_link' );
				
				link.href = 'http://steamdb.info/sub/' + subId + '/';
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

if( location.hostname === 'steamcommunity.com' )
{
	if( pathName.match( /^\/app\// ) )
	{
		SteamDB.FindAppID( );
		
		SteamDB.InjectGameHub( false );
	}
	else if( pathName.match( /^\/sharedfiles\/filedetails\/?$/ ) || pathName.match( /^\/workshop\/(browse|discussions)\/?/ ) )
	{
		SteamDB.InjectGameHub( true );
	}
	else if( pathName.match( /^\/games\// ) )
	{
		SteamDB.FindAppID( );
		
		SteamDB.InjectGameGroup( );
	}
	else if( pathName.match( /^\/(id|profiles)\/[^\s/]+\/?$/ ) )
	{
		SteamDB.InjectProfile( );
	}
	else if( pathName.match( /^\/(id|profiles)\/[^\s/]+\/inventory/ ) )
	{
		SteamDB.InjectProfileInventory( );
		SteamDB.InjectMarketInventory( );
	}
	else if( pathName.match( /^\/market\// ) )
	{
		SteamDB.InjectMarketInventory( );
	}
}
else
{
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
	else if( pathName.match( /^\/video\// ) )
	{
		SteamDB.InjectStoreVideo( );
	}
}
