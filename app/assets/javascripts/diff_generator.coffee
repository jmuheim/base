# This creates a diff (in the style of GitHub) from two text strings.
#
# - There needs to be a container with attribute `data-diff-before`
# - There needs to be a container with attribute `data-diff-after`
# - There needs to be a container with attribute `data-diff-result`; this one will hold the generated diff
#
# All these elements need to be in a container with attribute `data-diff`. For every diff, such a container is needed.

class App.DiffGenerator
  constructor: (el) ->
    @$el = $(el) # Always pass an element to the constructor and make it available as a jQuery selector!

    # Inspired by https://neil.fraser.name/software/diff_match_patch/svn/trunk/demos/demo_diff.html
    dmp = new diff_match_patch
    text1 = @$el.find('[data-diff-string="before"]').text()
    text2 = @$el.find('[data-diff-string="after"]').text()
    d = dmp.diff_main(text1, text2)
    dmp.diff_cleanupSemantic d
    ds = dmp.diff_prettyHtml(d)

    @$el.find('[data-diff-result]').html(ds)