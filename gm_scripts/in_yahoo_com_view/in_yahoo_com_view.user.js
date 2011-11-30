// ==UserScript==
// @name           in_yahoo_com_view
// @namespace      InYahooCom
// @description    in_yahoo_com_view
// @include        http://in.yahoo.com/
// ==/UserScript==
var element = document.getElementsByClassName('wrapper clearfix');
if (element != null) {
	if (element.length != 0) {
		element[0].style.display = 'none'
	}
}
var element = document.getElementsByClassName('advertise');
if (element != null) {
	if (element.length != 0) {
		element[0].style.display = 'none'
	}
}
var element = document.getElementsByClassName('property icon-filter');
if (element != null) {
	if (element.length != 0) {
		element[0].style.display = 'none'
	}
}
