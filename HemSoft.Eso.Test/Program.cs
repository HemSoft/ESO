using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HemSoft.Eso.Domain;
using HemSoft.Eso.Domain.Managers;
using KeraLua;
using NLua;
using Lua = NLua.Lua;

namespace HemSoft.Eso.Test
{
    class Program
    {
        static void Main(string[] args)
        {
            Lua lua = new Lua();
            lua.DoFile(@"..\..\..\AddOns\HSEventLog\SavedVariables\HSEventLog.lua");
            var luaTable = lua["HSEventLogSavedVariables"] as LuaTable;
            Dictionary<object, object> dict = lua.GetTableDict(luaTable);
            int indent = 0;

            var currentAccount = string.Empty;
            var currentCharacter = string.Empty;

            foreach (var tables in dict)
            {
                Console.WriteLine($"{tables.Key} = {tables.Value}");
                Dictionary<object, object> accounts = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var account in accounts)
                {
                    currentAccount = account.Key.ToString().Substring(1);

                    var esoAccount = AccountManager.GetByName(currentAccount);
                    esoAccount.Name = currentAccount;
                    AccountManager.Save(esoAccount);

                    Console.WriteLine($"  {account.Key} = {account.Value}");
                    Dictionary<object, object> characters = lua.GetTableDict(account.Value as LuaTable);
                    foreach (var character in characters)
                    {
                        currentCharacter = character.Key.ToString();

                        var esoCharacter = CharacterManager.GetByName(esoAccount.Id, currentCharacter);
                        esoCharacter.Name = currentCharacter;
                        esoCharacter.AccountId = esoAccount.Id;

                        Console.WriteLine($"    {character.Key} = {character.Value}");
                        Dictionary<object, object> properties = lua.GetTableDict(character.Value as LuaTable);
                        var esoProperty = new EsoProperty();
                        foreach (var property in properties)
                        {
                            switch (property.Key.ToString())
                            {
                                case "AlliancePoints":
                                    esoCharacter.AlliancePoints = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedCash":
                                    esoCharacter.BankedCash = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedTelvarStones":
                                    esoCharacter.BankedTelvarStones = int.Parse(property.Value.ToString());
                                    break;
                                case "Cash":
                                    esoCharacter.Cash = int.Parse(property.Value.ToString());
                                    break;
                                case "ChampionPointsEarned":
                                    esoCharacter.ChampionPointsEarned = int.Parse(property.Value.ToString());
                                    break;
                                case "Date":
                                    esoProperty.Date = property.Value.ToString();
                                    break;
                                case "GuildCount":
                                    esoCharacter.GuildCount = int.Parse(property.Value.ToString());
                                    break;
                                case "MailCount":
                                    esoCharacter.MailCount = int.Parse(property.Value.ToString());
                                    break;
                                case "MailMax":
                                    esoCharacter.MailMax = int.Parse(property.Value.ToString());
                                    break;
                                case "MaxBagSize":
                                    esoCharacter.MaxBagSize = int.Parse(property.Value.ToString());
                                    break;
                                case "MaxBankSize":
                                    esoCharacter.MaxBankSize = int.Parse(property.Value.ToString());
                                    break;
                                case "NumberOfFriends":
                                    esoCharacter.NumberOfFriends = int.Parse(property.Value.ToString());
                                    break;
                                case "SecondsPlayed":
                                    esoCharacter.TotalTimeSeconds = int.Parse(property.Value.ToString());
                                    break;
                                case "Time":
                                    esoProperty.Time = property.Value.ToString();
                                    break;
                                case "UsedBagSlots":
                                    esoCharacter.UsedBagSlots = int.Parse(property.Value.ToString());
                                    break;
                                case "UsedBankSlots":
                                    esoCharacter.UsedBankSlots = int.Parse(property.Value.ToString());
                                    break;
                                default:
                                    break;
                            }
                            Console.WriteLine($"      {property.Key} = {property.Value}");
                        }

                        if (esoProperty.Time.Length == 3)
                        {
                            esoCharacter.LastLogin = new DateTime
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
                            esoCharacter.LastLogin = new DateTime
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
                            esoCharacter.LastLogin = new DateTime
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
                            esoCharacter.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                int.Parse(esoProperty.Time.Substring(0, 2)),
                                int.Parse(esoProperty.Time.Substring(2, 2)),
                                int.Parse(esoProperty.Time.Substring(4, 2))
                            );
                        }
                        if (!esoAccount.LastLogin.HasValue ||
                            DateTime.Compare(esoAccount.LastLogin.Value, esoCharacter.LastLogin.Value) > 0)
                        {
                            esoAccount.LastLogin = esoCharacter.LastLogin;
                            AccountManager.Save(esoAccount);
                        }

                        CharacterManager.Save(esoCharacter);
                    }
                }
            }
            Console.ReadLine();
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
