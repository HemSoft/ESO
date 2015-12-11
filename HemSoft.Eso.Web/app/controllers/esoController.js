esoApp.controller("esoController", function ($scope, $resource) {
    $scope.accounts = $resource("http://hemsoftesoapi.azurewebsites.net/api/accounts/:id").query();
    $scope.selectedAccount = null;
    $scope.selectedCharacter = null;
    $scope.charactersNeedingAttention = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharactersNeedingAttention").query();
    $scope.characterResearch = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharacterResearch").query();
    $scope.nextUpInResearchPromise = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetNextUpInResearch");
    $scope.skillSortType = 'Name';
    $scope.skillSortReverse = false;
    $scope.nextUpInResearch = $scope.nextUpInResearchPromise.get(function(resp) {
        $scope.CountDown(resp);
    });

    $scope.accountSelected = function () {
        $scope.selectedAccount = this.account;
        $scope.getCharactersForSelectedAccount();
    }

    $scope.characterSelected = function () {
        $scope.selectedCharacter = this.character;
        $scope.getCharacterActivitiesForSelectedCharacter();
    }

    $scope.getCharactersForSelectedAccount = function () {
        if (this.selectedAccount !== null) {
            $scope.characters =
                $resource("http://hemsoftesoapi.azurewebsites.net/api/characters/GetCharactersByAccountId?accountId="
                    + $scope.selectedAccount.Id).query();
        }
    }

    $scope.getCharacterActivitiesForSelectedCharacter = function () {
        if (this.selectedAccount !== null) {
            $scope.characterActivities =
                $resource("http://hemsoftesoapi.azurewebsites.net/api/CharacterActivities/GetCharacterActivitiesByCharacterId?characterId="
                    + $scope.selectedCharacter.Id).query();
        }
    }

    $scope.getCharactersNeedingAttention = function() {
        $scope.charactersNeedingAttention = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharactersNeedingAttention").query();
    }

    $scope.getCharacterActivityBagUsageString = function(characterActivity) {
        return characterActivity.UsedBagSlots + "/" + characterActivity.MaxBagSize;
    }

    $scope.getCharacterActivityBankUsageString = function (characterActivity) {
        return characterActivity.UsedBankSlots + "/" + characterActivity.MaxBankSize;
    }

    $scope.getCharacterSkills = function () {
        $scope.characterSkills = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharacterSkills").query();
    }

    $scope.getCharacterQuests = function () {
        $scope.characterQuests = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetCharacterSkills").query();
    }

    $scope.getNextUpInResearch = function () {
        $scope.nextUpInResearch = $resource("http://hemsoftesoapi.azurewebsites.net/api/Characters/GetNextUpInResearch").query();
    }

    $scope.getSelectedAccountHeaderString = function () {
        if ($scope.selectedAccount !== null) {
            return "Characters for " + $scope.selectedAccount.Name + " account:";
        }
        return "";
    }

    $scope.getSelectedCharacterHeaderString = function() {
        if ($scope.selectedCharacter !== null) {
            return "Character activity for " + $scope.selectedCharacter.Name;
        }
        return "";
    }

    $scope.getCharacterActivityTimePlayed = function (characterActivity) {
        if (characterActivity !== undefined) {
            return (characterActivity.SecondsPlayed / 60 / 60) | 0;
        }
        return "";
    }

    $scope.CountDown = function (nextUp) {
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

                $scope.nextUpInResearch = $scope.nextUpInResearchPromise.get(function (resp) {
                    nextUp = resp;
                });
            }

        }, 1000);
    }
});
