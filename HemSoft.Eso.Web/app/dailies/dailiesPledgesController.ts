module App.DailiesPledges {

    interface IDailiesPledgesViewModel {
        title: string;
        pledges: any[];
        dataAccessService: App.Common.DataAccessService;
    }

    class DailiesPledgesController implements IDailiesPledgesViewModel {
        title: string;
        pledges: any[];
        dataAccessService: App.Common.DataAccessService;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.getPledgeStatus();
        }

        getPledgeStatus() {
            var res = this.dataAccessService.getPledgeStatus();
            res.query((data: App.Domain.ICharacter[]) => {
                this.pledges = data;
            });
        }
    }

    angular.module("app").controller("dailiesPledgesController", DailiesPledgesController);

}