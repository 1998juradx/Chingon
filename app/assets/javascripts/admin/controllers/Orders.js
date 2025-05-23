(function () {
  var module = angular.module("orders-module", []);

  module.controller("OrdersController", [
    "$http",
    "$scope",
    "$compile",
    "$rootScope",
    function ($http, $scope, $compile, $rootScope) {
      var self = this;
      this.cable = null;
      this.channel = null;
      this.messageBody = "";
      
      this.init = function (funnelId) {
        console.log("INIT 2FA");
      }


      this.onFetch = function(){
        const params = {
          ...App.auth,
        }
      
        // Send an AJAX request to update the node's position
        $http.get(`/api/v1/messages.json`, {params}).then(function (response) {
          
          self.chats = response.data.data

        });
      }
    }
  ]);
})();
