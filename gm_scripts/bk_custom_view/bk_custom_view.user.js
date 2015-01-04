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
// @include        https://mail.google.com/*
// @include        http://www.indianrail.gov.in/*
// @include        http://www.divxsubtitles.net/*
// @include        https://www.givingstation.com/*
// @include        http://www.rediff.com/*
// @include        http://download.novell.com/*
// @include        http://imsports.rediff.com/*
// @include        http://timesofindia.indiatimes.com/*
// @include        http://www.firstpost.com/*
// @include        http://live2.cricbuzz.com/*
// @include        http://live.cricbuzz.com/*
// @include        http://in.news.yahoo.com/*
// @include        http://www.fark.com/*
// @include        https://www.billdesk.com/APCPDCL/apcpdcl.htm*
// @include        http://www.billdesk.com/APCPDCL/apcpdcl.htm*
// @include        https://www.billdesk.com/pgidsk/pgijsp/apcpdcl*
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

if (window.location.hostname == "www.axisbank.co.in") {
	document.getElementById('CorporateSignonPassword').autocomplete = 'on';
}

