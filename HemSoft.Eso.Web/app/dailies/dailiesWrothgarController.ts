module App.DailiesWrothgar {

    interface IDailiesWrothgarViewModel {
        title: string;
        wrothgarStatus: any[];
        dataAccessService: App.Common.DataAccessService;
    }

    class DailiesWrothgarController implements IDailiesWrothgarViewModel {
        title: string;
        wrothgarStatus: any[];
        dataAccessService: App.Common.DataAccessService;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Wrothgar";
            this.dataAccessService = dataService;
            this.getWritStatus();
        }

        getWritStatus() {
            var res = this.dataAccessService.getWrothgarStatus();
            res.query((data: any[]) => {
                this.wrothgarStatus = data;
            });
        }
    }

    angular.module("app").controller("dailiesWrothgarController", DailiesWrothgarController);

}