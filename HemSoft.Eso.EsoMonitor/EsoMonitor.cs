using System.ServiceProcess;
using System.Timers;
using NLua;
using System.Collections.Generic;

namespace HemSoft.Eso.EsoMonitor
{
    public partial class EsoMonitor : ServiceBase
    {
        private System.Timers.Timer _Timer;

        public EsoMonitor()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            _Timer = new Timer(60*1000);
            _Timer.Start();
        }

        private void OnTimer(object state)
        {
            // Temporarily disable timer:
            _Timer.Enabled = false;

            Lua lua = new Lua();
            //lua.DoFile(@"C:\Users\fhemmer\Google Drive\Documents\ESO\AddOns\AddOns\HSEventLog\SavedVariables\HSEventLog.lua");
            lua.DoFile(@"C:\Users\franz\Documents\Elder Scrolls Online\live\SavedVariables\HSEventLog.lua");
            var luaTable = lua["HSEventLogSavedVariables"] as LuaTable;
            Dictionary<object, object> dict = lua.GetTableDict(luaTable);

            foreach (var tables in dict)
            {
                Dictionary<object, object> accounts = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var account in accounts)
                {
                    Dictionary<object, object> characters = lua.GetTableDict(account.Value as LuaTable);
                    foreach (var character in characters)
                    {
                        Dictionary<object, object> properties = lua.GetTableDict(character.Value as LuaTable);
                        foreach (var property in properties)
                        {
                        }
                    }
                }
            }

        }

        protected override void OnStop()
        {
            _Timer.Stop();
        }
    }
}
