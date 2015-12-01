esoapp.factory('AccountService', ['$http', function ($http)
{
    var AccountService = {};
    AccountService.getAccounts = function () {
        return $http.get('http://hemsoftesoapi.azurewebsites.net/api/Accounts');
    };
    return AccountService;
}]);