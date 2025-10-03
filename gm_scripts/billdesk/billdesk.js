
if (window.location.hostname == 'pgi.billdesk.com' || window.location.hostname == 'www.billdesk.com' || window.location.hostname == 'pay.billdesk.com') {
    console.log("billdesk match");
    if (window.location.pathname.endsWith("pgidsk/pgmerc/hdfccard/HDFC_card.jsp")) {
        console.log("inside hdfc ready");

        node = document.getElementById('CardNum');
        if (node != null) {
            node.autocomplete = "on";
            // node.value = "36088613111098";
            //node.onpaste = null;
            node.value = "6529260002114618";
        }
        node = document.getElementById('CardNumRe');
        if (node != null) {
            node.autocomplete = "on";
            //node.value = "36088613111098";
            node.value = "6529260002114618"
        }
        node = document.getElementById('additional_info2');
        if (node != null) {
            node.autocomplete = "on";
            node.value = "bhargavakumark@gmail.com";
        }
        node = document.getElementById('txn_amount');
        if (node != null) {
            node.autocomplete = "on";
            node.blur();
            node.focus();
        }
    }

}
