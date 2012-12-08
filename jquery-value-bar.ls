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
        $this.data \value, options.value
        hl = (value, cls, state = true) -> highlight $this.data(\bars), value, cls, state
        contentWidth = $this.width()
        remainder = contentWidth % options.max
        baseWidth = (contentWidth - remainder) / options.max

        for i from 1 to options.max
          # Distribute remainder to first blocks
          width = baseWidth + (if remainder-- > 0 then 1 else 0)

          el = $('<div data-value="'+i+'" style="width: '+width+'px">').appendTo($this)

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
            $this.data \value, value
            options.onchange(value)

          ($this.data \bars).push el.append($ '<div>')

        hl options.value, \active

    value: (args) ->
      if args == undefined
        this.data \value
      else
        highlight this.data(\bars), args, \active
        this.data \value, args
        this.data \args .onchange args
        args

  $.fn.valueBar = (method) ->
    if methods[method]
      return methods[method].apply this, Array.prototype.slice.call(arguments, 1)
    else if typeof method == 'object' or !method
      return methods.init.apply this, arguments
    else
      $.error('Method ' +  method + ' does not exist on jQuery.valueBar')
)(jQuery)
