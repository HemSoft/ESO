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
            if (dict.ContainsKey("version"))
            {
                Console.WriteLine(dict["inventory"]);
            }
            foreach (var tables in dict)
            {
                Console.WriteLine($"{tables.Key} = {tables.Value}");
                Dictionary<object, object> dict2 = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var x in dict2)
                {
                    
                }
            }
        }
    }
}
