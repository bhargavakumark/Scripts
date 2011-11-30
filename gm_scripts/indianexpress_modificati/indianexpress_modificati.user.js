// ==UserScript==
// @name           IndianExpress modifications
// @namespace      IndianExpress
// @description    IndianExpress custom mods
// @include        http://indianexpress.com/news/*
// @include        http://www.indianexpress.com/news/*
// ==/UserScript==
var cur_location = window.location.toString();
if (cur_location.match("/0$") == null) {
	window.location = cur_location + '/0' 
}
var element = document.getElementById('express_special');
if (element != null) {
	element.style.display = 'none'
	element.style.visibility = 'hidden'
}
var element = document.getElementById('google_new');
if (element != null) {
	element.style.display = 'none'
	element.style.visibility = 'hidden'
}
var element = document.getElementsByClassName('picture_gal');
if (element != null) {
	if (element.length != 0) {
		element[0].style.display = 'none'
	}
}
