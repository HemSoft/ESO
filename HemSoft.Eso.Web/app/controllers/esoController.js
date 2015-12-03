esoApp.controller("esoController", function ($scope, $resource) {
    //$scope.accounts = $resource("http://localhost:53807/api/accounts/:id").query();
    $scope.accounts = $resource("http://hemsoftesoapi.azurewebsites.net/api/accounts/:id").query();
    $scope.selectedAccount = null;
    $scope.selectedCharacter = null;

    $scope.accountSelected = function() {
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
                    + this.selectedAccount.Id).query();
        }
    }

    $scope.getCharacterActivitiesForSelectedCharacter = function () {
        if (this.selectedAccount !== null) {
            $scope.characterActivities =
                $resource("http://hemsoftesoapi.azurewebsites.net/api/CharacterActivities/GetCharacterActivitiesByCharacterId?characterId="
                    + this.selectedAccount.Id).query();
        }
    }
});