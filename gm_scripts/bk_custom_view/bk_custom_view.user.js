// ==UserScript==
// @name           bk_custom_view
// @namespace      InYahooCom
// @description    bk_custom_view
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.js
// @include        http://in.yahoo.com/
// @include        http://indianexpress.com/news/*
// @include        http://www.indianexpress.com/news/*
// @include        https://docs.google.com/*
// @include        https://engtools.veritas.com/*
// @include        https://plus.google.com*
// @include        http://www.imdb.com/*
// @include        https://www.irctc.co.in/*
// @include        https://hrprod.ges.symantec.com/*
// @include        https://www.hrworkwaysindia.com/*
// @include        https://login.salesforce.com*
// @include        https://mail.google.com/*
// ==/UserScript==
if(window.location.hostname == "in.yahoo.com") {
	$('.wrapper clearfix').remove();	//Element by class
	$('.advertise ').remove();		
	$('#y-col2').remove();			//Element by id
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
	$('#GDS_pageButter').remove();
}
if(window.location.hostname == "engtools.veritas.com") {
	//document.getElementsByName('ET_state')[0].onchange = undefined;
	//$('select[name="ET_state"]').removeAttr("onchange").bind("change", function(){ foo_2(); });
	//$('select[name*="ET_state"]').hide();
	if(window.location.pathname == "/Etrack/create_incident.php") {
		document.getElementsByName('ET_description')[0].value = "";
		document.getElementsByName('ET_user_defined_list2')[0].value = '';
		document.getElementsByName('ET_assigned_to')[0].value = 'bkancher';
		document.getElementsByName('ET_target_version')[0].value = '6.0';
		document.getElementsByName('ET_build')[0].value = 'NA';
	}
	if(window.location.pathname == "/Etrack/modify_incident.php") {
		document.getElementsByName('propogate_comment')[0].checked = 'checked';
	}
}
if(window.location.hostname == "plus.google.com") {
	$('.a-j c-i-j-ua tg3b4c qQWXrb g2Lc3b dfrbjb').remove();
}
if(window.location.hostname == "www.imdb.com") {
	$('.aux-content-widget-2').remove();
	$('.bottom-rhs').remove();
	$('#maindetails_sidebar_top').remove();
	$('#maindetails_sidebar_bottom').remove();
}
if(window.location.hostname == "www.irctc.co.in") {
	if(window.location.pathname == "/cgi-bin/bv60.dll/irctc/booking/planner.do" && window.location.search.match("ReturnBank*")) {
		document.getElementsByName('stationFrom')[0].value = "pune";
		document.getElementsByName('stationTo')[0].value = "hyb";
		document.getElementsByName('Day')[0].value = "09";
		document.getElementsByName('Month')[0].value = "1";
		document.getElementsByName('Year')[0].value = "2012";
		document.getElementsByName('quota')[0].value = "GN";
	}
}
		
if(window.location.hostname == "hrprod.ges.symantec.com") {
	if (window.location.pathname == "/psp/hrp/" && window.location.search.match("cmd=login")) {
		$('#userid').val("bhargava_kancharla").change();
	}
}

if(window.location.hostname == "www.hrworkwaysindia.com") {
	if (window.location.pathname == "/index.jsp") {
		$('#p1').val("0085612576").change();
	}
}

if(window.location.hostname == "login.salesforce.com") {
	document.getElementById('username').value = 'bhargava_kancharla@symantec.com';
	document.getElementById('rememberUn').checked = 'checked';
}

if(window.location.hostname == "mail.google.com") {
	$(document).ready(function(){
		$('.mq').remove();
	});
}

