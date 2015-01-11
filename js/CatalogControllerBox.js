var __bind=function(t,i){return function(){return t.apply(i,arguments)}};define(["masonry/dist/masonry.pkgd.min"],function(t){var i;return i=function(){function i(){this.switchState=__bind(this.switchState,this),this.showDetails=__bind(this.showDetails,this),this.buyItem=__bind(this.buyItem,this),this.resized=__bind(this.resized,this),this.checkIfVisible=__bind(this.checkIfVisible,this),this.scrollToTheBox=__bind(this.scrollToTheBox,this),this.widget=$(".main>section.catalog.box"),0!==this.widget.length&&(this.itype="click",$("html").hasClass("touch")&&(this.itype="touchstart"),this.widget.find(".item[data-hash='"+document.location.hash.substr(1)+"']").addClass("full-view"),this.items=$("#catalog-items"),this.msnry=null,$(window).width()>=750&&(this.items.toggleClass("masonry"),this.items.toggleClass("not-masonry"),this.msnry=new t("#catalog-items",{columnWidth:300,gutter:50,itemSelector:".item",isFitWidth:!1}),this.msnry.bindResize()),$(window).resize(this.resized),this.animatedCookies=0,this.card=$("body>header>nav>.card b"),$(document).on(this.itype,".catalog .item img, .catalog .item .wrapper",this.showDetails),$(document).on(this.itype,".catalog .item .details",this.switchState),$(document).on(this.itype,".catalog .item .buy",this.buyItem),this.totop=$(".scroll-to-the-box"),this.totop.length>0&&(this.totop.on(this.itype,this.scrollToTheBox),this.box=$("#box"),$(window).on("scroll",this.checkIfVisible),this.footer=$("body>.main>footer")))}return i.prototype.scrollToTheBox=function(t){return t.preventDefault(),$("html, body").animate({scrollTop:$("#box").offset().top},1500)},i.prototype.checkIfVisible=function(){var t,i,s,e,o;return i=$(window).scrollTop(),t=i+$(window).height(),e=this.box.offset().top,s=e+this.box.height(),s>=i&&t>=e?this.totop.addClass("disabled"):(this.totop.removeClass("disabled"),o=this.footer.offset().top,this.totop.css("bottom",Math.max($(window).height()/2-18,Math.max(0,20+t-o))+"px"))},i.prototype.resized=function(){var i;return i=$(window).width(),i>=750&&null===this.msnry?(this.items.toggleClass("masonry"),this.items.toggleClass("not-masonry"),this.msnry=new t("#catalog-items",{columnWidth:300,gutter:50,itemSelector:".item",isFitWidth:!1}),this.msnry.bindResize()):750>i&&null!==this.msnry?(this.items.toggleClass("masonry"),this.items.toggleClass("not-masonry"),this.msnry.destroy(),this.msnry=null):void 0},i.prototype.buyItem=function(t){var i,s,e,o,n,a,h,l,r;for(t.preventDefault(),h=$(t.currentTarget),n=h.closest(".item"),r=n.attr("data-top-ico"),i=this.card.text(),s=parseFloat(i.substr(1,i.length-2),10),isNaN(s)&&(s=0),s++,this.card.text("("+s+")"),$(document.body).addClass("cookie-animation"),a=0,l=0,e=n[0];null!==e.parentNode;)l+=e.offsetTop,a+=e.offsetLeft,e=e.parentNode;return l+=.75*n.height(),a+=n.width()/2,o=new Image,o.src=r,o.className="falling-img",o.style.left=a+"px",o.style.top=l+"px",document.body.appendChild(o),this.animatedCookies+=1,window.setTimeout(function(){return function(){return o.className="falling-img drop"}}(this),0),window.setTimeout(function(){return function(){return o.className="falling-img fly",o.style.left="50%",o.style.top="0",o.style.opacity=0}}(this),300),window.setTimeout(function(t){return function(){return t.animatedCookies-=1,o.parentNode.removeChild(o),0===t.animatedCookies?$(document.body).removeClass("cookie-animation"):void 0}}(this),2e3)},i.prototype.showDetails=function(t){var i,s;return s=$(t.currentTarget),i=s.closest(".item"),i.hasClass("full-view")||this.items.hasClass("not-masonry")?void 0:(this.widget.find(".full-view").removeClass("full-view"),i.addClass("full-view"),history.pushState?history.pushState(null,null,"#"+i.attr("data-hash")):document.location.hash="#"+i.attr("data-hash"),null!==this.msnry?this.msnry.layout():void 0)},i.prototype.switchState=function(t){var i,s;return t.preventDefault(),s=$(t.currentTarget),i=s.closest(".item"),i.hasClass("full-view")?(i.removeClass("full-view"),history.pushState&&history.pushState("",document.title,window.location.pathname)):(this.widget.find(".full-view").removeClass("full-view"),i.addClass("full-view"),history.pushState?history.pushState(null,null,"#"+i.attr("data-hash")):document.location.hash="#"+i.attr("data-hash")),null!==this.msnry?this.msnry.layout():void 0},i}()});