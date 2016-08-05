var App;
(function (App) {
    var Domain;
    (function (Domain) {
        var Account = (function () {
            function Account(Id, Name, Password, LastLogin, Description, EnlightenedPool, ChampionPointsEarned, HoursePlayed, BankedTelvarStones, Characters) {
                this.Id = Id;
                this.Name = Name;
                this.Password = Password;
                this.LastLogin = LastLogin;
                this.Description = Description;
                this.EnlightenedPool = EnlightenedPool;
                this.ChampionPointsEarned = ChampionPointsEarned;
                this.HoursePlayed = HoursePlayed;
                this.BankedTelvarStones = BankedTelvarStones;
                this.Characters = Characters;
            }
            return Account;
        })();
        Domain.Account = Account;
    })(Domain = App.Domain || (App.Domain = {}));
})(App || (App = {}));
//# sourceMappingURL=account.js.map