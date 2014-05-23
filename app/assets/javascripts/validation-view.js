App.ValidationView = Ember.View.extend(Ember.TargetActionSupport, {
  previousErrors: [],
  resetErrors: function() {
    return this.get('previousErrors').forEach((function(_this) {
      return function(error) {
        _this.set(error + 'Validation', null);
        return $('#' + error + 'Input').removeClass('has-error');
      };
    })(this));
  },
  actions: {
    cancel: function(object) {
      if (object.get('isNew')) {
        object.deleteRecord();
      } else {
        object.rollback();
      }
      return this.resetErrors();
    },
    validate: function() {
      var attrs, controller, object, relationships;
      if (!this.get('validationObject')) {
        this.set('validationObject', this.get('controller.content'));
      }
      this.resetErrors();
      controller = this;
      relationships = Ember.get(this.get('validationObject.constructor'), 'relationshipNames');
      object = String(this.get('validationObject.constructor'));
      object = object.split('.');
      object = Ember.String.capitalize(object.pop()).underscore();
      attrs = {};
      attrs[object] = this.get('validationObject._attributes');
      this.get('validationObject').eachAttribute((function(_this) {
        return function(att) {
          if (!_this.get('validationObject.excludedProperties').contains(att)) {
            return attrs[object][att] = _this.get('validationObject').get(att);
          }
        };
      })(this));
      relationships.belongsTo.forEach((function(_this) {
        return function(relationship) {
          if (_this.get('validationObject').get(relationship)) {
            return attrs[object][relationship + '_id'] = _this.get('validationObject').get(relationship).get('id');
          }
        };
      })(this));
      relationships.hasMany.forEach((function(_this) {
        return function(relationship) {
          var relationshipArray;
          relationshipArray = [];
          _this.get('validationObject').get(relationship).forEach(function(related) {
            return relationshipArray.push(related.get('id'));
          });
          return attrs[object][relationship.singularize() + '_ids'] = relationshipArray;
        };
      })(this));
      if (attrs[object][Ember.keys(attrs[object]).get('firstObject')] === void 0) {
        attrs[object][Ember.keys(attrs[object]).get('firstObject')] = null;
      }
      if (this.get('validationObject.id') !== null) {
        attrs[object]['id'] = this.get('validationObject').get('id');
      }
      return Ember.$.post('/validate.json', attrs).then(function(data) {
        controller.set('content', attrs);
        return controller.triggerAction({
          action: "save",
          target: controller.get("controller")
        });
      }, function(error) {
        var errorsHash;
        controller.set('previousErrors', []);
        errorsHash = JSON.parse(error.responseText);
        if (_.difference(Ember.keys(errorsHash), controller.get('validationObject.excludedProperties')).length === 0) {
          controller.set('content', attrs);
          return controller.triggerAction({
            action: "save",
            target: controller.get("controller")
          });
        } else {
          return Ember.keys(errorsHash).forEach(function(key) {
            controller.get('previousErrors').push(key);
            if ($('div[id^=' + key + 'Input')) {
              $('div[id^=' + key + 'Input').addClass('has-error');
            }
            error = errorsHash[key].join(', ');
            return controller.set(key + 'Validation', error);
          });
        }
      });
    }
  }
});