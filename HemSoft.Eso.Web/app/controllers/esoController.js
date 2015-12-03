// Works:
//esoApp.controller("accountController", function ($scope, $http) {
//    $scope.title = "Test Title";
//    $http.get("http://localhost:53807/api/accounts").then(function (response) {
//        $scope.accounts = response.data;
//    });
//});

esoApp.controller("esoController", function ($scope, $resource) {
    //$scope.accounts = $resource("http://localhost:53807/api/accounts/:id").query();
    $scope.accounts = $resource("http://hemsoftesoapi.azurewebsites.net/api/accounts/:id").query();
    $scope.selectedAccount = null;

    $scope.accountSelected = function() {
        $scope.selectedAccount = this.account;
        $scope.getCharactersForSelectedAccount();
    }

    $scope.getCharactersForSelectedAccount = function () {
        if (this.selectedAccount !== null) {
            $scope.characters =
                $resource("http://localhost:53807/api/characters/GetCharactersByAccountId?accountId="
                    + this.selectedAccount.Id).query();
        }
    }
});




//angular.module("esoApp").controller("AccountController", ["AccountResource", AccountController]);

//function AccountController(AccountResource) {
//    AccountResource.query(function(data) {
//        this.accounts = data;
//    });
//}