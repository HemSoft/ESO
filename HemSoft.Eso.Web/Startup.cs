using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(HemSoft.Eso.Web.Startup))]
namespace HemSoft.Eso.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
