var App;
(function (App) {
    var Domain;
    (function (Domain) {
        var Account = (function () {
            function Account(id, name, password, lastLogin, description, enlightenedPool, championPointsEarned, hoursePlayed, bankedTelvarStones, characters) {
                this.id = id;
                this.name = name;
                this.password = password;
                this.lastLogin = lastLogin;
                this.description = description;
                this.enlightenedPool = enlightenedPool;
                this.championPointsEarned = championPointsEarned;
                this.hoursePlayed = hoursePlayed;
                this.bankedTelvarStones = bankedTelvarStones;
                this.characters = characters;
            }
            return Account;
        })();
        Domain.Account = Account;
    })(Domain = App.Domain || (App.Domain = {}));
})(App || (App = {}));
//# sourceMappingURL=account.js.map