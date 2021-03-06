// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.TabController = (function() {
    function TabController(ref) {
      this.ref = ref;
      this.onHistoryStateChange = __bind(this.onHistoryStateChange, this);
      this.checkHistory = __bind(this.checkHistory, this);
      this.onResize = __bind(this.onResize, this);
      this.tabChanged = __bind(this.tabChanged, this);
      this.openDirection = __bind(this.openDirection, this);
      this.setFilterInteraction = __bind(this.setFilterInteraction, this);
      this.setInteractions = __bind(this.setInteractions, this);
      this.showRef = __bind(this.showRef, this);
      this.showDirections = __bind(this.showDirections, this);
      this.ref.hide();
      this.header = this.ref.parent().find('#header');
      this.header_height = this.header.height();
      this.padding = 40;
      this.direction_top_height = 239;
      this.current_tab = "stores";
      this.tab_bar = this.ref.find('.toolbar-tabber');
      this.stores_tab = this.tab_bar.find('.js-stores_tab');
      this.direction_tab = this.tab_bar.find('.js-direction_tab');
      this.general_content = this.ref.find('.toolbar-content');
      this.stores_content = this.general_content.find('.stores-content');
      this.search = this.stores_content.find('.search-wrapper');
      this.direction_content = this.general_content.find('.direction-content');
      this.direction_panel = this.direction_content.find('#direction-panel-scroller');
      this.filter_btn = this.stores_content.find('.action-bar >a.filter');
      this.stores_content_c = this.stores_content.find('#content');
      this.stores_content_searchResult = this.stores_content.find('#content #wrapSearchResult');
      this.stores_content_filterList = this.stores_content.find('#content #wrapFilterList');
      this.stores_content_auxFilterList = this.stores_content.find('#content #auxFilterList');
      this.footer_height = this.filter_btn.height();
      this.tab_height = this.stores_tab.height();
      this.search_height = parseInt(this.search.css('height'));
      this.direction_display_btn_height = this.direction_content.find('.action-bar >button').outerHeight();
      event_emitter.addListener('CURRENT_TAB_IS_CHANGED', this.tabChanged);
      event_emitter.addListener('STORE_LIST_READY', this.showRef);
      event_emitter.addListener('OPEN_DIRECTION', this.openDirection);
      event_emitter.addListener('DIRECTION_CHANGE_CALLBACK', this.showDirections);
      this.direction_panel.hide();
      this.setInteractions();
      this.setFilterInteraction();
      this.setHistory();
    }

    TabController.prototype.showDirections = function() {
      this.direction_panel.show();
      return this.ref.addClass('direction-opened');
    };

    TabController.prototype.showRef = function() {
      this.ref.show();
      if (typeof store_list_iscroll !== "undefined" && store_list_iscroll !== null) {
        return store_list_iscroll.refresh();
      }
    };

    TabController.prototype.setInteractions = function() {
      var _this = this;
      this.stores_tab.click(function(e) {
        var stores_tab;
        e.preventDefault();
        if (_this.current_tab !== "stores") {
          stores_tab = $(e.currentTarget);
          stores_tab.toggleClass('current');
          _this.direction_tab.toggleClass('current');
          _this.stores_content.show();
          _this.direction_content.hide();
          _this.current_tab = "stores";
          event_emitter.emitEvent("CURRENT_TAB_IS_CHANGED");
          if (!_this.stores_history) {
            History.pushState({
              state: _this.current_tab
            }, "Stores", "stores");
            return _this.stores_history = true;
          } else {
            return History.replaceState({
              state: _this.current_tab
            }, "Stores", "stores");
          }
        }
      });
      return this.direction_tab.click(function(e) {
        var direction_tab;
        e.preventDefault();
        if (_this.current_tab !== "directions") {
          direction_tab = $(e.currentTarget);
          direction_tab.toggleClass('current');
          _this.stores_tab.toggleClass('current');
          _this.direction_content.show();
          _this.stores_content.hide();
          _this.current_tab = "directions";
          event_emitter.emitEvent("CURRENT_TAB_IS_CHANGED");
          if (!_this.directions_history) {
            History.pushState({
              state: _this.current_tab
            }, "Directions", "directions");
            return _this.directions_history = true;
          } else {
            return History.replaceState({
              state: _this.current_tab
            }, "Directions", "directions");
          }
        }
      });
    };

    TabController.prototype.setFilterInteraction = function() {
      var _this = this;
      return this.filter_btn.click(function(e) {
        var filter_btn;
        filter_btn = $(e.currentTarget);
        if (_this.current_tab === "stores") {
          filter_btn.toggleClass('active');
          if (!filter_btn.hasClass('active')) {
            _this.stores_content_searchResult.hide();
            _this.stores_content_filterList.show();
            if (typeof filter_list_iscroll !== "undefined" && filter_list_iscroll !== null) {
              return filter_list_iscroll.refresh();
            }
          } else {
            _this.stores_content_searchResult.show();
            _this.stores_content_filterList.hide();
            if (typeof store_list_iscroll !== "undefined" && store_list_iscroll !== null) {
              return store_list_iscroll.refresh();
            }
          }
        }
      });
    };

    TabController.prototype.openDirection = function() {
      this.direction_tab.click();
      return event_emitter.emitEvent('SETTING_FOCUS');
    };

    TabController.prototype.tabChanged = function() {
      if (this.current_tab !== "stores") {
        this.direction_panel.hide();
        this.stores_content_filterList.hide();
        this.stores_content_searchResult.show();
        this.filter_btn.addClass('active');
        this.ref.removeClass('direction-opened');
        return event_emitter.emitEvent('SETTING_MAP_OPTIONS');
      } else {
        this.direction_panel.hide();
        this.ref.removeClass('direction-opened');
        event_emitter.emitEvent('CLEAR_DIRECTION');
        if (typeof store_list_iscroll !== "undefined" && store_list_iscroll !== null) {
          return store_list_iscroll.refresh();
        }
      }
    };

    TabController.prototype.onResize = function(window_w, window_h) {
      var direction_height_to_assign, height_to_assign, max_height;
      height_to_assign = window_h - this.header_height - this.footer_height - this.padding - this.search_height - this.tab_height;
      direction_height_to_assign = window_h - this.header_height - this.direction_top_height - this.direction_display_btn_height - this.padding - this.tab_height;
      if (height_to_assign < window.item_min_height) {
        height_to_assign = window.item_min_height;
      }
      if (direction_height_to_assign < window.item_min_height) {
        direction_height_to_assign = window.item_min_height - 200;
      }
      max_height = this.stores_content_filterList.find('.filterList').children('li').length * 92;
      if (height_to_assign > max_height) {
        height_to_assign = max_height;
      }
      this.stores_content_c.css('height', "" + height_to_assign + "px");
      this.stores_content_searchResult.css('height', "" + height_to_assign + "px");
      this.stores_content_filterList.css('height', "" + height_to_assign + "px");
      this.stores_content_auxFilterList.css('height', "" + height_to_assign + "px");
      return this.direction_panel.css('height', "" + direction_height_to_assign + "px");
    };

    TabController.prototype.setHistory = function() {
      this.checkHistory();
      if (!History.enabled) {
        return false;
      }
      this.has_history = true;
      return History.Adapter.bind(window, 'statechange', this.onHistoryStateChange);
    };

    TabController.prototype.checkHistory = function() {
      var state, tab;
      state = History.getState();
      tab = state.data["state"];
      if (tab === "directions") {
        this.direction_tab.click();
        return this.directions_history = true;
      } else if (tab === "stores") {
        this.stores_tab.click();
        return this.stores_history = true;
      } else {
        History.pushState({
          state: this.current_tab
        }, "Stores", "stores");
        return this.stores_history = true;
      }
    };

    TabController.prototype.onHistoryStateChange = function() {
      var State;
      return State = History.getState();
    };

    return TabController;

  })();

}).call(this);
