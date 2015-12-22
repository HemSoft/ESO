var app;
(function (app) {
    var eso;
    (function (eso) {
        angular.module("app").controller("esoController", function ($resource, constants) {
            var _this = this;
            var vmeso = this;
            vmeso.accounts = $resource(constants.apiUrl + "Accounts/:id").query();
            vmeso.selectedAccount = null;
            vmeso.selectedCharacter = null;
            vmeso.charactersNeedingAttention = $resource(constants.apiUrl + "Characters/GetCharactersNeedingAttention").query();
            vmeso.characterResearch = $resource(constants.apiUrl + "Characters/GetCharacterResearch").query();
            vmeso.nextUpInResearchPromise = $resource(constants.apiUrl + "Characters/GetNextUpInResearch");
            vmeso.skillSortType = "Name";
            vmeso.skillSortReverse = false;
            vmeso.questSortType = "Completed";
            vmeso.questSortReverse = false;
            vmeso.nextUpInResearch = vmeso.nextUpInResearchPromise.get(function (resp) {
                _this.CountDown(resp);
            });
            vmeso.accountSelected = function (account) {
                _this.selectedAccount = account;
                _this.selectedCharacter = null;
                _this.getCharactersForSelectedAccount();
            };
            vmeso.characterSelected = function (character) {
                _this.selectedCharacter = character;
                _this.getCharacterActivitiesForSelectedCharacter();
            };
            vmeso.getCharactersForSelectedAccount = function () {
                if (vmeso.selectedAccount !== null) {
                    vmeso.characters =
                        $resource(constants.apiUrl + "Characters/GetCharactersByAccountId?accountId="
                            + this.selectedAccount.Id).query();
                }
            };
            vmeso.getCharacterActivitiesForSelectedCharacter = function () {
                if (this.selectedAccount !== null) {
                    vmeso.characterActivities =
                        $resource(constants.apiUrl + "CharacterActivities/GetCharacterActivitiesByCharacterId?characterId="
                            + vmeso.selectedCharacter.Id).query();
                }
            };
            vmeso.getCharactersNeedingAttention = function () {
                vmeso.charactersNeedingAttention = $resource(constants.apiUrl + "Characters/GetCharactersNeedingAttention").query();
            };
            vmeso.getCharacterActivityBagUsageString = function (characterActivity) { return (characterActivity.UsedBagSlots + "/" + characterActivity.MaxBagSize); };
            vmeso.getCharacterActivityBankUsageString = function (characterActivity) { return (characterActivity.UsedBankSlots + "/" + characterActivity.MaxBankSize); };
            vmeso.getCharacterSkills = function () {
                _this.characterSkills = $resource(constants.apiUrl + "Characters/GetCharacterSkills").query();
            };
            vmeso.getCharacterQuests = function () {
                _this.characterQuests = $resource(constants.apiUrl + "Characters/GetCharacterQuests").query();
            };
            vmeso.getNextUpInResearch = function () {
                _this.nextUpInResearch = $resource(constants.apiUrl + "Characters/GetNextUpInResearch").query();
            };
            vmeso.getSelectedAccountHeaderString = function () {
                if (_this.selectedAccount !== null) {
                    return "Characters for " + _this.selectedAccount.Name + " account:";
                }
                return "";
            };
            vmeso.getSelectedCharacterHeaderString = function () {
                if (_this.selectedCharacter !== null) {
                    return "Character activity for " + _this.selectedCharacter.Name;
                }
                return "";
            };
            vmeso.getCharacterActivityTimePlayed = function (characterActivity) {
                if (characterActivity !== undefined && characterActivity !== null) {
                    return (characterActivity.SecondsPlayed / 60 / 60) | 0;
                }
                return -1;
            };
            vmeso.getOrsiniumStatus = function () {
                _this.orsiniumStatus = $resource(constants.apiUrl + "Characters/GetOrsiniumStatus").query();
            };
            vmeso.getWritStatus = function () {
                _this.writStatus = $resource(constants.apiUrl + "Characters/GetWritStatus").query();
            };
            vmeso.CountDown = function (nextUp) {
                if (nextUp === undefined || nextUp === null) {
                    return;
                }
                // set the date we're counting down to
                var targetDate = new Date(nextUp.NextDue);
                // variables for time units
                var days, hours, minutes, seconds;
                // get tag element
                var countdown = document.getElementById("countdown");
                var counter = 0;
                // update the tag with id "countdown" every 1 second
                setInterval(function () {
                    counter = counter + 1;
                    // find the amount of "seconds" between now and target
                    var currentDate = new Date().getTime();
                    var secondsLeft = (targetDate.valueOf() - currentDate.valueOf()) / 1000;
                    // do some time calculations
                    days = Math.floor(secondsLeft / 86400);
                    secondsLeft = secondsLeft % 86400;
                    hours = Math.floor(secondsLeft / 3600);
                    secondsLeft = secondsLeft % 3600;
                    minutes = Math.floor(secondsLeft / 60);
                    seconds = Math.floor(secondsLeft % 60);
                    // format countdown string + set tag value
                    countdown.innerHTML = "<span class=\"days\">" + nextUp.CharacterName + ": " + days + " <b>Days</b></span> <span class=\"hours\">" + hours + " <b>Hours</b></span> <span class=\"minutes\">" + minutes + " <b>Minutes</b></span> <span class=\"seconds\">" + seconds + " <b>Seconds</b></span>";
                    if (counter >= 60) {
                        counter = 0;
                        this.nextUpInResearch = this.nextUpInResearchPromise.get(function (resp) {
                            nextUp = resp;
                        });
                    }
                }, 1000);
            };
        });
    })(eso = app.eso || (app.eso = {}));
})(app || (app = {}));
//# sourceMappingURL=esoController.js.map