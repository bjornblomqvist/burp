// Adding missing restful verbs (put,delete)
(function() {
  function _ajax_request(url, data, callback, type, method) {
      if (jQuery.isFunction(data)) {
          callback = data;
          data = {};
      }
      data = data || {};
      data['_method'] = method;
      
      return jQuery.ajax({
          type: 'post',
          url: url,
          data: data,
          success: callback,
          dataType: type
        });
  }
  
  var delete_ = function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'delete');
  };

  jQuery.extend({
      put: function(url, data, callback, type) {
          return _ajax_request(url, data, callback, type, 'put');
      },
      delete_: delete_,
      remove:delete_,
      _delete:delete_,
      destroy:delete_,
      postTo: function(url, parameters) {
        var form = $('<form method="post" action="' + url + '"></form>');
        var key;
        for (key in parameters) {
          var field = $('<input type="hidden" />');
          field.attr('name', key);
          field.attr('value', parameters[key]);
          form.append(field);
        }

        $('body').append(form);
        form.submit();
      }
  });
}());