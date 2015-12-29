module App.Eso {

    angular.module("app").controller("esoController", function($resource) {

        var vmeso = this;

        vmeso.selectedCharacter = null;
        //vmeso.charactersNeedingAttention = $resource(constants.apiUrl + "Characters/GetCharactersNeedingAttention").query();
        //vmeso.characterResearch = $resource(constants.apiUrl + "Characters/GetCharacterResearch").query();
        vmeso.nextUpInResearchPromise = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetNextUpInResearch");
        vmeso.skillSortType = "Name";
        vmeso.skillSortReverse = false;
        vmeso.questSortType = "Completed";
        vmeso.questSortReverse = false;
        vmeso.nextUpInResearch = vmeso.nextUpInResearchPromise.get(resp => {
            this.CountDown(resp);
        });

        vmeso.accountSelected = account => {
            this.selectedAccount = account;
            this.selectedCharacter = null;
            this.getCharactersForSelectedAccount();
        }

        vmeso.characterSelected = character => {
            this.selectedCharacter = character;
            this.getCharacterActivitiesForSelectedCharacter();
        }

        vmeso.getCharactersForSelectedAccount = function() {
            if (vmeso.selectedAccount !== null) {
                //vmeso.characters =
                //    $resource(constants.apiUrl + "Characters/GetCharactersByAccountId?accountId="
                //        + this.selectedAccount.Id).query();
            }
        }

        vmeso.getCharacterActivitiesForSelectedCharacter = function() {
            if (this.selectedAccount !== null) {
                //vmeso.characterActivities =
                //    $resource(constants.apiUrl + "CharacterActivities/GetCharacterActivitiesByCharacterId?characterId="
                //        + vmeso.selectedCharacter.Id).query();
            }
        }

        vmeso.getCharactersNeedingAttention = function() {
            //vmeso.charactersNeedingAttention = $resource(constants.apiUrl + "Characters/GetCharactersNeedingAttention").query();
        }

        vmeso.getCharacterActivityBagUsageString = characterActivity => (characterActivity.UsedBagSlots + "/" + characterActivity.MaxBagSize)

        vmeso.getCharacterActivityBankUsageString = characterActivity => (characterActivity.UsedBankSlots + "/" + characterActivity.MaxBankSize)

        vmeso.getCharacterSkills = () => {
            //this.characterSkills = $resource(constants.apiUrl + "Characters/GetCharacterSkills").query();
        }

        vmeso.getCharacterQuests = () => {
            //this.characterQuests = $resource(constants.apiUrl + "Characters/GetCharacterQuests").query();
        }

        vmeso.getNextUpInResearch = () => {
            this.nextUpInResearch = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetNextUpInResearch").query();
        }

        vmeso.getSelectedAccountHeaderString = () => {
            if (this.selectedAccount !== null) {
                return `Characters for ${this.selectedAccount.Name} account:`;
            }
            return "";
        }

        vmeso.getSelectedCharacterHeaderString = () => {
            if (this.selectedCharacter !== null) {
                return `Character activity for ${this.selectedCharacter.Name}`;
            }
            return "";
        }

        vmeso.getCharacterActivityTimePlayed = characterActivity => {
            if (characterActivity !== undefined && characterActivity !== null) {
                return (characterActivity.SecondsPlayed / 60 / 60) | 0;
            }
            return -1;
        }

        vmeso.getOrsiniumStatus = () => {
            //this.orsiniumStatus = $resource(constants.apiUrl + "Characters/GetOrsiniumStatus").query();
        }

        vmeso.getWritStatus = () => {
            //this.writStatus = $resource(constants.apiUrl + "Characters/GetWritStatus").query();
        }

        vmeso.CountDown = nextUp => {
            if (nextUp === undefined || nextUp === null) {
                return;
            }

            // set the date we're counting down to
            var targetDate = new Date(nextUp.NextDue);

            // variables for time units
            var days: number, hours: number, minutes: number, seconds: number;

            // get tag element
            var countdown = document.getElementById("countdown");
            var counter = 0;

            // update the tag with id "countdown" every 1 second
            setInterval(function() {

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
                countdown.innerHTML = `<span class="days">${nextUp.CharacterName}: ${days} <b>Days</b></span> <span class="hours">${hours} <b>Hours</b></span> <span class="minutes">${minutes} <b>Minutes</b></span> <span class="seconds">${seconds} <b>Seconds</b></span>`;

                if (counter >= 60) {
                    counter = 0;

                    if (this.nextUpInResearchPromise !== undefined && this.nextUpInResearch !== null) {
                        this.nextUpInResearch = this.nextUpInResearchPromise.get(resp => {
                            nextUp = resp;
                        });
                    }
                }

            }, 1000);
        }
    });
}