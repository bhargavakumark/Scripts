// ==UserScript==
// @name           bk_custom_view
// @namespace      InYahooCom
// @description    bk_custom_view
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.js
// @include        http://in.yahoo.com/
// @include        http://indianexpress.com/news/*
// @include        http://www.indianexpress.com/news/*
// @include        https://docs.google.com/*
// ==/UserScript==
if(window.location.hostname == "in.yahoo.com") {
	$('.wrapper clearfix').remove();
	$('.advertise ').remove();
	$('#y-col2').remove();
}
if(window.location.hostname == "indianexpress.com" || window.location.hostname == "www.indianexpress.com") {
	var cur_location = window.location.toString();
	if (cur_location.match("/0$") == null) {
		window.location = cur_location + '/0' 
	}
	$('#express_special').remove();
	$('#google_new').remove();
	$('.picture_gal').remove();
}
if(window.location.hostname == "docs.google.com") {
	$('.GDS_pageButter').remove();
	$('#GDS_pageButter').remove();
}
