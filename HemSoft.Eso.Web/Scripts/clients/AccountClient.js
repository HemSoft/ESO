var esoapp = angular.module('esoapp', []);
esoapp.controller('AccountController', function ($scope, AccountService) {

    getAccounts();
    function getAccounts() {
        AccountService.getAccounts()
            .success(function (accts) {
                $scope.Accounts = accts;
                console.log($scope.Accounts);
            })
            .error(function (error) {
                $scope.status = 'Unable to load accounts: ' + error.message;
                console.log($scope.status);
            });
    }
});

esoapp.factory('AccountService', ['$http', function ($http) {

    var AccountService = {};
    AccountService.getAccounts = function () {
        return $http.get('/api/Accounts');
    };
    return AccountService;

}]);