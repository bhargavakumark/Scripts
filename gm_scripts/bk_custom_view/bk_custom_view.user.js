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
