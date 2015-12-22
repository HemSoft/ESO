module app {

    angular
        .module("app", ["ngResource"])
        .constant("constants", (() => {
            return {
                apiUrl: "http://hemsoftesoapi.azurewebsites.net/api/",
                xxx: "johndoe"
            }
        })());

}