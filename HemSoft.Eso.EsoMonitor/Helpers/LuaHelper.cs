using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HemSoft.Eso.Domain;
using NLua;

namespace HemSoft.Eso.EsoMonitor.Helpers
{
    public class LuaHelper
    {
        public string LuaFile { get; set; }

        public LuaHelper()
        {
            var lua = new Lua();
            lua.DoFile(@"C:\Users\fhemmer\Google Drive\Documents\ESO\AddOns\AddOns\HSEventLog\SavedVariables\HSEventLog.lua");
            var luaTable = lua["HSEventLogSavedVariables"] as LuaTable;
            var dict = lua.GetTableDict(luaTable);
            
            foreach (var table in dict)
            {
                Dictionary<object, object> accounts = lua.GetTableDict(table.Value as LuaTable);
                foreach (var account in accounts)
                {
                    
                    Dictionary<object, object> characters = lua.GetTableDict(account.Value as LuaTable);
                    foreach (var character in characters)
                    {
                        Dictionary<object, object> properties = lua.GetTableDict(character.Value as LuaTable);
                        foreach (var property in properties)
                        {
                            Console.WriteLine($"      {property.Key} = {property.Value}");
                        }
                    }
                }
            }

        }
    }
}
