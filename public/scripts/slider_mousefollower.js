// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.SliderMouseFollower = (function() {
    function SliderMouseFollower(ref, start_id) {
      this.ref = ref;
      this.start_id = start_id != null ? start_id : "";
      this.onResize = __bind(this.onResize, this);
      this.updatePosition = __bind(this.updatePosition, this);
      this.onMouseMove = __bind(this.onMouseMove, this);
      this.updateThumbsById = __bind(this.updateThumbsById, this);
      this.onThumbClick = __bind(this.onThumbClick, this);
      this.onThumbTouchStart = __bind(this.onThumbTouchStart, this);
      this.is_ie = $.browser.msie;
      this.is_mobile = navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/Android/i) ? true : false;
      this.is_android = navigator.userAgent.match(/Android/i) ? true : false;
      this.doc = $(document);
      this.w = $(window);
      this.holder = this.ref.find('.thumb-list');
      this.loaded = 0;
      this.thumbs = this.holder.find('.thumb');
      this.thumbs_array = this.thumbs;
      this.current_thumb = null;
      this.fps = 30;
      this.w_width = 0;
      this.ref_height = this.ref.height();
      this.holder_width = 0;
      this.thumb_width = 0;
      this.target_vel_min = 2;
      this.target_vel_max = 30;
      this.vel_min = 0;
      this.vel_max = 0;
      this.dur = 1.2;
      this.is_mouse_over = false;
      this.is_updating = false;
      this.onResize();
      this.setHolderWidth();
      if (!this.is_mobile) {
        this.w.resize(this.onResize);
      }
      if (this.is_mobile) {
        this.holder.attr('data-scrollable', 'x');
        new EasyScroller(this.holder[0], {
          scrollingX: true,
          scrollingY: false,
          zooming: false
        });
      } else {
        this.startUpdating();
      }
      this.updateThumbsById(this.start_id);
      this.setInteractions();
    }

    SliderMouseFollower.prototype.setInteractions = function() {
      var i, thumb, thumb_link, _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = this.thumbs.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        thumb = $(this.thumbs[i]);
        thumb_link = thumb.find('.thumb-link');
        if (this.is_mobile) {
          thumb_link.bind('touchstart', this.onThumbTouchStart);
          _results.push(thumb_link.bind('touchend', this.onThumbClick));
        } else {
          _results.push(thumb_link.bind('click', this.onThumbClick));
        }
      }
      return _results;
    };

    SliderMouseFollower.prototype.onThumbTouchStart = function(e) {
      if (this.is_android) {
        this.touch = e.originalEvent.changedTouches[0];
      } else {
        this.touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
      }
      return this.touch_start = this.touch.pageX;
    };

    SliderMouseFollower.prototype.onThumbClick = function(e) {
      var thumb;
      e.preventDefault();
      if (this.is_mobile) {
        if (this.is_android) {
          this.touch = e.originalEvent.changedTouches[0];
        }
        if (Math.abs(this.touch.pageX - this.touch_start) > 0) {
          return;
        }
      }
      thumb = $(e.currentTarget).parent();
      return this.triggerByThumb(thumb);
    };

    SliderMouseFollower.prototype.triggerByThumb = function(thumb) {
      var id;
      if (!thumb.hasClass('disabled')) {
        id = thumb.attr('data-id');
        this.updateThumbsById(id);
        return event_emitter.emitEvent('THUMB_CLICK', [id]);
      }
    };

    SliderMouseFollower.prototype.updateThumbsById = function(id) {
      var thumb;
      thumb = $(this.thumbs[this.getIndexById(id)]);
      if ((this.current_thumb != null) && thumb !== this.current_thumb) {
        this.current_thumb.removeClass('disabled');
        this.current_thumb = null;
      }
      if (this.current_thumb === null) {
        this.current_thumb = thumb;
        return this.current_thumb.addClass('disabled');
      }
    };

    SliderMouseFollower.prototype.setWrapperWidth = function() {
      return this.w_width = this.ref.width();
    };

    SliderMouseFollower.prototype.setHolderWidth = function() {
      var thumb;
      thumb = $(this.thumbs[0]);
      this.thumb_width = parseInt(thumb.css('width'));
      this.holder_width = this.thumbs.length * this.thumb_width;
      return this.holder.css({
        width: "" + this.holder_width + "px"
      });
    };

    SliderMouseFollower.prototype.startUpdating = function() {
      if (!this.is_mobile) {
        if (this.is_ie) {
          this.doc.bind('mousemove', this.onMouseMove);
        } else {
          this.w.bind('mousemove', this.onMouseMove);
        }
        this.is_updating = true;
        return this.setUpdateTimeout();
      }
    };

    SliderMouseFollower.prototype.stopUpdating = function() {
      if (!this.is_mobile) {
        if (this.is_ie) {
          this.doc.unbind('mousemove', this.onMouseMove);
        } else {
          this.w.unbind('mousemove');
        }
        return this.is_updating = false;
      }
    };

    SliderMouseFollower.prototype.onMouseMove = function(e) {
      if (this.is_ie) {
        this.mouseX = e.clientX;
        return this.mouseY = e.clientY;
      } else {
        this.mouseX = e.pageX;
        return this.mouseY = e.pageY;
      }
    };

    SliderMouseFollower.prototype.setUpdateTimeout = function() {
      return this.update_timeout = window.setTimeout(this.updatePosition, 1000 / this.fps);
    };

    SliderMouseFollower.prototype.clearUpdateTimeout = function() {
      return window.clearTimeout(this.update_timeout);
    };

    SliderMouseFollower.prototype.updatePosition = function() {
      var bounded_left, current_amp, current_left, current_vel, posX, scroll_offset, updated_left, _ref;
      this.clearUpdateTimeout();
      posX = 2 * (((this.mouseX - (this.w.width() - this.w_width)) / this.w_width) - .5);
      current_left = this.holder.position().left;
      current_amp = Math.max(0, parseInt(this.holder_width - this.w_width));
      current_vel = this.vel_min + (1 - Math.abs(2 * ((Math.abs(current_left) / current_amp) - .5))) * this.vel_max;
      updated_left = current_left - posX * current_vel;
      bounded_left = Math.max(-current_amp, Math.min(0, updated_left));
      this.holder.css({
        left: bounded_left
      });
      if (this.is_updating) {
        this.setUpdateTimeout();
      }
      scroll_offset = this.is_ie ? this.w.scrollTop() : 0;
      if ((this.ref.offset().top <= (_ref = this.mouseY + scroll_offset) && _ref <= this.ref.offset().top + this.ref_height)) {
        if (!this.is_mouse_over) {
          this.is_mouse_over = true;
          TweenLite.to(this, this.dur, {
            vel_min: this.target_vel_min,
            ease: Power4.easeInOut
          });
          return TweenLite.to(this, this.dur, {
            vel_max: this.target_vel_max,
            ease: Power4.easeInOut
          });
        }
      } else {
        if (this.is_mouse_over) {
          this.is_mouse_over = false;
          TweenLite.to(this, this.dur, {
            vel_min: 0,
            ease: Power4.easeInOut
          });
          return TweenLite.to(this, this.dur, {
            vel_max: 0,
            ease: Power4.easeInOut
          });
        }
      }
    };

    SliderMouseFollower.prototype.onResize = function() {
      return this.setWrapperWidth();
    };

    SliderMouseFollower.prototype.getIndexById = function(id) {
      var el, i, index, _i, _id, _ref;
      index = 0;
      for (i = _i = 0, _ref = this.thumbs_array.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        el = $(this.thumbs_array[i]);
        _id = el.attr('data-id');
        if (_id === id) {
          index = i;
          break;
        }
      }
      return index;
    };

    return SliderMouseFollower;

  })();

}).call(this);
