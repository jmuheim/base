# Don't change order of the blocks (for turbolink to play nicely)!
#
# Add more scripts to the block between `require_self` and `require init`!
#
#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery.ui.all
#
#= require jquery-ui-bootstrap-bridge
#
#= require bootstrap
#= require bootstrap-formhelpers
#
#= require_self
#
# --- Add custom requires under here! ---
#= require cocoon
#= require example_script
# --- Add custom requires above here! ---
#
#= require init
#= require turbolinks

@App = {}
