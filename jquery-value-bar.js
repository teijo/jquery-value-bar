(function(){
    if (typeof window != 'undefined' && window !== null) {
    prelude.installPrelude(window);
  } else {
    require('prelude-ls').installPrelude(global);
  };
  (function($){
    var highlight, methods;
    highlight = function(bars, n, cls, state){
      each(function(it){
        return $(it).toggleClass(cls, false);
      }, bars);
      return each(function(it){
        return $(it).toggleClass(cls, state);
      }, take(n, bars));
    };
    methods = {
      init: function(options){
        return this.each(function(){
          var $this, hl, contentWidth, remainder, baseWidth, i, to$, width, el;
          $this = $(this);
          $this.addClass('valueBar');
          $this.data('bars', []);
          $this.data('args', options);
          $this.data('value', options.value);
          hl = function(value, cls, state){
            state == null && (state = true);
            return highlight($this.data('bars'), value, cls, state);
          };
          contentWidth = $this.width();
          remainder = contentWidth % options.max;
          baseWidth = (contentWidth - remainder) / options.max;
          for (i = 1, to$ = options.max; i <= to$; ++i) {
            width = baseWidth + (remainder-- > 0 ? 1 : 0);
            el = $('<div data-value="' + i + '" style="width: ' + width + 'px">').appendTo($this);
            el.hover(fn$, fn1$);
            el.click(fn2$);
            el.append($('<div>'));
            $this.data('bars').push(el);
          }
          hl(options.value, 'active');
          function fn$(){
            var value;
            value = $(this).data('value');
            hl(value, 'highlight', true);
            options.onmouseover(value);
          }
          function fn1$(){
            hl($(this).data('value'), 'highlight', false);
            options.onmouseout();
          }
          function fn2$(){
            var value;
            value = $(this).data('value');
            hl(value, 'active');
            $this.data('value', value);
            options.onchange(value);
          }
        });
      },
      value: function(args){
        if (args === void 8) {
          return this.data('value');
        } else {
          highlight(this.data('bars'), args, 'active');
          this.data('value', args);
          this.data('args').onchange(args);
          return args;
        }
      }
    };
    return $.fn.valueBar = function(method){
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      } else {
        return $.error('Method ' + method + ' does not exist on jQuery.valueBar');
      }
    };
  })(jQuery);
}).call(this);
