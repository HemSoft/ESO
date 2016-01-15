var App;
(function (App) {
    var Common;
    (function (Common) {
        angular
            .module("common.services", ["ngResource"])
            .constant("appSettings", {
            serverPath: "http://hemsoftesoapi.azurewebsites.net"
        });
    })(Common = App.Common || (App.Common = {}));
})(App || (App = {}));
