(($) ->

  $.fn.caret = (pos) ->
    `var range`
    `var range`
    `var range2`
    `var pos`
    `var range2`
    `var range1`
    target = @[0]
    isContentEditable = target.contentEditable == 'true'
    #get
    if arguments.length == 0
      #HTML5
      if window.getSelection
        #contenteditable
        if isContentEditable
          target.focus()
          range1 = window.getSelection().getRangeAt(0)
          range2 = range1.cloneRange()
          range2.selectNodeContents target
          range2.setEnd range1.endContainer, range1.endOffset
          return range2.toString().length
        #textarea
        return target.selectionStart
      #IE<9
      if document.selection
        target.focus()
        #contenteditable
        if isContentEditable
          range1 = document.selection.createRange()
          range2 = document.body.createTextRange()
          range2.moveToElementText target
          range2.setEndPoint 'EndToEnd', range1
          return range2.text.length
        #textarea
        pos = 0
        range = target.createTextRange()
        range2 = document.selection.createRange().duplicate()
        bookmark = range2.getBookmark()
        range.moveToBookmark bookmark
        while range.moveStart('character', -1) != 0
          pos++
        return pos
      # Addition for jsdom support
      if target.selectionStart
        return target.selectionStart
      #not supported
      return 0
    #set
    if pos == -1
      pos = @[if isContentEditable then 'text' else 'val']().length
    #HTML5
    if window.getSelection
      #contenteditable
      if isContentEditable
        target.focus()
        window.getSelection().collapse target.firstChild, pos
      else
        target.setSelectionRange pos, pos
    else if document.body.createTextRange
      if isContentEditable
        range = document.body.createTextRange()
        range.moveToElementText target
        range.moveStart 'character', pos
        range.collapse true
        range.select()
      else
        range = target.createTextRange()
        range.move 'character', pos
        range.select()
    if !isContentEditable
      target.focus()
    this

  return
) jQuery