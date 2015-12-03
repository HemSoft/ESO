namespace HemSoft.Eso.Api.Controllers
{
    using System.Web.Http.Cors;
    using System.Web.Mvc;

    [EnableCors("*", "*", "*")]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";

            return View();
        }
    }
}
