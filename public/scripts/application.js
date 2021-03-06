// Generated by CoffeeScript 1.6.3
(function() {
  if (!window.console) {
    window.console = {
      log: (function(obj) {})
    };
  }

  $(function() {
    var direction_panel, element_to_resize, filterList, getIOSVersion, getInternetExplorerVersion, gmap, header, headerController, i, input_boxes, map_div, onWindowResize, onWindowScroll, resized_element, scrollbarhelper, sharing_modules, slider, slider_ref, splash, store_list, tabController, toolbar, window_ref, _i, _j, _k, _l, _ref, _ref1, _ref2, _ref3,
      _this = this;
    window_ref = $(window);
    getInternetExplorerVersion = function() {
      var matches, version;
      matches = new RegExp(" MSIE ([0-9].[0-9]);").exec(window.navigator.userAgent);
      version = (matches != null) && matches.length > 1 ? parseInt(matches[1].replace(".0", "")) : -1;
      return version;
    };
    getIOSVersion = function() {
      var v;
      if (/iP(hone|od|ad)/.test(navigator.platform)) {
        v = navigator.appVersion.match(/OS (\d+)_(\d+)_?(\d+)?/);
        return [parseInt(v[1], 10), parseInt(v[2], 10), parseInt(v[3] || 0, 10)];
      } else {
        return false;
      }
    };
    window.ie_version = getInternetExplorerVersion();
    window.has_ios = getIOSVersion();
    window.is_ie = $.browser.msie;
    window.is_ie6 = $.browser.msie && ie_version === 6;
    window.is_ie7 = $.browser.msie && ie_version === 7;
    window.is_ie8 = $.browser.msie && ie_version === 8;
    window.is_ie9 = $.browser.msie && ie_version === 9;
    window.is_ie10 = $.browser.msie && ie_version === 10;
    window.is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
    window.is_mobile = navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/Android/i) ? true : false;
    window.is_iphone = navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) ? true : false;
    window.is_ipad = navigator.userAgent.match(/iPad/i) ? true : false;
    window.is_android = navigator.userAgent.match(/Android/i) ? true : false;
    window.phone_break_point = 720;
    window.item_min_height = 170;
    if (window_ref.width() >= window.phone_break_point) {
      window.desktop_size = true;
    } else {
      window.desktop_size = false;
    }
    window.event_emitter = new EventEmitter();
    splash = $('.wrap-overlay .overlay .locateFail');
    if (splash.length === 1) {
      new Splash(splash);
    }
    toolbar = $('#toolbar');
    if (toolbar.length === 1 && window.desktop_size) {
      tabController = new TabController(toolbar);
    }
    header = $('#header');
    if (header.length === 1 && window.desktop_size) {
      headerController = new HeaderController(header);
    }
    store_list = toolbar.find('.toolbar-content .stores-content');
    if (store_list.length === 1) {
      new StoreList(store_list);
    }
    direction_panel = toolbar.find('.toolbar-content .direction-content');
    if (direction_panel.length === 1) {
      new GetDirection(direction_panel);
    }
    map_div = $('#storemap');
    if (map_div.length === 1) {
      gmap = new MapManager(map_div);
    }
    google.maps.event.addDomListener(window, 'load', function() {
      return event_emitter.emitEvent("IS_READY");
    });
    filterList = $('.filterList');
    if (filterList.length === 1) {
      new FilterManager(filterList);
    }
    scrollbarhelper = new ScrollBarHelper;
    sharing_modules = $('.js-sharing');
    if (sharing_modules.length > 0) {
      for (i = _i = 0, _ref = sharing_modules.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (!$(sharing_modules[i]).hasClass('link')) {
          new SocialSharing($(sharing_modules[i]));
        }
      }
    }
    input_boxes = $('.input-js');
    if (input_boxes.length > 0) {
      for (i = _j = 0, _ref1 = input_boxes.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
        new InputPlaceHolder(input_boxes);
      }
    }
    slider_ref = $('.sliderWrapper');
    window.sliders = [];
    if (slider_ref.length > 0) {
      for (i = _k = 0, _ref2 = slider_ref.length; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; i = 0 <= _ref2 ? ++_k : --_k) {
        slider = new Slider($(slider_ref[i]));
        window.sliders.push(slider);
      }
    }
    element_to_resize = $('.js-dynamic-height');
    window.elements = [];
    if (element_to_resize.length > 0) {
      for (i = _l = 0, _ref3 = element_to_resize.length; 0 <= _ref3 ? _l < _ref3 : _l > _ref3; i = 0 <= _ref3 ? ++_l : --_l) {
        resized_element = new ResizeElement($(element_to_resize[i]));
        window.elements.push(resized_element);
      }
    }
    (function() {
      var ph, s;
      window.___fourSq = {
        explicit: false,
        onReady: function() {
          var this_widget, widget;
          this_widget = $(".fc-webicon.foursquare");
          widget = new fourSq.widget.SaveTo();
          return widget.attach(this_widget[0]);
        }
      };
      s = document.createElement("script");
      s.type = "text/javascript";
      s.src = "http://platform.foursquare.com/js/widgets.js";
      s.async = true;
      ph = document.getElementsByTagName("script")[0];
      return ph.parentNode.insertBefore(s, ph);
    })();
    onWindowScroll = function() {
      var val;
      return val = window_ref.scrollTop();
    };
    window_ref.scroll(onWindowScroll);
    onWindowResize = function() {
      var window_h, window_w, _m, _n, _ref4, _ref5;
      window_w = window_ref.width();
      window_h = window_ref.height();
      if (window_w >= window.phone_break_point) {
        window.desktop_size = true;
      } else {
        window.desktop_size = false;
      }
      if (gmap != null) {
        gmap.onResize(window_w, window_h);
      }
      if (tabController != null) {
        tabController.onResize(window_w, window_h);
      }
      if (typeof store_list_iscroll !== "undefined" && store_list_iscroll !== null) {
        store_list_iscroll.refresh();
      }
      if (typeof filter_list_iscroll !== "undefined" && filter_list_iscroll !== null) {
        filter_list_iscroll.refresh();
      }
      if (typeof direction_list_iscroll !== "undefined" && direction_list_iscroll !== null) {
        direction_list_iscroll.refresh();
      }
      if (elements.length > 0) {
        for (i = _m = 0, _ref4 = elements.length; 0 <= _ref4 ? _m < _ref4 : _m > _ref4; i = 0 <= _ref4 ? ++_m : --_m) {
          window.elements[i].onResize(window_w, window_h);
        }
      }
      if (sliders.length > 0) {
        for (i = _n = 0, _ref5 = sliders.length; 0 <= _ref5 ? _n < _ref5 : _n > _ref5; i = 0 <= _ref5 ? ++_n : --_n) {
          window.sliders[i].onResize(window_w, window_h);
        }
      }
      if (slider != null) {
        slider.onResize();
      }
      if (!window.desktop_size && (typeof mobileController === "undefined" || mobileController === null)) {
        window.mobileController = new MobileController(header, toolbar);
      }
      if (typeof mobileController !== "undefined" && mobileController !== null) {
        return mobileController.onResize(window_w, window_h);
      }
    };
    window_ref.resize(onWindowResize);
    onWindowResize();
    return event_emitter.addListener('RESIZE_ALL', onWindowResize);
  });

  $(window).load(function() {
    return window.event_emitter.emitEvent('SET_SCROLLBARS');
  });

}).call(this);
