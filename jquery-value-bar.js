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
          var $this, hl, i, to$, el;
          $this = $(this);
          $this.addClass('valueBar');
          $this.data('bars', []);
          $this.data('args', options);
          hl = function(value, cls, state){
            state == null && (state = true);
            return highlight($this.data('bars'), value, cls, state);
          };
          for (i = 1, to$ = options.max; i <= to$; ++i) {
            el = $('<div data-value="' + i + '" style="width: ' + 100 / options.max + '%">').appendTo($this);
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
            options.onchange(value);
          }
        });
      },
      set: function(args){
        highlight(this.data('bars'), args, 'active');
        return this.data('args').onchange(args);
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
