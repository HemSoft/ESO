var App;
(function (App) {
    var Eso;
    (function (Eso) {
        angular.module("app").controller("esoController", function () {
            var vmeso = this;
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
                        if (this.nextUpInResearchPromise !== undefined && this.nextUpInResearch !== null) {
                            this.nextUpInResearch = this.nextUpInResearchPromise.get(function (resp) {
                                nextUp = resp;
                            });
                        }
                    }
                }, 1000);
            };
        });
    })(Eso = App.Eso || (App.Eso = {}));
})(App || (App = {}));
//# sourceMappingURL=esoController.js.map