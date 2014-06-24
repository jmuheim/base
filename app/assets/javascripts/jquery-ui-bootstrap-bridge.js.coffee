# Both jQuery UI and Bootstrap use tooltip for the name of the plugin.
# We use $.widget.bridge to create a different name for the jQuery UI
# version and allow the Bootstrap plugin to stay named tooltip.
#
# The same applies for the button plugin.
#
# See http://stackoverflow.com/questions/13731400/jqueryui-tooltips-are-competing-with-twitter-bootstrap

$.widget.bridge 'uibutton', $.ui.button
$.widget.bridge 'uitooltip', $.ui.tooltip
