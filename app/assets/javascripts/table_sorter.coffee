###*
# Modified and more readable version of the answer by Paul S. to sort a table with ASC and DESC order
# with the <thead> and <tbody> structure easily.
# 
# https://stackoverflow.com/a/14268260/4241030
###

# See https://codepen.io/jmuheim/pen/eYJYRyG

class App.TableSorter
  constructor: (table) ->
    @table = table

    # Store context of this in the object
    _this = this
    th = @table.tHead
    i = undefined
    th and (th = th.rows[0]) and (th = th.cells)
    if th
      i = th.length
    else
      return
      # if no `<thead>` then do nothing

    # Loop through every <th> inside the header
    lastPressedButton = undefined
    while --i >= 0
      do (i) ->
        dir = 1
        # Append click listener to sort
        currentTh = th[i]
        button = document.createElement("button")
        button.innerHTML = currentTh.innerHTML
        currentTh.innerHTML = ""
        currentTh.appendChild(button)

        initialSort = th[i].getAttribute('data-sort-initial')
        button.setAttribute('aria-sort', initialSort || 'none')

        if initialSort
          lastPressedButton = button 
          dir = 0

        button.addEventListener 'click', ->
          if lastPressedButton
            lastPressedButton.setAttribute('aria-sort', 'none')

          dirtext = if dir == 0
                      'descending'
                    else
                      'ascending'

          button.setAttribute('aria-sort', dirtext)
          _this._sort @table, i, dir = 1 - dir
          lastPressedButton = button

  # See https://stackoverflow.com/questions/62981016/how-to-include-images-alternative-text-with-textcontent/62981051#62981051
  _getCellContent: (col) ->
    result = undefined

    if custom = col.getAttribute('data-sort')
      result = custom
    else
      if img = col.querySelector("img")
        result = img.alt
      else
        result = col.textContent

    result.trim()

  _sort: (table, col, reverse) ->
    # Store context of this in the object
    _this = this
    tb = @table.tBodies[0]
    tr = Array::slice.call(tb.rows, 0)
    i = undefined
    reverse = -(+reverse or -1)
    # Sort rows
    tr = tr.sort((a, b) ->
      # `-1 *` if want opposite order

      a = _this._getCellContent(a.cells[col])
      b = _this._getCellContent(b.cells[col])

      bothAreNumeric = !isNaN(a) and !isNaN(b)

      reverse * a.localeCompare(b, undefined, 'numeric': bothAreNumeric)
    )
    i = 0
    while i < tr.length
      # Append rows in new order
      tb.appendChild tr[i]
      ++i
