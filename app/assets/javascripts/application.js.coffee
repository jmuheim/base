# Don't change order of the blocks (for turbolink to play nicely)!
#
# Add more scripts to the block between `require_self` and `require init`!
#
#= require jquery
#= require jquery.turbolinks
#= require jquery-ujs-standalone
#
#= require bootstrap-sass
#= require bootstrap-formhelpers
#
#= require_self
#
# --- Add custom requires under here! ---
#= require cocoon
#= require dashboards
#= require jquery-ui
#= require language_chooser
# --- Add custom requires above here! ---
#
#= require init
#= require turbolinks

@App = {}
