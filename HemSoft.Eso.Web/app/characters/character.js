var App;
(function (App) {
    var Domain;
    (function (Domain) {
        var Character = (function () {
            function Character(id, name, description, accountId, classId, raceId, allianceId, lastLogin, enlightenedPool, effectiveLevel, championPointsEarned, achievementPoints, hoursPlayed, bankedTelvarStones, alliancePoints, account) {
                this.id = id;
                this.name = name;
                this.description = description;
                this.accountId = accountId;
                this.classId = classId;
                this.raceId = raceId;
                this.allianceId = allianceId;
                this.lastLogin = lastLogin;
                this.enlightenedPool = enlightenedPool;
                this.effectiveLevel = effectiveLevel;
                this.championPointsEarned = championPointsEarned;
                this.achievementPoints = achievementPoints;
                this.hoursPlayed = hoursPlayed;
                this.bankedTelvarStones = bankedTelvarStones;
                this.alliancePoints = alliancePoints;
                this.account = account;
            }
            return Character;
        })();
        Domain.Character = Character;
    })(Domain = App.Domain || (App.Domain = {}));
})(App || (App = {}));
//# sourceMappingURL=character.js.map