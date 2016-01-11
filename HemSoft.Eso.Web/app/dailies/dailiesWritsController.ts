module App.DailiesWrits {

    interface IDailiesWritsViewModel {
        title: string;
        writs: any[];
        dataAccessService: App.Common.DataAccessService;
    }

    class DailiesWritsController implements IDailiesWritsViewModel {
        title: string;
        writs: any[];
        dataAccessService: App.Common.DataAccessService;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.getWritStatus();
        }

        getWritStatus() {
            var res = this.dataAccessService.getWritStatus();
            res.query((data: App.Domain.ICharacter[]) => {
                this.writs = data;
            });
        }
    }

    angular.module("app").controller("dailiesWritsController", DailiesWritsController);

}