(function () {
  var module = angular.module("payment-intent-module", []);

  module.controller("PaymentIntentController", [
    "$http",
    "$scope",
    "$compile",
    "$rootScope",
    function ($http, $scope, $compile, $rootScope) {
      var self = this;
      this.id = null;
      this.gateway = null;
      this.data = null;

      this.tmp_selected_amount = 0;
      this.selected_amount = ["full", 0];
      this.amount = null;
      this.min_amount = null;
      

      this.init = (token, gateway, data, amount, min_amount) => {
        
        this.token = token;
        this.gateway = gateway;
        this.data = data;
        this.amount = amount;
        this.min_amount = min_amount;
        this.selectFullAmount()

      };

      this.selectFullAmount = () => {
        this.selected_amount = ["full", this.amount];
        this.tmp_selected_amount = this.amount / 100
      }

      this.isFullAmount = () => {
        return this.selected_amount[0] == "full" 
      }

      this.selectMinAmount = () => {
        this.selected_amount = ["min", this.min_amount];
        this.tmp_selected_amount = this.amount / 100
      }

      this.isMinAmount = () => {
        return this.selected_amount[0] == "min" 
      }

      this.selectOtherAmount = () => {
        this.selected_amount = ["other", this.amount];
        this.tmp_selected_amount = this.amount / 100
        setTimeout(() => {
          M.updateTextFields();
        }, 100)
      }

      this.isOtherAmount = () => {
        return this.selected_amount[0] == "other" 
      }

      this.onUpdateOtherAmount = () => {
        this.selected_amount[1] = this.tmp_selected_amount * 100
      }

      this.pay = (params) => {
        if (this.gateway == "wompi") {
          const checkout = new WidgetCheckout(params);
          checkout.open((result) => {
            const transaction = result.transaction;
            console.log("Transaction ID: ", transaction.id);
            console.log("Transaction object: ", transaction);
            window.location.href = `/payment_intents/${self.token}`
          });
        } else if (this.gateway == "epayco") {
          const checkout = ePayco.checkout.configure({
            key: this.data.key,
            test: this.data.testing,
          });

          checkout.open(params);
        }
      };

      this.update = () => {
        var params = {
          amount: this.selected_amount[1],
        };

        $http.put(`/api/v1/payment_intents/${this.token}.json`, params).then(
          function (res, status) {
            self.pay(res.data);
          },
          function (res, status) {}
        );
      };
    },
  ]);
})();
