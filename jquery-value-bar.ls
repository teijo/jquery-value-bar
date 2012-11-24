(($) ->
  highlight = (bars, n, cls, state) ->
    each (-> $(it).toggleClass(cls, false)), bars
    each (-> $(it).toggleClass(cls, state)), take n, bars

  methods =
    init: (options) ->
      this.each !->
        $this = $ this
        $this.addClass \valueBar
        $this.data \bars, []
        $this.data \args, options
        hl = (value, cls, state = true) -> highlight $this.data(\bars), value, cls, state

        for i from 1 to options.max
          el = $('<div data-value="'+i+'" style="width: '+(100/options.max)+'%">').appendTo($this)
          el.hover(
            (! ->
              value = $ this .data \value
              hl value, \highlight, true
              options.onmouseover value),
            (! ->
              hl ($ this .data \value), \highlight, false
              options.onmouseout!))
          el.click ! ->
            value = ($ this .data \value)
            hl value, \active
            options.onchange(value)
          el.append($ '<div>')
          ($this.data \bars).push el
        hl options.value, \active
    set: (args) ->
      highlight this.data(\bars), args, \active
      this.data \args .onchange args

  $.fn.valueBar = (method) ->
    if methods[method]
      return methods[method].apply this, Array.prototype.slice.call(arguments, 1)
    else if typeof method == 'object' or !method
      return methods.init.apply this, arguments
    else
      $.error('Method ' +  method + ' does not exist on jQuery.valueBar')
)(jQuery)
