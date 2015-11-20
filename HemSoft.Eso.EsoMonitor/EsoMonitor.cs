using System.ServiceProcess;
using System.Timers;
using NLua;

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
            lua.LoadFile(@"C:\Users\fhemmer\Google Drive\Documents\ESO\AddOns\AddOns\HSEventLog\SavedVariables\HSEventLog.lua");
        }

        protected override void OnStop()
        {
            _Timer.Stop();
        }
    }
}
