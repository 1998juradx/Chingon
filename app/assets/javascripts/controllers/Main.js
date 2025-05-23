var App = {
  auth: {
    uuid: null,
    token: null
  },
  setUserData: function(key, value){
    localStorage.setItem(key, value);
  },
  getUserData: function(key){
    return localStorage.getItem(key);
  },
  removeUserData: function(key){
    localStorage.removeItem(key);
  },
  init: function(uuid, token){
    App.auth.uuid = uuid;
    App.auth.token = token;

    var module = angular.module('app', ['payment-intent-module']);

    document.addEventListener("DOMContentLoaded", function() {
      var element = angular.element(document.querySelector('body'));

      var isInitialized = element.injector();
      if (!isInitialized) {
        angular.bootstrap(document.body, ['app'])
      }
    });

    module.directive('onLastRepeat', function() {
      return function(scope, element, attrs) {
        if (scope.$last) setTimeout(function(){
          scope.$emit('onRepeatLast', element, attrs);
        }, 1);
      };
    });


    module.directive("ngOnload", function () {
      return {
        restrict: "A",
        scope: {
          callback: "&ngOnload"
        },
        link: function(scope, element, attrs){
          element.on("load", function(event){
            scope.callback({ event: event });
          });
        }
      };
    });

    module.directive("inputCurrency", ["$locale","$filter", function ($locale, $filter) {

      // For input validation
      var isValid = function(val) {
        return angular.isNumber(val) && !isNaN(val);
      };

      // Helper for creating RegExp's
      var toRegExp = function(val) {
        var escaped = val.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
        return new RegExp(escaped, 'g');
      };

      // Saved to your $scope/model
      var toModel = function(val) {

        // Locale currency support
        var decimal = toRegExp($locale.NUMBER_FORMATS.DECIMAL_SEP);
        var group = toRegExp($locale.NUMBER_FORMATS.GROUP_SEP);
        var currency = toRegExp($locale.NUMBER_FORMATS.CURRENCY_SYM);

        // Strip currency related characters from string
        val = val.replace(decimal, '').replace(group, '').replace(currency, '').trim();

        return parseInt(val, 10);
      };

      // Displayed in the input to users
      var toView = function(val) {
        return $filter('currency')(val, '$', 0);
      };

      // Link to DOM
      var link = function($scope, $element, $attrs, $ngModel) {
        $ngModel.$formatters.push(toView);
        $ngModel.$parsers.push(toModel);
        $ngModel.$validators.currency = isValid;

        $element.on('keyup', function() {
          $ngModel.$viewValue = toView($ngModel.$modelValue);
          $ngModel.$render();
        });
      };

      return {
        restrict: 'A',
        require: 'ngModel',
        link: link
      };
    }]);

    module.directive("ngFileSelect", function(fileReader, $timeout) {
      return {
        scope: {
          ngModel: '='
        },
        link: function($scope, el) {
          function getFile(file) {
            fileReader.readAsDataUrl(file, $scope)
            .then(function(result) {
              $timeout(function() {
                $scope.ngModel = result;
              });
            });
          }

          el.bind("change", function(e) {
            var file = (e.srcElement || e.target).files[0];
            getFile(file);
          });
        }
      };
    });

    module.filter('pagination', function(){
      return function(input, start)
      {
        start = +start;
        return input.slice(start);
      };
    });

    module.filter('ceil', function () {
      return function (value) {
        return Math.ceil(value);
      };
    })

    module.filter('parseInt', function() {
      return function(number) {
        if(!number) {
          return false;
        }
        return parseInt(number , 10);
      };
    })

    module.filter('myCurrency', ['$filter', function ($filter) {
      return function(input) {
        input = parseFloat(input);

        input = input.toFixed(0);
        // if(input % 1 === 0) {
          // input = input.toFixed(0);
        // }
        // else {
        //   input = input.toFixed(2);
        // }

        return '$' + input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      };
    }]);

    module.factory("fileReader", function($q, $log) {
      var onLoad = function(reader, deferred, scope) {
        return function() {
          scope.$evalAsync(function() {
            deferred.resolve(reader.result);
          });
        };
      };

      var onError = function(reader, deferred, scope) {
        return function() {
          scope.$evalAsync(function() {
            deferred.reject(reader.result);
          });
        };
      };

      var onProgress = function(reader, scope) {
        return function(event) {
          scope.$broadcast("fileProgress", {
            total: event.total,
            loaded: event.loaded
          });
        };
      };

      var getReader = function(deferred, scope) {
        var reader = new FileReader();
        reader.onload = onLoad(reader, deferred, scope);
        reader.onerror = onError(reader, deferred, scope);
        reader.onprogress = onProgress(reader, scope);
        return reader;
      };

      var readAsDataURL = function(file, scope) {
        var deferred = $q.defer();

        var reader = getReader(deferred, scope);
        reader.readAsDataURL(file);

        return deferred.promise;
      };

      return {
        readAsDataUrl: readAsDataURL
      };
    });

  }
}
