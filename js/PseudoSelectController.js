var __bind=function(t,i){return function(){return t.apply(i,arguments)}};define([],function(){var t;return t=function(){function t(t){this.widget=t,this.selectOption=__bind(this.selectOption,this),this.show=__bind(this.show,this),0!==this.widget.length&&(this.itype="click",$("html").hasClass("touch")&&(this.itype="touchstart"),this.current_label=this.widget.find(".pseudo-select-current"),this.input=this.widget.find(".pseudo-select-input"),this.list=this.widget.find(".pseudo-select-list"),this.options=this.list.find("li"),this.list.hide(),this.current_label.on(this.itype,this.show),this.options.on(this.itype,this.selectOption))}return t.prototype.show=function(){return this.list.toggle()},t.prototype.selectOption=function(t){var i,s;return s=$(t.currentTarget),i=s.attr("data-id"),this.input.val(i),this.current_label.text(s.text()),this.list.hide()},t}()});