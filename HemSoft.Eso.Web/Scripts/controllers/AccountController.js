var esoapp = angular.module('esoapp', []);

esoapp.controller('AccountController', function ($scope, AccountService) {
    getAccounts();
    function getAccounts() {
        AccountService.getAccounts()
            .success(function(accts) {
                $scope.accounts = accts;
                console.log($scope.accounts);
            })
            .error(function (error) {
                $scope.status = 'Unable to load accounts data: ' + error.message;
                console.log($scope.status);
            });
    }
})