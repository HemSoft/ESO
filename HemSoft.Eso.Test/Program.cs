using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
            lua.DoFile(@"C:\Users\fhemmer\Google Drive\Documents\ESO\AddOns\AddOns\HSEventLog\SavedVariables\HSEventLog.lua");
            var luaTable = lua["HSEventLogSavedVariables"] as LuaTable;
            Dictionary<object, object> dict = lua.GetTableDict(luaTable);
            int indent = 0;

            foreach (var tables in dict)
            {
                Console.WriteLine($"{tables.Key} = {tables.Value}");
                Dictionary<object, object> accounts = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var account in accounts)
                {
                    Console.WriteLine($"  {account.Key} = {account.Value}");
                    Dictionary<object, object> characters = lua.GetTableDict(account.Value as LuaTable);
                    foreach (var character in characters)
                    {
                        Console.WriteLine($"    {character.Key} = {character.Value}");
                        Dictionary<object, object> properties = lua.GetTableDict(character.Value as LuaTable);
                        foreach (var property in properties)
                        {
                            Console.WriteLine($"      {property.Key} = {property.Value}");
                        }
                    }
                }
            }

            Console.ReadLine();
        }
    }
}
