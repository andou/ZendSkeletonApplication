// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.MapManager = (function() {
    function MapManager(ref) {
      this.ref = ref;
      this.settingMapOptions = __bind(this.settingMapOptions, this);
      this.cleanMap = __bind(this.cleanMap, this);
      this.showDirection = __bind(this.showDirection, this);
      this.openMarker = __bind(this.openMarker, this);
      this.hideAllMarkers = __bind(this.hideAllMarkers, this);
      this.showAllMarkers = __bind(this.showAllMarkers, this);
      this.popItem = __bind(this.popItem, this);
      this.checkActiveBrands = __bind(this.checkActiveBrands, this);
      this.checkBrands = __bind(this.checkBrands, this);
      this.onResize = __bind(this.onResize, this);
      this.geolocationError = __bind(this.geolocationError, this);
      this.geolocationSuccess = __bind(this.geolocationSuccess, this);
      this.findPosition = __bind(this.findPosition, this);
      this.setAddress = __bind(this.setAddress, this);
      this.findContent = __bind(this.findContent, this);
      this.setInfoWindowInteractions = __bind(this.setInfoWindowInteractions, this);
      this.setInfoWindow = __bind(this.setInfoWindow, this);
      this.setMarkers = __bind(this.setMarkers, this);
      this.onDataLoaded = __bind(this.onDataLoaded, this);
      this.loadData = __bind(this.loadData, this);
      this.initialize = __bind(this.initialize, this);
      this.setMapIntro = __bind(this.setMapIntro, this);
      this.map_container = this.ref.get(0);
      this.def_long = -84.575195;
      this.def_lat = 44.139497;
      this.icon = "images/marker.png";
      this.iconA = "images/marker_a.png";
      this.iconB = "images/marker_b.png";
      this.data_url = "json/map.json";
      this.markers = [];
      this.active_brands = [];
      if (!window.desktop_size) {
        this.ref.data('baloon', 280);
      }
      this.infobox_width = this.ref.data('baloon');
      this.offset = 4;
      this.infoBox_pos_X = -(this.infobox_width / 2) + this.offset;
      this.infoBox_pos_Y = -24;
      this.rendererOptions = {
        suppressMarkers: true
      };
      this.directionsService = new google.maps.DirectionsService();
      this.directionsDisplay = new google.maps.DirectionsRenderer(this.rendererOptions);
      this.directionsDisplay.setPanel(document.getElementById('directions-panel'));
      this.boxText = '';
      $('body').append(this.boxText);
      this.infobox_options = {
        content: this.boxText,
        disableAutoPan: false,
        maxWidth: 0,
        pixelOffset: new google.maps.Size(this.infoBox_pos_X, this.infoBox_pos_Y),
        zIndex: null,
        boxStyle: {
          background: "",
          opacity: 1,
          width: "auto"
        },
        closeBoxMargin: "0",
        closeBoxURL: "",
        infoBoxClearance: new google.maps.Size(1, 1),
        isHidden: false,
        pane: "floatPane",
        enableEventPropagation: false,
        alignBottom: true
      };
      this.geolocation_options = {
        enableHighAccuracy: true,
        timeout: 1000,
        maximumAge: 0
      };
      event_emitter.addListener("IS_READY", this.findPosition);
      event_emitter.addListener("BRAND_CHANGE", this.checkActiveBrands);
      event_emitter.addListener("SHOW_ALL_MARKERS", this.showAllMarkers);
      event_emitter.addListener("STORE_ITEM_SELECTED", this.openMarker);
      event_emitter.addListener("TAKE_DIRECTION", this.showDirection);
      event_emitter.addListener("MAP_INIT", this.initialize);
      event_emitter.addListener("CLEAR_DIRECTION", this.cleanMap);
      event_emitter.addListener("SETTING_MAP_OPTIONS", this.settingMapOptions);
      this.setMapIntro();
    }

    MapManager.prototype.setMapIntro = function() {
      if (window.desktop_size) {
        this.has_control = true;
      } else {
        this.has_control = false;
      }
      this.map_options = {
        zoom: 10,
        center: new google.maps.LatLng(this.def_lat, this.def_long),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControl: false,
        panControl: this.has_control,
        panControlOptions: {
          position: google.maps.ControlPosition.TOP_RIGHT
        },
        zoomControl: this.has_control,
        zoomControlOptions: {
          style: google.maps.ZoomControlStyle.LARGE,
          position: google.maps.ControlPosition.TOP_RIGHT
        },
        scaleControl: this.has_control,
        scaleControlOptions: {
          position: google.maps.ControlPosition.TOP_RIGHT
        },
        streetViewControl: this.has_control,
        streetViewControlOptions: {
          position: google.maps.ControlPosition.TOP_RIGHT
        }
      };
      this.map = new google.maps.Map(this.map_container, this.map_options);
      return this.directionsDisplay.setMap(this.map);
    };

    MapManager.prototype.initialize = function(lat, long) {
      var newLatLng,
        _this = this;
      if (lat == null) {
        lat = this.def_lat;
      }
      if (long == null) {
        long = this.def_long;
      }
      newLatLng = new google.maps.LatLng(lat, long);
      this.map.setCenter(newLatLng);
      this.loadData();
      if (window.is_mobile) {
        this.GeoMarker = new GeolocationMarker(this.map);
      }
      return google.maps.event.addListener(this.directionsDisplay, 'directions_changed', function() {
        event_emitter.emitEvent('DIRECTION_CHANGE_CALLBACK');
        return _this.timeout = setTimeout(function() {
          if (typeof direction_list_iscroll !== "undefined" && direction_list_iscroll !== null) {
            direction_list_iscroll.refresh();
            direction_list_iscroll.scrollTo(0, 0, 0);
          }
          return clearTimeout(_this.timeout);
        }, 1);
      });
    };

    MapManager.prototype.loadData = function() {
      return $.getJSON(this.data_url, this.onDataLoaded);
    };

    MapManager.prototype.onDataLoaded = function(data) {
      var i, marker, _i, _ref,
        _this = this;
      for (i = _i = 0, _ref = data.markers.marker.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        marker = {};
        $.each(data.markers.marker[i], function(key, val) {
          return marker[key] = val;
        });
        this.markers.push(marker);
      }
      this.setMarkers();
      return event_emitter.emitEvent('DATA_READY', [this.markers]);
    };

    MapManager.prototype.setMarkers = function() {
      var brands_obj, i, marker_on_map, _i, _ref;
      for (i = _i = 0, _ref = this.markers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        brands_obj = this.markers[i]["brands"];
        marker_on_map = new google.maps.Marker({
          position: new google.maps.LatLng(this.markers[i]["latitude"], this.markers[i]["longitude"]),
          map: this.map,
          icon: new google.maps.MarkerImage(this.icon, null, null, null, new google.maps.Size(25, 36)),
          animation: google.maps.Animation.DROP
        });
        this.markers[i]["marker_point"] = marker_on_map;
        this.markers[i]["visible"] = true;
        google.maps.event.addListener(marker_on_map, 'visible_changed', function() {});
      }
      return this.setInfoWindow();
    };

    MapManager.prototype.setInfoWindow = function() {
      var findContent, i, ib, setAddress, setInfoWindowInteractions, _i, _ref,
        _this = this;
      findContent = this.findContent;
      setAddress = this.setAddress;
      setInfoWindowInteractions = this.setInfoWindowInteractions;
      this.ib = new InfoBox(this.infobox_options);
      google.maps.event.addListener(this.ib, 'domready', this.setInfoWindowInteractions);
      ib = this.ib;
      for (i = _i = 0, _ref = this.markers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        google.maps.event.addListener(this.markers[i]["marker_point"], 'click', function() {
          ib.setContent(findContent(this));
          ib.open(this.map, this);
          return event_emitter.emitEvent("DESTINATION_IS_CHANGED", [setAddress(this)]);
        });
      }
      if (!window.desktop_size) {
        return google.maps.event.addListener(this.map, 'click', function() {
          return _this.ib.close();
        });
      }
    };

    MapManager.prototype.setInfoWindowInteractions = function() {
      var close_btn, direction_btn, infobox,
        _this = this;
      infobox = $('.infowindow');
      close_btn = infobox.find('.close');
      direction_btn = infobox.find('.direction');
      close_btn.click(function(e) {
        e.preventDefault();
        return _this.ib.close();
      });
      return direction_btn.click(function(e) {
        e.preventDefault();
        if (window.desktop_size) {
          return event_emitter.emitEvent('OPEN_DIRECTION');
        } else {
          return console.log('should open the link');
        }
      });
    };

    MapManager.prototype.findContent = function(markerPoint) {
      var i, _i, _ref;
      for (i = _i = 0, _ref = this.markers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (this.markers[i]["marker_point"] === markerPoint) {
          return "<div class='infowindow'>				  <div class='content'>            <a href='#' class='close' data-icon='c'></a>				    <div class='store-summary'>				      <div class='wrap-top-info'>                <div class='top-info'>                  <div class='ico-new' data-icon='z'></div>                  <h2 class='storeName'><span class='label'>" + this.markers[i]['title'] + "</span></h2>                  <p class='storeAddress'>" + this.markers[i]['address'] + ", " + this.markers[i]['cap'] + "," + this.markers[i]['city'] + "," + this.markers[i]['country'] + "</p>                  <span class='storeDistance'>0.km</span>                </div>              </div>				      <div class='bottom-info'>				        <div class='col-left'>				          <p class='storeOpeningHours'><span class='title'>Today Opening Hours: </span> <span class='hours'>" + this.markers[i]['opening_hours'] + "</span></p>				          <p class='storePhone'><span class='label'>" + this.markers[i]['tel'] + "</span></p>				        </div>				        <div class='col-right'>				          <ul class='action'>                    <li><a href='/storeinfo' class='icon info' data-icon='d'></a></li>				            <li><a href='#' class='icon direction' data-icon='a'></a></li>				          </ul>				        </div>				      </div>				    </div>				  </div>				  <div class='footer'></div>				</div>";
        }
      }
    };

    MapManager.prototype.setAddress = function(markerPoint) {
      var i, _i, _ref;
      for (i = _i = 0, _ref = this.markers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (this.markers[i]["marker_point"] === markerPoint) {
          return "" + this.markers[i]['address'] + ", " + this.markers[i]['cap'] + "," + this.markers[i]['city'] + "," + this.markers[i]['country'];
        }
      }
    };

    MapManager.prototype.findPosition = function() {
      if (navigator.geolocation) {
        return navigator.geolocation.getCurrentPosition(this.geolocationSuccess, this.geolocationError, this.geolocation_options);
      } else {
        return event_emitter.emitEvent("GEO_LOCATION_FAILED");
      }
    };

    MapManager.prototype.geolocationSuccess = function(position) {
      return this.initialize(position.coords.latitude, position.coords.longitude);
    };

    MapManager.prototype.geolocationError = function(Error) {
      return event_emitter.emitEvent("GEO_LOCATION_FAILED");
    };

    MapManager.prototype.onResize = function(window_w, window_h) {
      var center, _h_;
      _h_ = window_h - parseInt($("#header").css('height'));
      if (window_w < window.phone_break_point) {
        _h_ = _h_ - 44;
      }
      this.ref.css("width", "" + window_w + "px");
      this.ref.css("height", "" + _h_ + "px");
      if (this.map) {
        center = this.map.getCenter();
        google.maps.event.trigger(this.map, 'resize');
        return this.map.setCenter(center);
      }
    };

    MapManager.prototype.checkBrands = function() {
      var brand_to_check, i, j, _i, _is_selected_brand, _j, _ref, _ref1, _results;
      _results = [];
      for (i = _i = 0, _ref = this.markers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (this.active_brands.length !== 0) {
          _is_selected_brand = false;
          for (j = _j = 0, _ref1 = this.markers[i]["brands"].brand.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
            brand_to_check = this.markers[i]["brands"].brand[j];
            if ($.inArray(brand_to_check, this.active_brands) !== -1) {
              _is_selected_brand = true;
              break;
            } else {
              _is_selected_brand = false;
            }
          }
          if (this.markers[i]["visible"] !== _is_selected_brand) {
            this.markers[i]["marker_point"].setVisible(_is_selected_brand);
          }
          this.markers[i]["visible"] = _is_selected_brand;
          _results.push(event_emitter.emitEvent('REFRESH_STORES', [i, _is_selected_brand]));
        } else {
          if (this.markers[i]["visible"] !== true) {
            this.markers[i]["marker_point"].setVisible(true);
            this.markers[i]["visible"] = true;
            _results.push(event_emitter.emitEvent('REFRESH_STORES', [i, true]));
          } else {
            _results.push(void 0);
          }
        }
      }
      return _results;
    };

    MapManager.prototype.checkActiveBrands = function(brand, is_active) {
      if (is_active) {
        this.active_brands.push(brand);
      } else {
        this.popItem(brand, this.active_brands);
      }
      event_emitter.emitEvent('CHECK_ALL_OPTION', [this.active_brands.length]);
      return this.checkBrands();
    };

    MapManager.prototype.popItem = function(item, array) {
      return array.splice($.inArray(item, array), 1);
    };

    MapManager.prototype.showAllMarkers = function() {
      this.active_brands = [];
      return this.checkBrands();
    };

    MapManager.prototype.hideAllMarkers = function() {
      var i, _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = this.markers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.markers[i]["marker_point"].setVisible(false);
        _results.push(this.markers[i]["visible"] = false);
      }
      return _results;
    };

    MapManager.prototype.openMarker = function(num) {
      return google.maps.event.trigger(this.markers[num]["marker_point"], 'click');
    };

    MapManager.prototype.showDirection = function(start, end, travelmode) {
      var request,
        _this = this;
      request = {
        origin: start,
        destination: end,
        travelMode: travelmode
      };
      return this.directionsService.route(request, function(response, status) {
        if (status === google.maps.DirectionsStatus.ZERO_RESULTS & travelmode === google.maps.DirectionsTravelMode.BICYCLING) {
          event_emitter.emitEvent('BICYCLE_MODE_ISNT_AVAILABLE');
        }
        if (status === google.maps.DirectionsStatus.OK) {
          _this.directionsDisplay.setDirections(response);
          _this.route = response.routes[0].legs[0];
          _this.startpoint = _this.route.steps[0].start_point;
          _this.endpoint = _this.route.steps[_this.route.steps.length - 1].end_point;
          _this.startMarker = new google.maps.Marker({
            position: _this.startpoint,
            map: _this.map,
            icon: _this.iconA
          });
          _this.stopMarker = new google.maps.Marker({
            position: _this.endpoint,
            map: _this.map,
            icon: _this.iconB
          });
          _this.hideAllMarkers();
          return _this.ib.close();
        }
      });
    };

    MapManager.prototype.cleanMap = function() {
      this.directionsDisplay.setDirections({
        routes: []
      });
      if (this.startMarker != null) {
        this.startMarker.setMap(null);
      }
      if (this.stopMarker != null) {
        this.stopMarker.setMap(null);
      }
      this.showAllMarkers();
      this.map.setZoom(this.zoom);
      return this.map.setCenter(this.pos);
    };

    MapManager.prototype.settingMapOptions = function() {
      this.zoom = this.map.getZoom();
      return this.pos = this.map.getCenter();
    };

    return MapManager;

  })();

}).call(this);
