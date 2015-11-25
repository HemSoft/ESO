namespace HemSoft.Eso.Test
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
            timer.Interval = 60 * 60 * 1000;
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
                Console.WriteLine($"{tables.Key} = {tables.Value}");
                Dictionary<object, object> accounts = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var acc in accounts)
                {
                    currentAccount = acc.Key.ToString().Substring(1);

                    var account = AccountManager.GetByName(currentAccount);
                    account.Name = currentAccount;
                    AccountManager.Save(account);

                    Console.WriteLine($"  {acc.Key} = {acc.Value}");
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

                        Console.WriteLine($"    {c.Key} = {c.Value}");
                        Dictionary<object, object> properties = lua.GetTableDict(c.Value as LuaTable);
                        var esoProperty = new EsoProperty();
                        foreach (var property in properties)
                        {
                            switch (property.Key.ToString())
                            {
                                case "AlliancePoints":
                                    characterActivity.AlliancePoints = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedCash":
                                    characterActivity.BankedCash = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedTelvarStones":
                                    characterActivity.BankedTelvarStones = int.Parse(property.Value.ToString());
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
                                case "GuildCount":
                                    characterActivity.GuildCount = int.Parse(property.Value.ToString());
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
                                case "NumberOfFriends":
                                    characterActivity.NumberOfFriends = int.Parse(property.Value.ToString());
                                    break;
                                case "SecondsPlayed":
                                    characterActivity.SecondsPlayed = int.Parse(property.Value.ToString());
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
                                default:
                                    break;
                            }
                            Console.WriteLine($"      {property.Key} = {property.Value}");
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
                            );
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
                            );
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
                            );
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
                            );
                        }

                        if (!account.LastLogin.HasValue)
                        {
                            account.LastLogin = characterActivity.LastLogin.Value;
                            AccountManager.Save(account);
                        }

                        if (!character.LastLogin.HasValue)
                        {
                            character.LastLogin = characterActivity.LastLogin.Value;
                            CharacterManager.Save(character);
                            CharacterActivityManager.Save(characterActivity);
                        }
                        else if (DateTime.Compare(characterActivity.LastLogin.Value, character.LastLogin.Value) > 0)
                        {
                            character.LastLogin = characterActivity.LastLogin;
                            CharacterManager.Save(character);
                            CharacterActivityManager.Save(characterActivity);
                        }

                        if (lastCharacterActivity.LastLogin.HasValue)
                        {
                            if (DateTime.Compare(lastCharacterActivity.LastLogin.Value, characterActivity.LastLogin.Value) > 0)
                            {
                                CharacterActivityManager.Save(characterActivity);
                            }
                        }
                        else
                        {
                            CharacterActivityManager.Save(characterActivity);
                        }
                    }
                }
            }
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
