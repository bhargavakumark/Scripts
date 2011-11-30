// ==UserScript==
// @name           EtrackCreateIncident
// @namespace      EtrackCreateIncident
// @description    EtrackCreateIncident
// @include        https://engtools.veritas.com/Etrack/create_incident.php
// ==/UserScript==
var element = document.getElementsByName('user_defined_list2')
element[0].value = ''
var element = document.getElementsByName('assigned_to')
element[0].value = 'bkancher'
var element = document.getElementsByName('target_version')
element[0].value = '6.0'
var element = document.getElementsByName('description')
element[0].value = ''
