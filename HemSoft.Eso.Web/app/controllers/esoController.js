(function () {

    angular.module('app').controller("esoController", function ($resource) {

        var vmeso = this;

        vmeso.accounts = $resource("http://hemsoftesoapi.azurewebsites.net/api/accounts/:id").query();
        vmeso.selectedAccount = null;
        vmeso.selectedCharacter = null;
        vmeso.charactersNeedingAttention = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharactersNeedingAttention").query();
        vmeso.characterResearch = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharacterResearch").query();
        vmeso.nextUpInResearchPromise = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetNextUpInResearch");
        vmeso.skillSortType = "Name";
        vmeso.skillSortReverse = false;
        vmeso.questSortType = "Completed";
        vmeso.questSortReverse = false;
        vmeso.nextUpInResearch = vmeso.nextUpInResearchPromise.get(function (resp) {
            vmeso.CountDown(resp);
        });

        vmeso.accountSelected = function (account) {
            vmeso.selectedAccount = account;
            vmeso.getCharactersForSelectedAccount();
        }

        vmeso.characterSelected = function (character) {
            vmeso.selectedCharacter = character;
            vmeso.getCharacterActivitiesForSelectedCharacter();
        }

        vmeso.getCharactersForSelectedAccount = function () {
            if (vmeso.selectedAccount !== null) {
                vmeso.characters =
                    $resource("http://hemsoftesoapi.azurewebsites.net/api/characters/GetCharactersByAccountId?accountId="
                        + this.selectedAccount.Id).query();
            }
        }

        vmeso.getCharacterActivitiesForSelectedCharacter = function () {
            if (this.selectedAccount !== null) {
                vmeso.characterActivities =
                    $resource("http://hemsoftesoapi.azurewebsites.net/api/CharacterActivities/GetCharacterActivitiesByCharacterId?characterId="
                        + vmeso.selectedCharacter.Id).query();
            }
        }

        vmeso.getCharactersNeedingAttention = function() {
            vmeso.charactersNeedingAttention = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharactersNeedingAttention").query();
        }

        vmeso.getCharacterActivityBagUsageString = function(characterActivity) {
            return characterActivity.UsedBagSlots + "/" + characterActivity.MaxBagSize;
        }

        vmeso.getCharacterActivityBankUsageString = function (characterActivity) {
            return characterActivity.UsedBankSlots + "/" + characterActivity.MaxBankSize;
        }

        vmeso.getCharacterSkills = function () {
            vmeso.characterSkills = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharacterSkills").query();
        }

        vmeso.getCharacterQuests = function () {
            vmeso.characterQuests = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharacterQuests").query();
        }

        vmeso.getNextUpInResearch = function () {
            vmeso.nextUpInResearch = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetNextUpInResearch").query();
        }

        vmeso.getSelectedAccountHeaderString = function () {
            if (vmeso.selectedAccount !== null) {
                return "Characters for " + vmeso.selectedAccount.Name + " account:";
            }
            return "";
        }

        vmeso.getSelectedCharacterHeaderString = function() {
            if (vmeso.selectedCharacter !== null) {
                return "Character activity for " + vmeso.selectedCharacter.Name;
            }
            return "";
        }

        vmeso.getCharacterActivityTimePlayed = function (characterActivity) {
            if (characterActivity !== undefined) {
                return (characterActivity.SecondsPlayed / 60 / 60) | 0;
            }
            return "";
        }

        vmeso.getOrsiniumStatus = function() {
            vmeso.orsiniumStatus = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetOrsiniumStatus").query();
        }

        vmeso.getWritStatus = function() {
            vmeso.writStatus = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetWritStatus").query();
        }

        vmeso.CountDown = function (nextUp) {
            if (nextUp === undefined) {
                return;
            }

            // set the date we're counting down to
            var target_date = new Date(nextUp.NextDue);

            // variables for time units
            var days, hours, minutes, seconds;

            // get tag element
            var countdown = document.getElementById('countdown');
            var counter = 0;

            // update the tag with id "countdown" every 1 second
            setInterval(function () {

                counter = counter + 1;

                // find the amount of "seconds" between now and target
                var current_date = new Date().getTime();
                var seconds_left = (target_date - current_date) / 1000;

                // do some time calculations
                days = parseInt(seconds_left / 86400);
                seconds_left = seconds_left % 86400;

                hours = parseInt(seconds_left / 3600);
                seconds_left = seconds_left % 3600;

                minutes = parseInt(seconds_left / 60);
                seconds = parseInt(seconds_left % 60);

                // format countdown string + set tag value
                countdown.innerHTML = '<span class="days">' + nextUp.CharacterName + ': ' + days + ' <b>Days</b></span> <span class="hours">' + hours + ' <b>Hours</b></span> <span class="minutes">'
                + minutes + ' <b>Minutes</b></span> <span class="seconds">' + seconds + ' <b>Seconds</b></span>';

                if (counter >= 60) {
                    counter = 0;

                    vmeso.nextUpInResearch = vmeso.nextUpInResearchPromise.get(function (resp) {
                        nextUp = resp;
                    });
                }

            }, 1000);
        }
});


})();