# This is an example file. Use it as reference when creating your own script classes.

class App.DiffGenerator
  constructor: (el) ->
    @$el = $(el) # Always pass an element to the constructor and make it available as a jQuery selector!

    dmp = new diff_match_patch
    text1 = @$el.find('[data-diff-string="1"]').text()
    text2 = @$el.find('[data-diff-string="2"]').text()
    d = dmp.diff_main(text1, text2)
    dmp.diff_cleanupSemantic d
    ds = dmp.diff_prettyHtml(d)

    @$el.find('[data-diff-result]').html(ds)