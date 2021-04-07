$(document).ready(function() {
  var tabs = $('#main_content .tabs')
  tabs.addClass('nav-tabs-custom');
  tabs.find('.tab-content .tab-pane:first-child').addClass('active');
  tabs.find('.nav-tabs li:first-child').addClass('active');
});
