module App.Common {

    angular
        .module("common.services", ["ngResource"])
        .constant(
            "appSettings", {
                serverPath: "http://hemsoftesoapi.azurewebsites.net"
            }
        );

}