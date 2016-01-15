var App;
(function (App) {
    var Domain;
    (function (Domain) {
        var Character = (function () {
            function Character(Id, Name, Description, AccountId, ClassId, RaceId, AllianceId, LastLogin, EnlightenedPool, EffectiveLevel, ChampionPointsEarned, AchievementPoints, HoursPlayed, BankedTelvarStones, AlliancePoints, Account) {
                this.Id = Id;
                this.Name = Name;
                this.Description = Description;
                this.AccountId = AccountId;
                this.ClassId = ClassId;
                this.RaceId = RaceId;
                this.AllianceId = AllianceId;
                this.LastLogin = LastLogin;
                this.EnlightenedPool = EnlightenedPool;
                this.EffectiveLevel = EffectiveLevel;
                this.ChampionPointsEarned = ChampionPointsEarned;
                this.AchievementPoints = AchievementPoints;
                this.HoursPlayed = HoursPlayed;
                this.BankedTelvarStones = BankedTelvarStones;
                this.AlliancePoints = AlliancePoints;
                this.Account = Account;
            }
            return Character;
        })();
        Domain.Character = Character;
    })(Domain = App.Domain || (App.Domain = {}));
})(App || (App = {}));
