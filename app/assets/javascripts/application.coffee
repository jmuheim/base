# Don't change order of the blocks (for turbolink to play nicely)!
#
# Add more scripts to the block between `require_self` and `require init`!
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#
#= require jquery-ui-bootstrap-bridge
#
#= require bootstrap
#= require cocoon
#= require diff_match_patch
#= require jasny-bootstrap
#= require jquery-caret2
#= require fancybox
#= require paste
#
#= require_self
#
# --- Add custom requires under here! ---
#= require example_script
#= require clipboard_to_nested_image_pastabilizer
#= require clipboard_to_textarea_pastabilizer
#= require depending_select_disabler
#= require diff_generator
#= require form_accessibilizer
#= require markdown_html_optimizer
#= require textarea_fullscreenizer
#= require visibility_on_focus_handler
# --- Add custom requires above here! ---
#
#= require init
#= require callbacks

@App = {}
