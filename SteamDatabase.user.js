// ==UserScript==
// @version        1.5.1
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
	element, container;

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
		element.innerHTML = '<div class="actionItemIcon"><img src="' + mainURL + '/static/userjs/group.png" width="16" height="16" alt=""></div><a class="linkActionMinor" target="_blank" href="' + mainURL + '/app/' + appid + '/">View in Steam Database</a>';
		
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
	element.innerHTML = '<a class="game_area_wishlist_btn" target="_blank" href="' + mainURL + ( isSubPage ? '/sub/' : '/app/' ) + appid + '/" style="background-image:url(' + mainURL + '/static/userjs/store.png)">View in Steam Database</a>';
	
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
