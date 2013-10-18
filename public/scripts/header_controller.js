// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.HeaderController = (function() {
    function HeaderController(header) {
      this.header = header;
      this.setStoreConcept = __bind(this.setStoreConcept, this);
      this.is_mobile_version = false;
      this.header_navigation = this.header.find('.navigation-bar');
      this.concept_btn = this.header_navigation.find('a.store-concept');
      this.store_concept = $('.store-concept-preview');
      this.store_concept_close_btn = this.store_concept.find('a.close');
      this.setStoreConcept();
    }

    HeaderController.prototype.setStoreConcept = function() {
      var _this = this;
      this.right = -this.store_concept.width();
      this.store_concept.css('right', this.right);
      this.concept_btn.click(function(e) {
        var btn;
        e.preventDefault();
        btn = $(e.currentTarget);
        btn.toggleClass('active');
        if (btn.hasClass('active')) {
          return TweenLite.to(_this.store_concept, .5, {
            css: {
              'right': 0
            },
            easing: Expo.easeOut
          });
        } else {
          return TweenLite.to(_this.store_concept, .3, {
            css: {
              'right': _this.right
            },
            easing: Expo.easeIn
          });
        }
      });
      this.store_concept_close_btn.click(function(e) {
        e.preventDefault();
        return _this.concept_btn.click();
      });
      return this.store_concept.swipe({
        swipeRight: function(event, direction, distance, duration, fingerCount) {
          return _this.concept_btn.click();
        }
      });
    };

    return HeaderController;

  })();

}).call(this);
