// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.GetDirection = (function() {
    function GetDirection(ref) {
      var _this = this;
      this.ref = ref;
      this.setDestination = __bind(this.setDestination, this);
      this.findTravelingMode = __bind(this.findTravelingMode, this);
      this.setActive = __bind(this.setActive, this);
      this.settingFocus = __bind(this.settingFocus, this);
      this.settingTravelingModes = __bind(this.settingTravelingModes, this);
      this.showAllTravelOptions = __bind(this.showAllTravelOptions, this);
      this.setwalking = __bind(this.setwalking, this);
      this.initFlipBtn = __bind(this.initFlipBtn, this);
      this.initGDBtn = __bind(this.initGDBtn, this);
      this.content = this.ref.find('.direction');
      this.travel_modes = this.content.find('.travel-modes >li > a');
      this.address_a = this.content.find('.j-address_a');
      this.address_b = this.content.find('.j-address_b');
      this.getDirection_btn = this.ref.find('.action-bar >button');
      this.traveling_mode = google.maps.DirectionsTravelMode.DRIVING;
      this.flipping_btn = this.ref.find('.address-flip');
      this.settingTravelingModes();
      this.initGDBtn();
      this.initFlipBtn();
      event_emitter.addListener('DESTINATION_IS_CHANGED', this.setDestination);
      event_emitter.addListener('BICYCLE_MODE_ISNT_AVAILABLE', this.setwalking);
      event_emitter.addListener('SETTING_FOCUS', this.settingFocus);
      this.content.find('.j-address_a').change(function() {
        return _this.showAllTravelOptions();
      });
      this.content.find('.j-address_b').change(function() {
        return _this.showAllTravelOptions();
      });
    }

    GetDirection.prototype.initGDBtn = function() {
      var _this = this;
      return this.getDirection_btn.click(function(e) {
        var end, start;
        e.preventDefault();
        start = _this.content.find('.j-address_a').val();
        end = _this.content.find('.j-address_b').val();
        if (start !== '' && end !== '') {
          return event_emitter.emitEvent("TAKE_DIRECTION", [start, end, _this.traveling_mode]);
        }
      });
    };

    GetDirection.prototype.initFlipBtn = function() {
      var _this = this;
      return this.flipping_btn.click(function(e) {
        var a_val, b_val;
        e.preventDefault();
        a_val = _this.address_a.val();
        b_val = _this.address_b.val();
        _this.old_a = _this.address_a;
        _this.old_b = _this.address_b;
        _this.address_a.val(b_val);
        _this.address_b.val(a_val);
        _this.address_a = _this.old_b;
        _this.address_b = _this.old_a;
        return _this.getDirection_btn.click();
      });
    };

    GetDirection.prototype.setwalking = function() {
      var i, _i, _ref, _results, _tm;
      _results = [];
      for (i = _i = 0, _ref = this.travel_modes.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        _tm = $(this.travel_modes[i]);
        if (_tm.attr('data-travelingmode') === 'bicycling') {
          _tm.addClass('disabled');
        }
        if (_tm.attr('data-travelingmode') === 'walking') {
          _results.push(_tm.click());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    GetDirection.prototype.showAllTravelOptions = function() {
      var i, _i, _ref, _results, _tm;
      console.log('changed');
      _results = [];
      for (i = _i = 0, _ref = this.travel_modes.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        _tm = $(this.travel_modes[i]);
        _results.push(_tm.removeClass('disabled'));
      }
      return _results;
    };

    GetDirection.prototype.settingTravelingModes = function() {
      var i, _i, _ref, _results, _tm,
        _this = this;
      _results = [];
      for (i = _i = 0, _ref = this.travel_modes.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        _tm = $(this.travel_modes[i]);
        _results.push(_tm.click(function(e) {
          var tm;
          e.preventDefault();
          tm = $(e.currentTarget);
          _this.traveling_mode = _this.findTravelingMode(tm.attr('data-travelingmode'));
          _this.setActive(tm);
          return _this.getDirection_btn.click();
        }));
      }
      return _results;
    };

    GetDirection.prototype.settingFocus = function(e) {
      return this.address_a.trigger('focus');
    };

    GetDirection.prototype.setActive = function(tm) {
      var i, _i, _ref, _tm;
      for (i = _i = 0, _ref = this.travel_modes.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        _tm = $(this.travel_modes[i]);
        if (_tm !== tm) {
          _tm.removeClass('active');
        }
      }
      return tm.addClass('active');
    };

    GetDirection.prototype.findTravelingMode = function(mode) {
      var gmode;
      switch (mode) {
        case 'driving':
          gmode = google.maps.DirectionsTravelMode.DRIVING;
          break;
        case 'bicycling':
          gmode = google.maps.DirectionsTravelMode.BICYCLING;
          break;
        case 'walking':
          gmode = google.maps.DirectionsTravelMode.WALKING;
      }
      return gmode;
    };

    GetDirection.prototype.setDestination = function(address) {
      return this.address_b.val(address);
    };

    return GetDirection;

  })();

}).call(this);