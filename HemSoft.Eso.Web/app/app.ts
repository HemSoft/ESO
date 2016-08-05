module App {

    var app = angular
        .module("app",
        [
            "ngResource",
            "ngRoute",
            "common.services"
        ]);

    app.config(routeConfig);

    routeConfig.$inject = ["$routeProvider"];
    function routeConfig($routeProvider: ng.route.IRouteProvider): void {

        $routeProvider
            .when("/Home/Index",
            {
                templateUrl: "/app/accounts/accountListView.html",
                controller: "accountController as vmac"
            })
            .otherwise("/Home/Index");
    }

}