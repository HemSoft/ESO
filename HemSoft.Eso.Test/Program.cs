namespace HemSoft.Eso.CharacterMonitor
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using Domain;
    using Domain.Managers;
    using NLua;
    using Lua = NLua.Lua;

    class Program
    {
        static void Main(string[] args)
        {
            Timer_Elapsed(null, null);
            System.Timers.Timer timer = new System.Timers.Timer();
            timer.Interval = 1 * 60 * 1000;
            timer.Enabled = true;
            timer.Elapsed += Timer_Elapsed;
            timer.Start();
            Console.ReadLine();
        }

        private static void Timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            Lua lua = new Lua();
            var filePath = @"C:\Users\franz\Documents\Elder Scrolls Online\live\SavedVariables\HSEventLog.lua";
            //var filePath = @"..\..\..\AddOns\HSEventLog\SavedVariables\HSEventLog.lua";
            if (!File.Exists(filePath))
            {
                return;
            }
            lua.DoFile(filePath);
            var luaTable = lua["HSEventLogSavedVariables"] as LuaTable;
            Dictionary<object, object> dict = lua.GetTableDict(luaTable);
            int indent = 0;

            var currentAccount = string.Empty;
            var currentCharacter = string.Empty;

            foreach (var tables in dict)
            {
                //Console.WriteLine($"{tables.Key} = {tables.Value}");
                Dictionary<object, object> accounts = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var acc in accounts)
                {
                    currentAccount = acc.Key.ToString().Substring(1);

                    var account = AccountManager.GetByName(currentAccount);
                    account.Name = currentAccount;
                    AccountManager.Save(account);

                    //Console.WriteLine($"  {acc.Key} = {acc.Value}");
                    Dictionary<object, object> characters = lua.GetTableDict(acc.Value as LuaTable);
                    foreach (var c in characters)
                    {
                        currentCharacter = c.Key.ToString();

                        var character = CharacterManager.GetByName(account.Id, currentCharacter);
                        character.Name = currentCharacter;
                        character.AccountId = account.Id;
                        CharacterManager.Save(character);

                        var lastCharacterActivity = CharacterActivityManager.GetLastActivity(character.Id);
                        var characterActivity = new CharacterActivity {CharacterId = character.Id};

                        //Console.WriteLine($"    {c.Key} = {c.Value}");
                        Dictionary<object, object> properties = lua.GetTableDict(c.Value as LuaTable);
                        var esoProperty = new EsoProperty();
                        foreach (var property in properties)
                        {
                            switch (property.Key.ToString())
                            {
                                case "AlliancePoints":
                                    characterActivity.AlliancePoints = int.Parse(property.Value.ToString());
                                    break;
                                case "AvailableSkillPoints":
                                    characterActivity.AvailableSkillPoints = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedCash":
                                    characterActivity.BankedCash = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedTelvarStones":
                                    characterActivity.BankedTelvarStones = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMaximumLeft":
                                    characterActivity.BlacksmithingSecondsMaximumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMaximumTotal":
                                    characterActivity.BlacksmithingSecondsMaximumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMinimumLeft":
                                    characterActivity.BlacksmithingSecondsMinimumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMinimumTotal":
                                    characterActivity.BlacksmithingSecondsMinimumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSlotsFree":
                                    characterActivity.BlacksmithingSlotsFree = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSlotsMax":
                                    characterActivity.BlacksmithingSlotsMax = int.Parse(property.Value.ToString());
                                    break;

                                case "ClothingSecondsMaximumLeft":
                                    characterActivity.ClothingSecondsMaximumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSecondsMaximumTotal":
                                    characterActivity.ClothingSecondsMaximumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSecondsMinimumLeft":
                                    characterActivity.ClothingSecondsMinimumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSecondsMinimumTotal":
                                    characterActivity.ClothingSecondsMinimumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSlotsFree":
                                    characterActivity.ClothingSlotsFree = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSlotsMax":
                                    characterActivity.ClothingSlotsMax = int.Parse(property.Value.ToString());
                                    break;
                                case "Cash":
                                    characterActivity.Cash = int.Parse(property.Value.ToString());
                                    break;
                                case "ChampionPointsEarned":
                                    characterActivity.ChampionPointsEarned = int.Parse(property.Value.ToString());
                                    break;
                                case "Date":
                                    esoProperty.Date = property.Value.ToString();
                                    break;
                                case "EffectiveLevel":
                                    characterActivity.EffictiveLevel = int.Parse(property.Value.ToString());
                                    break;
                                case "EnlightenedPool":
                                    characterActivity.EnlightenedPool = int.Parse(property.Value.ToString());
                                    break;
                                case "GuildCount":
                                    characterActivity.GuildCount = int.Parse(property.Value.ToString());
                                    break;
                                case "IsVeteran":
                                    characterActivity.IsVeteran = bool.Parse(property.Value.ToString());
                                    break;
                                case "Level":
                                    characterActivity.Level = int.Parse(property.Value.ToString());
                                    break;
                                case "MailCount":
                                    characterActivity.MailCount = int.Parse(property.Value.ToString());
                                    break;
                                case "MailMax":
                                    characterActivity.MailMax = int.Parse(property.Value.ToString());
                                    break;
                                case "MaxBagSize":
                                    characterActivity.MaxBagSize = int.Parse(property.Value.ToString());
                                    break;
                                case "MaxBankSize":
                                    characterActivity.MaxBankSize = int.Parse(property.Value.ToString());
                                    break;
                                case "MountCapacity":
                                    characterActivity.MountCapacity = int.Parse(property.Value.ToString());
                                    break;
                                case "MountStamina":
                                    characterActivity.MountStamina = int.Parse(property.Value.ToString());
                                    break;
                                case "MountSpeed":
                                    characterActivity.MountSpeed = int.Parse(property.Value.ToString());
                                    break;
                                case "NumberOfFriends":
                                    characterActivity.NumberOfFriends = int.Parse(property.Value.ToString());
                                    break;
                                case "SecondsPlayed":
                                    characterActivity.SecondsPlayed = int.Parse(property.Value.ToString());
                                    break;
                                case "SecondsUntilMountTraining":
                                    characterActivity.SecondsUntilMountTraining = int.Parse(property.Value.ToString());
                                    break;
                                case "Skyshards":
                                    characterActivity.Skyshards = int.Parse(property.Value.ToString());
                                    break;
                                case "Time":
                                    esoProperty.Time = property.Value.ToString();
                                    break;
                                case "UsedBagSlots":
                                    characterActivity.UsedBagSlots = int.Parse(property.Value.ToString());
                                    break;
                                case "UsedBankSlots":
                                    characterActivity.UsedBankSlots = int.Parse(property.Value.ToString());
                                    break;
                                case "VP":
                                    characterActivity.VP = int.Parse(property.Value.ToString());
                                    break;
                                case "VPMax":
                                    characterActivity.VPMax = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMaximumLeft":
                                    characterActivity.WoodworkingSecondsMaximumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMaximumTotal":
                                    characterActivity.WoodworkingSecondsMaximumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMinimumLeft":
                                    characterActivity.WoodworkingSecondsMinimumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMinimumTotal":
                                    characterActivity.WoodworkingSecondsMinimumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSlotsFree":
                                    characterActivity.WoodworkingSlotsFree = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSlotsMax":
                                    characterActivity.WoodworkingSlotsMax = int.Parse(property.Value.ToString());
                                    break;
                                case "XP":
                                    characterActivity.XP = int.Parse(property.Value.ToString());
                                    break;
                                case "XPMax":
                                    characterActivity.XPMax = int.Parse(property.Value.ToString());
                                    break;
                                case "Zone":
                                    characterActivity.Zone = property.Value.ToString();
                                    break;
                                case "version":
                                case "left":
                                case "top":
                                case "Inventory":
                                    break;
                                default:
                                    break;
                            }
                            //Console.WriteLine($"      {property.Key} = {property.Value}");
                        }

                        // Some post-mortem rules:

                        // 1) If Mount stats is all 60, we don't need to feed the horse.
                        if (characterActivity != null &&
                            characterActivity.MountCapacity == 60 &&
                            characterActivity.MountSpeed == 60 &&
                            characterActivity.MountStamina == 60)
                        {
                            characterActivity.SecondsUntilMountTraining = null;
                        }

                        if (esoProperty.Time.Length == 3)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                0,
                                int.Parse(esoProperty.Time.Substring(0, 1)),
                                int.Parse(esoProperty.Time.Substring(1, 2))
                            ).ToUniversalTime();
                        }
                        else if (esoProperty.Time.Length == 4)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                0,
                                int.Parse(esoProperty.Time.Substring(0, 2)),
                                int.Parse(esoProperty.Time.Substring(2, 2))
                            ).ToUniversalTime();
                        }
                        else if (esoProperty.Time.Length == 5)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                int.Parse(esoProperty.Time.Substring(0, 1)),
                                int.Parse(esoProperty.Time.Substring(1, 2)),
                                int.Parse(esoProperty.Time.Substring(3, 2))
                            ).ToUniversalTime();
                        }
                        else
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                int.Parse(esoProperty.Time.Substring(0, 2)),
                                int.Parse(esoProperty.Time.Substring(2, 2)),
                                int.Parse(esoProperty.Time.Substring(4, 2))
                            ).ToUniversalTime();
                        }

                        if (!account.LastLogin.HasValue)
                        {
                            account.LastLogin = characterActivity.LastLogin.Value;
                            AccountManager.Save(account);
                        }
                        else
                        {
                            if (DateTime.Compare(characterActivity.LastLogin.Value, account.LastLogin.Value) > 0)
                            {
                                account.LastLogin = characterActivity.LastLogin.Value;
                                AccountManager.Save(account);
                            }
                        }

                        if (!character.LastLogin.HasValue)
                        {
                            character.LastLogin = characterActivity.LastLogin.Value;
                            CharacterManager.Save(character);
                            CharacterActivityManager.Save(characterActivity);
                            Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");
                        }
                        else if (DateTime.Compare(characterActivity.LastLogin.Value, character.LastLogin.Value) > 0)
                        {
                            character.LastLogin = characterActivity.LastLogin;
                            CharacterManager.Save(character);
                            CharacterActivityManager.Save(characterActivity);
                            Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");
                        }

                        if (lastCharacterActivity.LastLogin.HasValue)
                        {
                            if (DateTime.Compare(lastCharacterActivity.LastLogin.Value, characterActivity.LastLogin.Value) > 0)
                            {
                                CharacterActivityManager.Save(characterActivity);
                                Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");
                            }
                        }
                    }
                }
            }
            //Console.WriteLine("Last completion " + DateTime.Now.ToLongTimeString());
        }
    }

    public class EsoProperty
    {
        public int AlliancePoints { get; set; }
        public int BankedCash { get; set; }
        public int BankedTelvarStones { get; set; }
        public int Cash { get; set; }
        public int ChampionPointsEarned { get; set; }
        public string Date { get; set; }
        public int GuildCount { get; set; }
        public int MailCount { get; set; }
        public int MailMax { get; set; }
        public int MaxBagSize { get; set; }
        public int MaxBankSize { get; set; }
        public int NumberOfFriends { get; set; }
        public int SecondsPlayed { get; set; }
        public string Time { get; set; }
        public int UsedBagSlots { get; set; }
        public int UsedBankSlots { get; set; }
    }
}
