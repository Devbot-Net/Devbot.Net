using Microsoft.AspNet.Mvc;
using System.Collections.Generic;

namespace Devbot.Net.Web.Controllers
{
	public class HomeController : Controller
	{
		public IActionResult Index() { return View(getTestData()); }

		private IEnumerable<Models.BlogHeading> getTestData()
		{
			return new List<Models.BlogHeading>
			{
				new Models.BlogHeading { Name = "Example Name 1", Title = "Example Title 1", SubTitle = "Example Sub Title 1", Url = "#", PublishDate = System.DateTime.Now.AddDays(-1) },
				new Models.BlogHeading { Name = "Example Name 2", Title = "Example Title 2", SubTitle = "Example Sub Title 2", Url = "#", PublishDate = System.DateTime.Now.AddDays(-2) },
				new Models.BlogHeading { Name = "Example Name 3", Title = "Example Title 3", SubTitle = "Example Sub Title 3", Url = "#", PublishDate = System.DateTime.Now.AddDays(-3) }
			};
		}
	}
}