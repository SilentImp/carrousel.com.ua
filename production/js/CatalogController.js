var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

define(['masonry/dist/masonry.pkgd.min'], function(Masonry) {
  var CatalogControllerCustom;
  CatalogControllerCustom = (function() {
    function CatalogControllerCustom() {
      this.switchState = __bind(this.switchState, this);
      this.switchBox = __bind(this.switchBox, this);
      this.buyItem = __bind(this.buyItem, this);
      this.removeItem = __bind(this.removeItem, this);
      this.orderBox = __bind(this.orderBox, this);
      this.checkIfItemsAvailable = __bind(this.checkIfItemsAvailable, this);
      this.widget = $('main>section.catalog.custom');
      if (this.widget.length === 0) {
        return;
      }
      this.itype = 'click';
      if ($('html').hasClass('touch')) {
        this.itype = 'touchstart';
      }
      this.widget.find(".item[data-hash='" + document.location.hash.substr(1) + "']").addClass('full-view');
      this.msnry = new Masonry('#catalog-items', {
        columnWidth: 300,
        gutter: 50,
        itemSelector: '.item',
        isFitWidth: false
      });
      this.msnry.bindResize();
      this.animatedCookies = 0;
      this.currentBox = this.widget.find('.box-container.selected');
      this.currentPrice = this.currentBox.find('.price b');
      this.widget.find('.box-container .order').on(this.itype, this.orderBox);
      this.box_nav = this.widget.find('.box-type');
      this.box_nav.find('a').on(this.itype, this.switchBox);
      $(document).on(this.itype, '.catalog .item .details, .catalog .item img, .catalog .item .wrapper', this.switchState);
      $(document).on(this.itype, '.catalog .item .buy', this.buyItem);
      $(document).on(this.itype, '.catalog .box-container .icons .icon', this.removeItem);
    }

    CatalogControllerCustom.prototype.checkIfItemsAvailable = function() {
      var next_empty;
      next_empty = this.currentBox.find('.icon:not(.loading):not(.loaded)');
      if (next_empty.length === 0) {
        this.widget.find('.items-list .item nav .buy').addClass('disabled');
        return this.currentBox.find('.order').removeClass('disabled');
      } else {
        this.widget.find('.items-list .item nav .buy').removeClass('disabled');
        return this.currentBox.find('.order').addClass('disabled');
      }
    };

    CatalogControllerCustom.prototype.orderBox = function(event) {
      var button, card, count, items, url;
      event.preventDefault();
      button = $(event.currentTarget);
      if (button.hasClass('disabled')) {
        return;
      }
      items = this.currentBox.find('.icon:not(.loading):not(.loaded)');
      if (items.length > 0) {
        return;
      }
      url = this.currentBox.attr('data-url');
      this.currentBox.find('.icon').removeClass('loaded').removeClass('loading').each((function(_this) {
        return function(items, element) {
          return $(element).find('img').attr("src", url);
        };
      })(this));
      this.currentBox.attr("data-summ", 0);
      this.currentPrice.text(0);
      card = $('body>header>nav>.card b');
      count = parseFloat(card, 10);
      if (isNaN(count)) {
        count = 0;
      }
      count++;
      return card.text("(" + count + ")");
    };

    CatalogControllerCustom.prototype.removeItem = function(event) {
      var item, price, summ;
      event.preventDefault();
      item = $(event.currentTarget);
      if (!item.hasClass('loaded')) {
        return;
      }
      item.removeClass('loaded');
      price = parseFloat(item.attr('data-price'), 10);
      summ = parseFloat(this.currentBox.attr('data-summ'), 10);
      summ -= price;
      this.currentBox.attr('data-summ', summ);
      if (Math.floor(summ) !== summ) {
        this.currentPrice.text(summ.toFixed(2));
      } else {
        this.currentPrice.text(summ);
      }
      item.find('img').attr('src', this.currentBox.attr('data-url'));
      this.currentBox.find('.icons').append(item);
      return this.checkIfItemsAvailable();
    };

    CatalogControllerCustom.prototype.buyItem = function(event) {
      var element, empty, empty_img, ico, id, img, item, left, link, price, summ, target_left, target_top, title, top, top_ico;
      event.preventDefault();
      link = $(event.currentTarget);
      item = link.closest('.item');
      id = item.attr("data-id");
      title = item.find(".item-title");
      price = parseFloat(item.attr("data-price"), 10);
      ico = item.attr("data-ico");
      top_ico = item.attr("data-top-ico");
      summ = parseFloat(this.currentBox.attr('data-summ'), 10);
      summ += price;
      if (Math.floor(summ) !== summ) {
        this.currentPrice.text(summ.toFixed(2));
      } else {
        this.currentPrice.text(summ);
      }
      this.currentBox.attr('data-summ', summ);
      empty = this.currentBox.find('.icon:not(.loading):not(.loaded):eq(0)');
      target_left = 0;
      target_top = 0;
      element = empty[0];
      while (element.parentNode !== null) {
        target_top += element.offsetTop;
        target_left += element.offsetLeft;
        element = element.parentNode;
      }
      empty.addClass('loading');
      empty.attr('data-id', id);
      empty.attr('data-price', price);
      empty.find(".wrapper").text(title.text());
      empty_img = empty.find('img');
      empty_img.load(function() {
        if (!$(this.parentNode).hasClass('loading')) {
          return;
        }
        return $(this).parent().removeClass('loading').addClass('loaded');
      });
      empty_img.attr("src", ico);
      left = 0;
      top = 0;
      element = item[0];
      while (element.parentNode !== null) {
        top += element.offsetTop;
        left += element.offsetLeft;
        element = element.parentNode;
      }
      top += item.height() / 2;
      left += item.width() / 2;
      $(document.body).addClass('cookie-animation');
      img = new Image;
      img.src = top_ico;
      img.className = 'falling-img';
      img.style.left = left + "px";
      img.style.top = top + "px";
      document.body.appendChild(img);
      this.animatedCookies += 1;
      window.setTimeout((function(_this) {
        return function() {
          return img.className = 'falling-img drop';
        };
      })(this), 0);
      window.setTimeout((function(_this) {
        return function() {
          img.className = 'falling-img fly';
          img.style.left = "50%";
          img.style.top = "0";
          return img.style.opacity = 0;
        };
      })(this), 300);
      window.setTimeout((function(_this) {
        return function() {
          _this.animatedCookies -= 1;
          img.parentNode.removeChild(img);
          if (_this.animatedCookies === 0) {
            return $(document.body).removeClass('cookie-animation');
          }
        };
      })(this), 2000);
      return this.checkIfItemsAvailable();
    };

    CatalogControllerCustom.prototype.switchBox = function(event) {
      var link, target;
      event.preventDefault();
      link = $(event.currentTarget);
      target = link.attr('data-target');
      this.box_nav.find('.selected').removeClass('selected');
      this.widget.find('.box-container.selected').removeClass('selected');
      this.currentBox = $('#' + target);
      this.currentBox.addClass('selected');
      this.currentPrice = this.currentBox.find('.price b');
      link.addClass('selected');
      return this.checkIfItemsAvailable();
    };

    CatalogControllerCustom.prototype.switchState = function(event) {
      var item, link;
      event.preventDefault();
      link = $(event.currentTarget);
      item = link.closest('.item');
      if (!item.hasClass('full-view')) {
        this.widget.find('.full-view').removeClass('full-view');
      }
      item.toggleClass('full-view');
      return this.msnry.layout();
    };

    return CatalogControllerCustom;

  })();
  return CatalogControllerCustom;
});
