var __bind=function(i,t){return function(){return i.apply(t,arguments)}};define([],function(){var i;return i=function(){function i(i){var t,e,s,d;if(this.widget=i,this.prev=__bind(this.prev,this),this.next=__bind(this.next,this),this.cashImg=__bind(this.cashImg,this),this.loadImg=__bind(this.loadImg,this),0!==this.widget.length&&(this.itype="click",$("html").hasClass("touch")&&(this.itype="touchstart"),this.slides=this.widget.attr("data-slides").split(","),!(this.slides.length<2))){for(d=this.slides,e=0,s=d.length;s>e;e++)t=d[e],t=t.trim();this.dir=!0,this.index=0,this.current_slide=this.widget.find(".current.slide"),this.hidden_slide=this.widget.find(".slide:not(.current)"),this.widget.find(".slide-show-nav-prev").on(this.itype,this.prev),this.widget.find(".slide-show-nav-next").on(this.itype,this.next),this.loadImg()}}return i.prototype.loadImg=function(){return this.hidden_slide.removeClass("hidden-prev"),this.hidden_slide.removeClass("hidden-next"),this.hidden_slide.addClass(this.dir?"ready-next":"ready-prev"),$("<img>").attr("src",this.slides[this.index]).load(this.cashImg)},i.prototype.cashImg=function(i){var t;return $(i.currentTarget).remove(),this.hidden_slide.css("background-image","url("+this.slides[this.index]+")").addClass("current").removeClass("ready-next").removeClass("ready-prev"),this.current_slide.removeClass("current"),this.current_slide.addClass(this.dir?"hidden-next":"hidden-prev"),t=this.current_slide,this.current_slide=this.hidden_slide,this.hidden_slide=t},i.prototype.next=function(i){return i.preventDefault(),this.dir=!0,this.index++,this.index>=this.slides.length&&(this.index=0),this.loadImg()},i.prototype.prev=function(i){return i.preventDefault(),this.dir=!1,this.index--,this.index<0&&(this.index=this.slides.length-1),this.loadImg()},i}()});