 // Works:
//esoApp.controller("accountController", function ($scope, $http) {
//    $scope.title = "Test Title";
//    $http.get("http://localhost:53807/api/accounts").then(function (response) {
//        $scope.accounts = response.data;
//    });
//});

esoApp.controller("accountController", function ($scope, $resource) {
    $scope.title = "Test Title";
    //$scope.accounts = $resource("http://localhost:53807/api/accounts/:id").query();
    $scope.accounts = $resource("http://hemsoftesoapi.azurewebsites.net/api/accounts/:id").query();
});




//angular.module("esoApp").controller("AccountController", ["AccountResource", AccountController]);

//function AccountController(AccountResource) {
//    AccountResource.query(function(data) {
//        this.accounts = data;
//    });
//}