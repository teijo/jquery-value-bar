let $ = jQuery
  highlight = (bars, n, cls, state) ->
    each (-> $(it).toggleClass(cls, false)), bars
    each (-> $(it).toggleClass(cls, state)), take n, bars

  methods =
    init: (options) ->
      @each !->
        $this = $ @
          .addClass \valueBar
          .data \bars, []
          .data \args, options
          .data \value, options.value
        hl = (value, cls, state = true) -> highlight $this.data(\bars), value, cls, state
        contentWidth = $this.width()
        remainder = contentWidth % options.max
        baseWidth = (contentWidth - remainder) / options.max

        for i from 1 to options.max
          # Distribute remainder to first blocks
          width = baseWidth + (if remainder-- > 0 then 1 else 0)

          el = $ "<div data-value='#i' style='width: #{width}px'>"
            .appendTo($this)
            .append($ \<div>)
            .hover(
              (! ->
                value = $ @ .data \value
                hl value, \highlight, true
                options.onmouseover value),
              (! ->
                hl ($ @ .data \value), \highlight, false
                options.onmouseout!))
            .click ! ->
              value = ($ @ .data \value)
              hl value, \active
              $this.data \value, value
              options.onchange(value)

          ($this.data \bars).push el

        hl options.value, \active

    value: (args) ->
      if args == undefined
        @data \value
      else
        highlight @data(\bars), args, \active
        @data \value, args
        @data \args .onchange args
        args

  defaults =
    value: 0
    max: 5
    onmouseover: !->
    onmouseout: !->
    onchange: !->

  $.fn.valueBar = (method) ->
    if methods[method]
      return methods[method].apply @, Array.prototype.slice.call(arguments, 1)
    else if typeof method is \object or !method
      if arguments.length > 1
        $.error "jQuery.valueBar takes only a single object"
      return methods.init.apply @, [defaults with arguments[0]]
    else
      $.error "Method #method does not exist on jQuery.valueBar"
