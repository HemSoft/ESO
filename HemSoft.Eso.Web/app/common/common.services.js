var App;
(function (App) {
    var Common;
    (function (Common) {
        angular
            .module("common.services", ["ngResource"])
            .constant("constants", (function () {
            return {
                apiUrl: "http://hemsoftesoapi.azurewebsites.net/api/",
                xxx: "johndoe"
            };
        })());
    })(Common = App.Common || (App.Common = {}));
})(App || (App = {}));
//# sourceMappingURL=common.services.js.map