using System.ServiceProcess;
using System.Timers;

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
        }

        protected override void OnStop()
        {
            _Timer.Stop();
        }
    }
}
