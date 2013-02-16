// ==UserScript==
// @version        1.0
// @name           Steam Store - Apps Database Link
// @namespace      http://steamdb.info/?user=store
// @match          http://store.steampowered.com/app/*
// @match          http://store.steampowered.com/sub/*
// ==/UserScript==

var mainURL = 'http://steamdb.info',
	appid = location.pathname.match( /(\d)+/g ),
	isSubPage = location.pathname.match( /\/sub\// ),
	demoBlock = document.querySelector( isSubPage ? '.share' : '.demo_area_button' );

if( !demoBlock )
{
	var demoBlock = document.querySelector( '.error' );
	
	if( demoBlock )
	{
		demoBlock.innerHTML += '<br><br><a href="'+ mainURL + '/app/' + appid + '/" target="_blank">View in Apps Database</a>';
	}
	
	return;
}

var element = document.createElement( 'div' );
element.className = 'demo_area_button';
element.innerHTML = '<a class="game_area_wishlist_btn" href="' + mainURL + ( isSubPage ? '/sub/' : '/app/' ) + appid + '/" target="_blank">View in Apps Database</a>';

demoBlock.parentNode.insertBefore( element, demoBlock );
