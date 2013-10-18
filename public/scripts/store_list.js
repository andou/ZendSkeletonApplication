// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.StoreList = (function() {
    function StoreList(ref) {
      this.ref = ref;
      this.setInteractions = __bind(this.setInteractions, this);
      this.updateStores = __bind(this.updateStores, this);
      this.createList = __bind(this.createList, this);
      this.list = this.ref.find('#content #searchResult');
      event_emitter.addListener('DATA_READY', this.createList);
      event_emitter.addListener('REFRESH_STORES', this.updateStores);
    }

    StoreList.prototype.createList = function(data) {
      var i, is_odd, store_is_new, store_list, _i, _ref;
      store_list = [];
      for (i = _i = 0, _ref = data.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        store_is_new = data[i]["new_store"] === "1" ? "<div class='ico-new' data-icon='z'>" : "";
        is_odd = i % 2 === 0 ? "odd" : "";
        store_list.push("<li class='item " + is_odd + "' data-marker='" + i + "'><a href='#' class='storeSummary'>" + store_is_new + "</div>				<h2 class='storeName'><span class='icon' data-icon='f'></span><span class='label'>" + data[i]['title'] + "</span></h2>        <p class='storeAddress'>" + data[i]['address'] + ", " + data[i]['cap'] + ", " + data[i]['city'] + ", " + data[i]['country'] + "</p>        <p class='storePhone'><span class='icon' data-icon='g'></span><span class='label'>" + data[i]['tel'] + "</span></p>        <p class='storeDistance'>1.1km</p>          </a>        </li>");
      }
      this.list.html(store_list.join(''));
      if (typeof store_list_iscroll !== "undefined" && store_list_iscroll !== null) {
        store_list_iscroll.refresh();
      }
      this.setInteractions();
      return event_emitter.emitEvent("STORE_LIST_READY");
    };

    StoreList.prototype.updateStores = function(num, is_active) {
      var i, _i, _ref;
      this.store_item = this.list.find('>li');
      for (i = _i = 0, _ref = this.store_item.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.store = $(this.store_item[i]);
        this.data_marker = parseInt(this.store.attr('data-marker'));
        if (this.data_marker === parseInt(num)) {
          if (is_active) {
            this.store.show();
          } else {
            this.store.hide();
          }
        }
      }
      if (typeof store_list_iscroll !== "undefined" && store_list_iscroll !== null) {
        return store_list_iscroll.refresh();
      }
    };

    StoreList.prototype.setInteractions = function() {
      var _this = this;
      this.store_item = this.list.find('>li');
      return this.store_item.click(function(e) {
        var num, store_item;
        e.preventDefault();
        store_item = e.currentTarget;
        num = $(store_item).attr('data-marker');
        event_emitter.emitEvent('STORE_ITEM_SELECTED', [num]);
        event_emitter.emitEvent('STORE_ADDRESS_CHANGED');
        if (!window.desktop_size) {
          return event_emitter.emitEvent('CLOSE_STORE_TAB');
        }
      });
    };

    return StoreList;

  })();

}).call(this);
