var __bind=function(t,e){return function(){return t.apply(e,arguments)}};define(["masonry/dist/masonry.pkgd.min"],function(t){var e;return e=function(){function e(){this.switchState=__bind(this.switchState,this),this.showDetails=__bind(this.showDetails,this),this.switchBox=__bind(this.switchBox,this),this.buyItem=__bind(this.buyItem,this),this.removeItem=__bind(this.removeItem,this),this.orderBox=__bind(this.orderBox,this),this.checkIfItemsAvailable=__bind(this.checkIfItemsAvailable,this),this.resized=__bind(this.resized,this),this.checkIfVisible=__bind(this.checkIfVisible,this),this.scrollToTheBox=__bind(this.scrollToTheBox,this),this.widget=$(".main>section.catalog.custom"),0!==this.widget.length&&(this.transitions=$("body").hasClass("csstransitions"),this.transforms=$("body").hasClass("csstransforms"),this.transform3d=$("body").hasClass("csstransforms3d"),this.itype="click",$("html").hasClass("touch")&&(this.itype="touchstart"),this.widget.find(".item[data-hash='"+document.location.hash.substr(1)+"']").addClass("full-view"),this.items=$("#catalog-items"),this.msnry=null,$(window).width()>=750&&(this.items.toggleClass("masonry"),this.items.toggleClass("not-masonry"),this.msnry=new t("#catalog-items",{columnWidth:300,gutter:50,itemSelector:".item",isFitWidth:!1}),this.msnry.bindResize()),$(window).resize(this.resized),this.animatedCookies=0,this.currentBox=this.widget.find(".box-container.selected"),this.currentPrice=this.currentBox.find(".price b"),this.widget.find(".box-container .order").on(this.itype,this.orderBox),this.box_nav=this.widget.find(".box-type"),this.box_nav.find("a").on(this.itype,this.switchBox),$(document).on(this.itype,".catalog .item img, .catalog .item .wrapper",this.showDetails),$(document).on(this.itype,".catalog .item .details",this.switchState),$(document).on(this.itype,".catalog .item .buy",this.buyItem),$(document).on(this.itype,".catalog .box-container .icons .icon",this.removeItem),this.checkIfItemsAvailable(),this.totop=$(".scroll-to-the-box"),this.totop.length>0&&(this.totop.on(this.itype,this.scrollToTheBox),this.box=$("#box"),$(window).on("scroll",this.checkIfVisible),this.footer=$("body>.main>footer")))}return e.prototype.scrollToTheBox=function(t){return t.preventDefault(),$("html, body").animate({scrollTop:$("#box").offset().top},1500)},e.prototype.checkIfVisible=function(){var t,e,i,s,o;return e=$(window).scrollTop(),t=e+$(window).height(),s=this.box.offset().top,i=s+this.box.height(),i>=e&&t>=s?this.totop.addClass("disabled"):(this.totop.removeClass("disabled"),o=this.footer.offset().top,this.totop.css("bottom",Math.max($(window).height()/2-18,Math.max(0,20+t-o))+"px"))},e.prototype.resized=function(){var e;return e=$(window).width(),e>=750&&null===this.msnry?(this.items.toggleClass("masonry"),this.items.toggleClass("not-masonry"),this.msnry=new t("#catalog-items",{columnWidth:300,gutter:50,itemSelector:".item",isFitWidth:!1}),this.msnry.bindResize()):750>e&&null!==this.msnry?(this.items.toggleClass("masonry"),this.items.toggleClass("not-masonry"),this.msnry.destroy(),this.msnry=null):void 0},e.prototype.checkIfItemsAvailable=function(){var t;return t=this.currentBox.find(".icon:not(.loading):not(.loaded)"),0===t.length?(this.widget.find(".items-list .item nav .buy").addClass("disabled"),this.currentBox.find(".order").removeClass("disabled")):(this.widget.find(".items-list .item nav .buy").removeClass("disabled"),this.currentBox.find(".order").addClass("disabled"))},e.prototype.orderBox=function(t){var e,i,s,o,a;return t.preventDefault(),e=$(t.currentTarget),e.hasClass("disabled")||(o=this.currentBox.find(".icon:not(.loading):not(.loaded)"),o.length>0)?void 0:(a=this.currentBox.attr("data-url"),this.currentBox.find(".icon").removeClass("loaded").removeClass("loading").each(function(){return function(t,e){return $(e).find("img").attr("src",a)}}(this)),this.currentBox.attr("data-summ",0),this.currentPrice.text(0),i=$("body>header>nav>.card b"),s=parseFloat(i,10),isNaN(s)&&(s=0),s++,i.text("("+s+")"),this.checkIfItemsAvailable())},e.prototype.removeItem=function(t){var e,i,s;return t.preventDefault(),e=$(t.currentTarget),e.hasClass("loaded")?(e.removeClass("loaded"),i=parseFloat(e.attr("data-price"),10),s=parseFloat(this.currentBox.attr("data-summ"),10),s-=i,this.currentBox.attr("data-summ",s),this.currentPrice.text(Math.floor(s)!==s?s.toFixed(2):s),e.find("img").attr("src",this.currentBox.attr("data-url")),this.currentBox.find(".icons").append(e),this.checkIfItemsAvailable()):void 0},e.prototype.buyItem=function(t){var e,i,s,o,a,r,n,h,l,d,c,u,m,f,p,y;for(t.preventDefault(),l=$(t.currentTarget),n=l.closest(".item"),a=n.attr("data-id"),f=n.find(".item-title"),d=parseFloat(n.attr("data-price"),10),o=n.attr("data-ico"),y=n.attr("data-top-ico"),c=parseFloat(this.currentBox.attr("data-summ"),10),c+=d,this.currentPrice.text(Math.floor(c)!==c?c.toFixed(2):c),this.currentBox.attr("data-summ",c),i=this.currentBox.find(".icon:not(.loading):not(.loaded):eq(0)"),u=0,m=0,e=i[0];null!==e.parentNode;)m+=e.offsetTop,u+=e.offsetLeft,e=e.parentNode;for(i.addClass("loading"),i.attr("data-id",a),i.attr("data-price",d),i.find(".wrapper").text(f.text()),s=i.find("img"),s.load(function(){return $(this.parentNode).hasClass("loading")?$(this).parent().removeClass("loading").addClass("loaded"):void 0}),s.attr("src",o),h=0,p=0,e=n[0];null!==e.parentNode;)p+=e.offsetTop,h+=e.offsetLeft,e=e.parentNode;return p+=.75*n.height(),h+=n.width()/2,r=new Image,r.src=y,r.className="falling-img",r.style.left=h+"px",r.style.top=p+"px",document.body.appendChild(r),this.transform3d?($(document.body).addClass("cookie-animation"),this.animatedCookies+=1,window.setTimeout(function(){return function(){return r.className="falling-img drop"}}(this),0),window.setTimeout(function(){return function(){return r.className="falling-img fly",r.style.left="50%",r.style.top="0",r.style.opacity=0}}(this),300),window.setTimeout(function(t){return function(){return t.animatedCookies-=1,r.parentNode.removeChild(r),0===t.animatedCookies?$(document.body).removeClass("cookie-animation"):void 0}}(this),2e3)):(r.style.opacity=1,$(r).animate({left:"50%",top:"-200px",opacity:"0"},1e3),window.setTimeout(function(){return function(){return r.parentNode.removeChild(r)}}(this),2e3)),this.checkIfItemsAvailable()},e.prototype.switchBox=function(t){var e,i;return t.preventDefault(),e=$(t.currentTarget),i=e.attr("data-target"),this.box_nav.find(".selected").removeClass("selected"),this.widget.find(".box-container.selected").removeClass("selected"),this.currentBox=$("#"+i),this.currentBox.addClass("selected"),this.currentPrice=this.currentBox.find(".price b"),e.addClass("selected"),this.checkIfItemsAvailable()},e.prototype.showDetails=function(t){var e,i;return i=$(t.currentTarget),e=i.closest(".item"),e.hasClass("full-view")||this.items.hasClass("not-masonry")?void 0:(this.widget.find(".full-view").removeClass("full-view"),e.addClass("full-view"),history.pushState?history.pushState(null,null,"#"+e.attr("data-hash")):document.location.hash="#"+e.attr("data-hash"),null!==this.msnry?this.msnry.layout():void 0)},e.prototype.switchState=function(t){var e,i;return t.preventDefault(),i=$(t.currentTarget),e=i.closest(".item"),e.hasClass("full-view")?(e.removeClass("full-view"),history.pushState&&history.pushState("",document.title,window.location.pathname)):(this.widget.find(".full-view").removeClass("full-view"),e.addClass("full-view"),history.pushState?history.pushState(null,null,"#"+e.attr("data-hash")):document.location.hash="#"+e.attr("data-hash")),null!==this.msnry?this.msnry.layout():void 0},e}()});