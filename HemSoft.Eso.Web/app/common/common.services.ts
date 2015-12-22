module App.Common {

    angular
        .module("common.services", ["ngResource"])
        .constant("constants", (() => {
            return {
                apiUrl: "http://hemsoftesoapi.azurewebsites.net/api/",
                xxx: "johndoe"
            }
        })());

}