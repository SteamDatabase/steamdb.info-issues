// ==UserScript==
// @version        1.5.2
// @name           Steam Apps Database Integration
// @description    Adds Steam Database link across Steam Community and Store
// @homepage       http://steamdb.info
// @namespace      http://steamdb.info/userscript/
// @icon           http://steamdb.info/static/logo_144px.png
// @match          http://store.steampowered.com/app/*
// @match          http://store.steampowered.com/sub/*
// @match          http://store.steampowered.com/video/*
// @match          http://steamcommunity.com/app/*
// @match          http://steamcommunity.com/games/*
// @updateURL      https://github.com/SteamDatabase/SteamDatabase/raw/master/SteamDatabase.user.js
// ==/UserScript==

var mainURL = 'http://steamdb.info',
    appid = location.pathname.match( /(\d)+/g ),
    element, container,

    IMAGE_GROUP = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAeFBMVEUAAAD7+vvBwMHa2dj6+vvAv8GenZ/Z2djBv7/AwcDY2Nq/v8D6+vqdnp7Y2difnp7Awb/5+vnAv8C/v8Gdn5+enp7Z2NnBwMC/wL+fnZ6fn56en5/6+frZ2dnZ2NjY2dn5+/r7+fnY2Nj7+vr6+/qenp/AwMCen55YC6VhAAAAAXRSTlMAQObYZgAAAExJREFUeNq1zrcBgDAMAEEyJoPJwdmW9t+QBVTC11d89E9emynOWu28cQ8ptj5VQopalspaUhzz2FTAkpzvAKQIeK5D0eGC1x2+GX8BaDwE0HkrefEAAAAASUVORK5CYII=',
    IMAGE_STORE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARYAAAAlCAMAAACwCjbKAAABGlBMVEUAAAD7+vv6+vvBv7/a2djAwcD6+vrY2NrBwMHZ2djAv8HY2dj5+vm/v8CenZ+dnp7Av8Cfnp7Awb/Z2Nmdn5/BwMC/v8Genp6/wL+fnZ6fn576+fqen5+Bf3vZ2dnZ2NjY2dn5+/r7+vr7+fnY2Nj6+/qenp+WlJFsammtq6ipp6Slo6Cgnpycmph9e3iGhIFxbmx1cnBoZmN5d3SPjYptamiYlpOUko+CgH07OTnAwMCen55oZWNraGZlYmBiX11/fHmxr6yLiYZ9e3dpZ2RsamdmZGFua2l7eXZjYF5vbWpxb2xgXVt6eHRycG11c3B3dXF0cm54dnNPTEtfXFpdWlhaV1VbWVdXVFJYVlRVUlFUUU9ST05RTk1/9Yr5AAAAAXRSTlMAQObYZgAAAQhJREFUeNrt0NVWAgEUBdAxUTFAMTDo7o4ZyjFAUcHC/v/f0OV58N5nH+fsT9jGj9QpSSnjVzpp059kGi2ZAQknGbRkz0jKoiU3IimHlvwtSXm0NB5IaqClOSWpiZbahKQaWux7kmy0FO9IKqKlNSaphZbCNUkFtFSHJFXRUr4gqYyWUleKh6Prc/PL4Ug8GjnqOlEJLfVzkupoqXSkHfdiKBAMuIKroVis40QVtFyShpaecrC3vbFkLqyseXZNs+dIaLkiDS19JWH5972bW5bPOjxO9B0JLTekoeWJNLQ8k4aWF9LQMiMNLW+koeWVNLS8k4aWD9LQ8kkaWr5IQ0v7kaS2QUT/9Q1Dy8tw8txFbQAAAABJRU5ErkJggg==';

// Some game groups fancy custom urls
if( !appid )
{
	// Let's try to find game hub link, what possibly could go wrong?
	appid = document.querySelector( 'a[href*="http://steamcommunity.com/app/"]' );
	
	if( !appid )
	{
		// Well...
		
		return;
	}
	
	// I will be surprised if it's not broken at this point
	appid = appid.href.match( /(\d)+/g );
}

appid = appid[ 0 ];

if( location.hostname === 'steamcommunity.com' )
{
	if( location.pathname.match( /\/app\// ) )
	{
		// Game Hub
		
		container = document.querySelector( '.apphub_OtherSiteInfo' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'a' );
		element.className = 'btn_blue_white_innerfade btn_medium';
		element.href = mainURL + '/app/' + appid + '/';
		element.target = '_blank';
		element.innerHTML = '<span>Steam Database</span>';
		
		container.insertBefore( element, container.firstChild );
	}
	else
	{
		// Game Group
		
		container = document.querySelector( '#rightActionBlock' );
		
		if( !container )
		{
			return;
		}
		
		element = document.createElement( 'div' );
		element.className = 'actionItem';
		element.innerHTML = '<div class="actionItemIcon"><img src="' + IMAGE_GROUP + '" width="16" height="16" alt=""></div><a class="linkActionMinor" target="_blank" href="' + mainURL + '/app/' + appid + '/">View in Steam Database</a>';
		
		container.insertBefore( element, null );
		
		// While we're here, let's fix this annoyance
		element = document.querySelector( '#oggLogo img' );
		
		if( element )
		{
			element.style.height = '208px';
		}
	}
}
else
{
	// Did we hit an error page?
	container = document.getElementById( 'error_box' );
	
	if( container )
	{
		container.insertAdjacentHTML( 'beforeEnd', '<br><br><a target="_blank" href="'+ mainURL + '/app/' + appid + '/">View in Steam Database</a>' );
		
		return;
	}
	
	var isSubPage = location.pathname.match( /\/sub\// );
	
	element = document.createElement( 'div' );
	element.className = 'demo_area_button';
	element.innerHTML = '<a class="game_area_wishlist_btn" target="_blank" href="' + mainURL + ( isSubPage ? '/sub/' : '/app/' ) + appid + '/" style="background-image:url(' + IMAGE_STORE + ')">View in Steam Database</a>';
	
	if( location.pathname.match( /\/video\// ) )
	{
		// Video page
		
		container = document.querySelector( '.game_details .block_content_inner' );
		
		if( container )
		{
			container.insertBefore( element, null );
			
			// Make it prettier
			element.className = '';
		}
	}
	else
	{
		// App or sub page
		
		container = document.querySelector( isSubPage ? '.share' : '#demo_block .block_content_inner' );
		
		if( container )
		{
			container.insertBefore( element, container.firstChild );
		}
		
		// Link each package on app page
		if( !isSubPage )
		{
			// Find each "add to cart" button
			container = document.querySelectorAll( 'input[name="subid"]' );
			
			for( var i = 0; i < container.length; i++ )
			{
				element = container[ i ];
				
				appid = element.value; // It's subid, but let's reuse things
				
				element.parentElement.parentElement.insertAdjacentHTML( 'beforeEnd', '<a target="_blank" href="'+ mainURL + '/sub/' + appid + '/" style="float:left;color:#898A8C">View in Steam Database <i>(' + appid + ')</i></a>' );
			}
			
			// While we're here, let's fix this broken url
			element = document.querySelector( '.apphub_OtherSiteInfo a' );
			
			if( element && element.href.charAt( 26 ) === '/' ) // Pretty stupid check, but it works
			{
				element.href = element.href.replace( /\/\/app\//, '/app/' ) + '/';
			}
		}
	}
}
