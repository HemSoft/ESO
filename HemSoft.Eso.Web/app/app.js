var app;
(function (app) {
    angular
        .module("app", ["ngResource"])
        .constant("constants", (function () {
        return {
            apiUrl: "http://hemsoftesoapi.azurewebsites.net/api/",
            xxx: "johndoe"
        };
    })());
})(app || (app = {}));
//# sourceMappingURL=app.js.map