// ==UserScript==
// @name           bk_custom_view
// @namespace      InYahooCom
// @description    bk_custom_view
// @grant          none
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.js
// @include        http://in.yahoo.com/*
// @include        http://indianexpress.com/news/*
// @include        http://www.expressindia.com/*
// @include        http://www.indianexpress.com/news/*
// @include        https://www.irctc.co.in/*
// @include        https://www.hrworkwaysindia.com/*
// @include        https://hrworkwaysindia.com/*
// @include        https://login.salesforce.com*
// @include        https://mail.google.com/*
// @include        http://www.indianrail.gov.in/*
// @include        https://care.ideacellular.com/*
// @include        http://www.divxsubtitles.net/*
// @include        https://www.givingstation.com/*
// @include        https://ebpp.airtelworld.com/*
// @include        http://www.rediff.com/*
// @include        http://download.novell.com/*
// @include        http://imsports.rediff.com/*
// @include        http://timesofindia.indiatimes.com/*
// @include        http://www.firstpost.com/*
// @include        http://live2.cricbuzz.com/*
// @include        http://live.cricbuzz.com/*
// @include        http://in.news.yahoo.com/*
// @include        http://www.fark.com/*
// @include        http://portal.beamtele.com/*
// @include        http://portal.beamtele.com/#
// @include        http://bug.actifio.com/*
// @include        https://bug.actifio.com/*
// @include        http://shib.actifio.com/*
// @include        https://shib.actifio.com/*
// @include        https://www.billdesk.com/APCPDCL/apcpdcl.htm*
// @include        http://www.billdesk.com/APCPDCL/apcpdcl.htm*
// @include        https://www.billdesk.com/pgidsk/pgijsp/apcpdcl*
// @include        https://portal1.bsnl.in/aspxfiles/*
// @include        https://www.axisbank.co.in/BankAway/*
// ==/UserScript==

function bk_setHint(node, hintstr)
{
	var hint = document.createElement('b');
	node.parentNode.appendChild(hint);
	hint.textContent = hintstr;
}

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

if(window.location.hostname == "www.expressindia.com") {
	$('.story_add').remove();
}

if(window.location.hostname == "www.irctc.co.in") {
	if(window.location.pathname == "/cgi-bin/bv60.dll/irctc/booking/planner.do") {
		if (window.location.search.match("ReturnBank*") || window.location.search.match("screen=from*")) {
			document.getElementsByName('stationFrom')[0].value = "pune";
			document.getElementsByName('stationTo')[0].value = "hyb";
			document.getElementsByName('quota')[0].value = "CK";
//			document.getElementsByName('month')[0].value = "3";
//			document.getElementsByName('day')[0].value = "24";
//			document.getElementsByName('year')[0].value = "2012";
//			document.getElementById('JDatee')[0].value = "24/03/2012";
		} else {
			$(document).ready(function(){
				/*
				node = document.getElementsByName('BookTicketForm')[0];
				alert(node.BV_SessionID.value);
				*/
//				document.getElementsByName('dayfravil')[0].value = "03";
//				document.getElementsByName('monthfravil')[0].value = "2";
//				document.getElementsByName('yearfravil')[0].value = "2012";
//				document.getElementsByName('day')[0].value = "03";
//				document.getElementsByName('month')[0].value = "2";
//				document.getElementsByName('year')[0].value = "2012";
//				document.getElementsByName('classCode')[0].value = "SL";
//				document.getElementsByName('clscode')[0].value = "SL";
//				document.getElementsByName('backRoute')[0].value = "true";
//				document.getElementsByName('boardPoint')[0].value = "PUNE";
//				document.getElementsByName('changetext')[0].value = "0";
//				document.getElementsByName('arrival')[0].value = "05:55";
//				document.getElementsByName('departure')[0].value = "16:35";
//				document.getElementsByName('destStation')[0].value = "HYB";
//				document.getElementsByName('stationFrom')[0].value = "HYB";
//				document.getElementsByName('runsOn')[0].value = "M T W TH F S SU";
//				document.getElementsByName('stationTo')[0].value = "PUNE";
////				document.getElementsByName('timedate')[0].value = "17";
//				document.getElementsByName('trainName')[0].value = "MUMBAI EXP";
//				document.getElementsByName('trainNo')[0].value = "17031";
//				document.getElementsByName('trainType')[0].value = "B";
//				document.getElementsByName('counterAvail')[0].value = "0";
////				document.getElementsByName('screen')[0].value = "trainsFromTo";
////				document.getElementsByName('screen')[0].value = "passenger";
//				document.getElementsByName('screen')[0].value = "bookTicket";
////				document.getElementsByName('pressedGo')[0].value = "pressedGo";
//				document.getElementsByName('submitClicks')[0].value = parseInt(document.getElementsByName('submitClicks')[0].value) + 1;
////				document.getElementsByName('BookTicketForm')[0].autocomplete = "on";
//				document.getElementsByName('clscode')[0].value = "SL";
//				document.getElementsByName('browser')[0].value = "::: You're using Mozilla Fire Fox  3.x or above ::: and Operating System is  :   Linux";
//				var node_list = document.getElementsByName("classcode");
//				for (var i = 0; i < node_list.length; i++) {
//					if (node_list[i].value == "SL" ) {
//						node_list[i].checked = "checked";
//					}
//				}
//				document.getElementsByName('classcode')[0].value = "SL";
//				document.getElementsByName('BookTicketForm')[0].submit();
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
			} else {
				bk_setHint(document.getElementsByName('password')[0], "char,number");
			}
		});
	}
	if(window.location.pathname == "/cgi-bin/bv60.dll/irctc/booking/bookticket.do") {
		if (window.location.search.match("click=true*")) {
			document.getElementsByName('passengers[0].passengerName')[0].value = "Bhargava Kumar";
			document.getElementsByName('passengers[0].passengerAge')[0].value = "29";
			document.getElementsByName('passengers[0].passengerSex')[0].value = "m";
			document.getElementsByName('passengers[0].berthPreffer')[0].value = "Upper";
//			document.getElementsByName('passengers[0].passengerName')[0].value = "Bhargava kumar";
//			document.getElementsByName('passengers[0].passengerAge')[0].value = "28";
//			document.getElementsByName('passengers[0].passengerSex')[0].value = "m";
//			document.getElementsByName('passengers[0].berthPreffer')[0].value = "Upper";
//			document.getElementsByName('passengers[1].passengerName')[0].value = "Suresh Kumar";
//			document.getElementsByName('passengers[1].passengerAge')[0].value = "28";
//			document.getElementsByName('passengers[1].passengerSex')[0].value = "m";
//			document.getElementsByName('passengers[1].berthPreffer')[0].value = "Upper";
//			document.getElementsByName('passengers[2].passengerName')[0].value = "Ashok Kumar";
//			document.getElementsByName('passengers[2].passengerAge')[0].value = "30";
//			document.getElementsByName('passengers[2].passengerSex')[0].value = "m";
//			document.getElementsByName('passengers[2].berthPreffer')[0].value = "Middle";
//			document.getElementsByName('passengers[3].passengerName')[0].value = "Sudhakar";
//			document.getElementsByName('passengers[3].passengerAge')[0].value = "30";
//			document.getElementsByName('passengers[3].passengerSex')[0].value = "m";
//			document.getElementsByName('passengers[3].berthPreffer')[0].value = "Lower";
			document.getElementsByName('upgradeCh')[0].checked = "checked";
			if (document.getElementsByName('quota')[0].value == "CK") { 
				document.getElementsByName('passengers[0].idCardType')[0].value = "PANC";
				document.getElementsByName('passengers[0].idCardNo')[0].value = "asepk3181c";
//				document.getElementsByName('passengers[0].idCardType')[0].value = "PANC";
//				document.getElementsByName('passengers[0].idCardNo')[0].value = "airpg1620p";
//				document.getElementsByName('passengers[1].idCardType')[0].value = "PANC";
//				document.getElementsByName('passengers[1].idCardNo')[0].value = "avqpk7033a";
//				document.getElementsByName('passengers[2].idCardType')[0].value = "PANC";
//				document.getElementsByName('passengers[2].idCardNo')[0].value = "aqwpm4800e";
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

if(window.location.hostname == "mail.google.com") {
	$(document).ready(function(){
		$('.mq').remove();
	});
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
	if (window.location.pathname == "/index.php") {
		if (window.location.search.match("c=login")) {
			document.getElementsByName('remember')[0].checked = "checked";
			if( document.getElementsByName('userPassword')[0].value != "") {
				document.getElementsByClassName('formButton')[0].click();
			}
		}
		if (window.location.search == "") {
			window.location = "page_subtitles.php";
		}
	}
});
}

if (window.location.hostname == "ebpp.airtelworld.com") {
	if (window.location.pathname == "/dthcares/wps/myportal" || window.location.pathname == "/cares/wps/myportal") {
		$(document).ready(function(){
			if (document.getElementsByName('username')[0].value != "") {
				document.getElementsByName('username')[0].value = "bhargavakumark";
				document.getElementsByName('username')[0].focus();
				document.getElementsByName('username')[0].blur();
			}
			bk_setHint(document.getElementsByName('password')[0],'"9');
		});
	}
}

if (window.location.hostname == "www.rediff.com" || window.location.hostname == "imsports.rediff.com") {
	if (window.location.pathname.match("slide-show*") && window.location.search == "") {
		var cur_location = window.location.toString();
		window.location = cur_location + '?print=true' 
	}
	if (window.location.pathname.match("slide-show*") && window.location.search == "?print=true") {
		$(document).ready(function() {
			$('#zarabol_widget').remove();	//Element by id
		});
	}
	if (window.location.search != "") {	
		$(document).ready(function(){
			$('.floatL').remove();
			$('.toptabsdiv').remove();
			$('.toprightlinks').remove();
			$('.relative').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#socialIcon').remove();
			$('#boardiframe').remove();
			$('#rightcontainer').remove();
			var node = document.getElementById('leftcontainer');
			if (node) 
				node.style.removeProperty("width");
			$('.footer').remove();
			$('#footerLinks').remove();
			$('.tagsdiv').remove();
		});
	}
}

if (window.location.hostname == "download.novell.com") {
	$(document).ready(function(){
		$('#ftr').remove();
	});
}

if (window.location.hostname == "timesofindia.indiatimes.com") {
	$(document).ready(function(){
		$('#slidebox').remove();
		$('#fcbk').remove();
		$('.prvnxtbg').remove();
		$('.maintable13').remove();
		$('#populatecomment').remove();
		$('#relmaindiv').remove();
		$('#moreinsideslider').remove();
		$('.redbdr').remove();
		$('.clrbth').remove();
		$('.clrb').remove();
		$('.otgns').remove();
		$('.bcclftr').remove();
		$('#fbrecommend').remove();
		$('.tabsintbgshow1').remove();
	});
}

if (window.location.hostname == "www.firstpost.com") {
	$(document).ready(function(){
		$('.inner_header').remove();
		$('.mfwlist').remove();
		$('.mfw_list').remove();
	});
}

if (window.location.hostname == "live2.cricbuzz.com" || window.location.hostname == "live.cricbuzz.com") {
	$(document).ready(function(){
		$('#footer-main-container').remove();
		$('#cbz_chat_container').remove();
		$('#header').remove();
	});
}

if (window.location.hostname == "in.news.yahoo.com") {
//	$(document).ready(function(){
		$('.yog-col yog-8u yog-col-last yom-secondary').remove();	//Element by class
		$('.yog-wrap yog-full').remove();	//Element by class
//	});
}

if (window.location.hostname == "www.fark.com") {
	$('#commentsArea').remove();
}

if (window.location.hostname == "portal.beamtele.com") {
	document.getElementById('url_username').value = 'bhargavakumark@yahoo.com';
	document.getElementById('url_userpassword').value = 'bhargava';
	document.getElementById('url_remember').checked = 'checked';
	process_login();
}

if (window.location.hostname == "bug.actifio.com") {
	document.getElementById('Bugzilla_restrictlogin').checked = '';
	$(document).ready(function(){
		if( document.getElementById('Bugzilla_password').value != "") {
			document.getElementById('log_in').click();
		}
	});
	$(document).ready(function(){
		var node = document.getElementById('j_username');
		if (node != null) {
			var node2 = document.getElementById('j_password');
			if (node.value != "" && node2.value != "") {
				$('.form-element form-button').click();	//Element by class
			}
		}
	});
}

if (window.location.hostname == "shib.actifio.com") {
	$(document).ready(function(){
		var node = document.getElementById('j_username');
		if (node != null) {
			var node2 = document.getElementById('j_password');
			if (node.value != "" && node2.value != "") {
				alert('submitting');
				$('.form-element form-button').click();	//Element by class
			}
		}
	});
}

if (window.location.hostname == "www.billdesk.com") {
	if (window.location.pathname == "/APCPDCL/apcpdcl.htm") {
		$('.rtd').autocomplete = 'on';
		document.getElementsByName('circle')[0].value = 'HYD';
		// call onchange method
		showERO(document.form1.circle.options[document.form1.circle.selectedIndex].value); 
		document.getElementsByName('ero')[0].value = '4';
		document.getElementsByName('payType')[0].checked = true;
	}
	if (window.location.pathname == "/pgidsk/pgijsp/apcpdcl_paydetails_current.jsp") {
		var node_list = document.getElementsByName('paymode');
		for (var i = 0; i < node_list.length; i++) {
			if (node_list[i].value == "NETB" ) {
				node_list[i].checked = true;
				paymodeDisplay();
			}
		}
		var node_list = document.getElementsByName('txtBankID1');
		for (var i = 0; i < node_list.length; i++) {
			if (node_list[i].value == "IDB" ) {
				node_list[i].checked = true;
			}
		}
	}
}

if (window.location.hostname == "portal1.bsnl.in") {
	if (window.location.pathname == "/aspxfiles/instapay.aspx") {
		document.getElementById('txtPhoneNumber').value = "040-27616353";
		document.getElementById('txtUniqueId').value = "9000191186";
		document.getElementById('txtMobile').value = "9989874545";
		document.getElementById('txtEmailAddress').value = "bhargavakumark@gmail.com";
	}
}

if (window.location.hostname == "www.axisbank.co.in") {
	document.getElementById('CorporateSignonPassword').autocomplete = 'on';
}

