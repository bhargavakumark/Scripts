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
// @include        https://ngsfdellpe-07.vxindia.veritas.com*
// @include        https://nasgw1950-01-c.vxindia.veritas.com/*
// @include        https://nasgw1950-02-c.vxindia.veritas.com/*
// @include        https://ngsfdellpe-04-c.vxindia.veritas.com/*
// @include        https://ngsfdellpe-07-c.vxindia.veritas.com/*
// @include        http://www.indianrail.gov.in/*
// @include        https://care.ideacellular.com/*
// @include        http://www.divxsubtitles.net/*
// ==/UserScript==
if(window.location.hostname == "in.yahoo.com") {
	$('.wrapper clearfix').remove();	//Element by class
	$('.advertise ').remove();		
	$('#y-col2').remove();			//Element by id
	$('#default-p_27859422').remove();
	$('#y-masthead').remove();
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
	if(window.location.pathname == "/Etrack/bottom.php") {
		$(document).ready(function(){
			document.getElementsByName('rememberme')[0].checked = 'checked';
			if( document.getElementsByName('password')[0].value != "") {
				document.getElementsByName('submit2')[0].click();
			}
		});
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
	if(window.location.pathname == "/cgi-bin/bv60.dll/irctc/booking/planner.do") {
		if (window.location.search.match("ReturnBank*") || window.location.search.match("screen=from*")) {
			document.getElementsByName('stationFrom')[0].value = "pune";
			document.getElementsByName('stationTo')[0].value = "hyb";
			document.getElementsByName('quota')[0].value = "GN";
			document.getElementsByName('month')[0].value = "1";
			document.getElementsByName('day')[0].value = "9";
			document.getElementsByName('year')[0].value = "2012";
			document.getElementById('JDatee')[0].value = "9/01/2012";
		} else {
			$(document).ready(function(){
				/*
				node = document.getElementsByName('BookTicketForm')[0];
				alert(node.BV_SessionID.value);
				*/
				document.getElementsByName('dayfravil')[0].value = "09";
				document.getElementsByName('monthfravil')[0].value = "1";
				document.getElementsByName('yearfravil')[0].value = "2012";
				document.getElementsByName('day')[0].value = "09";
				document.getElementsByName('month')[0].value = "1";
				document.getElementsByName('year')[0].value = "2012";
				document.getElementsByName('classCode')[0].value = "SL";
				document.getElementsByName('clscode')[0].value = "SL";
				document.getElementsByName('backRoute')[0].value = "true";
				document.getElementsByName('boardPoint')[0].value = "PUNE";
				document.getElementsByName('changetext')[0].value = "0";
				document.getElementsByName('arrival')[0].value = "05:55";
				document.getElementsByName('departure')[0].value = "16:35";
				document.getElementsByName('destStation')[0].value = "HYB";
				document.getElementsByName('stationFrom')[0].value = "PUNE";
				document.getElementsByName('runsOn')[0].value = "M T W TH F S SU";
				document.getElementsByName('stationTo')[0].value = "HYB";
//				document.getElementsByName('timedate')[0].value = "17";
				document.getElementsByName('trainName')[0].value = "HYDERABAD EXP";
				document.getElementsByName('trainNo')[0].value = "17031";
				document.getElementsByName('trainType')[0].value = "B";
				document.getElementsByName('counterAvail')[0].value = "0";
//				document.getElementsByName('screen')[0].value = "trainsFromTo";
//				document.getElementsByName('screen')[0].value = "passenger";
				document.getElementsByName('screen')[0].value = "bookTicket";
//				document.getElementsByName('pressedGo')[0].value = "pressedGo";
				document.getElementsByName('submitClicks')[0].value = parseInt(document.getElementsByName('submitClicks')[0].value) + 1;
//				document.getElementsByName('BookTicketForm')[0].autocomplete = "on";
				document.getElementsByName('clscode')[0].value = "SL";
				document.getElementsByName('browser')[0].value = "::: You're using Mozilla Fire Fox  3.x or above ::: and Operating System is  :   Linux";
				var node_list = document.getElementsByName("classcode");
				for (var i = 0; i < node_list.length; i++) {
					if (node_list[i].value == "SL" ) {
						node_list[i].checked = "checked";
					}
				}
				document.getElementsByName('classcode')[0].value = "SL";
				document.getElementsByName('BookTicketForm')[0].submit();
			});
		}
	}
	if(window.location.pathname == "/cgi-bin/bv60.dll/irctc/services/home.do" || window.location.pathname == "/") {
		$(document).ready(function(){
			var node_list = document.getElementsByName('userName');
			node_list[0].autocomplete = "on";
			node_list[0].focus();
			node_list[0].value = "bkancher";
			node_list[0].blur();
			var node_list2 = document.getElementsByName('password');
			node_list2[0].autocomplete = "on";
			node_list2[0].focus();
			node_list2[0].blur();
			if(document.getElementsByName('password')[0].value != "") {
				document.getElementById('button').click();
			}
		});
	}
	if(window.location.pathname == "/cgi-bin/bv60.dll/irctc/booking/bookticket.do") {
		if (window.location.search.match("click=true*")) {
			document.getElementsByName('passengers[0].passengerName')[0].value = "bhargava kumar";
			document.getElementsByName('passengers[0].passengerAge')[0].value = "28";
			document.getElementsByName('passengers[0].passengerSex')[0].value = "m";
			document.getElementsByName('passengers[0].berthPreffer')[0].value = "Upper";
			document.getElementsByName('upgradeCh')[0].checked = "checked";
			if (document.getElementsByName('quota')[0].value == "CK") { 
				document.getElementsByName('passengers[0].idCardType')[0].value = "PANC";
				document.getElementsByName('passengers[0].idCardNo')[0].value = "asepk3181c";
			}
		}
		if (window.location.search.match("BV_SessionID")) {
			var node = document.getElementsByClassName('Paymentbutton');
			if (node.length == 1) {
//				document.getElementsByClassName('Paymentbutton')[0].click();
			}
		}
	}
}
		
if(window.location.hostname == "hrprod.ges.symantec.com") {
	if (window.location.pathname == "/psp/hrp/" && window.location.search.match("cmd=login")) {
		$(document).ready(function(){
	//		document.getElementById('userid').value = "bhargava_kancharla";
			$('#userid').val("bhargava_kancharla").change();
			$('#pwd').focus();
			document.getElementById('pwd').focus();
		});
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

if(window.location.hostname == "ngsfdellpe-07.vxindia.veritas.com") {
	if (window.location.pathname == '/ui/') {
		$(document).ready(function() {
			var inputs = document.getElementsByTagName('input');
			for(var i = 0; i < inputs.length; i++) {
				if(inputs[i].getAttribute('type') == 'text') {
					alert(i);
					inputs[i].setAttribute('value') == 'root';
				}
			}
		});
//		document.getElementsByType('text')[0].value = "root";
		$('input[type="text"]').val("root").change();
	}
}

if(window.location.hostname == "nasgw1950-01-c.vxindia.veritas.com" ||
   window.location.hostname == "ngsfdellpe-04-c.vxindia.veritas.com" ||
   window.location.hostname == "ngsfdellpe-07-c.vxindia.veritas.com" ||
   window.location.hostname == "nasgw1950-02-c.vxindia.veritas.com") {
	if (window.location.pathname == '/cgi-bin/webcgi/login') {
		document.getElementsByName('user')[0].value = "root";
		document.getElementsByName('password')[0].value = "calvin";
		window.location = "javascript:frmSubmit()";
	}
}

function dummy() {
	alert("here");
}

if(window.location.hostname == "www.indianrail.gov.in") {
	if (window.location.pathname == "/pnr_Enq.html") {
		var node_list = document.getElementsByName('lccp_pnrno2');
		node_list[0].setAttribute('onblur', null);
	}
}

if(window.location.hostname == "care.ideacellular.com") {
	if (window.location.pathname == "/wps/portal/MyIdeaLogin") {
		$(document).ready(function(){
			var node_list = document.getElementsByName('userID');
			node_list[0].autocomplete = "on";
			node_list[0].focus();
			node_list[0].value = "9850889060";
			node_list[0].blur();
			var node_list = document.getElementsByName('password');
			node_list[0].autocomplete = "on";
			$('.go-button').click();
		});
	}
}

if(window.location.hostname == "www.divxsubtitles.net") {
	$(document).ready(function() {
		document.getElementsByName('remember')[0].checked = "checked";
		if( document.getElementsByName('userPassword')[0].value != "") {
			document.getElementsByClassName('formButton')[0].click();
		}
	});
}

