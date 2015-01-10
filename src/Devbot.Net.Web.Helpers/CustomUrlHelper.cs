using Devbot.Net.Web.Helpers.UrlExtensions;
using Microsoft.AspNet.Http;
using Microsoft.AspNet.Mvc;
using Microsoft.Framework.DependencyInjection;
using Microsoft.Framework.OptionsModel;

namespace Devbot.Net.Web.Helpers
{
	public class CustomUrlHelper : UrlHelper
	{
		private readonly CustomUrlHelperOptions _options;
		private readonly HttpContext _context;

		public CustomUrlHelper(IContextAccessor<ActionContext> contextAccessor, IActionSelector actionSelector, IOptions<CustomUrlHelperOptions> options)
			: base(contextAccessor, actionSelector)
		{
			_options = options.Options;
			_context = contextAccessor.Value.HttpContext;
		}

		public override string Content(string contentPath)
		{
			if (_options.UseLowercase)
				return base.Content(contentPath).ToLowercaseUrl();
			return base.Content(contentPath);
		}

		public override string RouteUrl(string routeName, object values, string protocol, string host, string fragment)
		{
			if (_options.UseLowercase)
				return base.RouteUrl(routeName, values, protocol, host, fragment).ToLowercaseUrl();
			return base.RouteUrl(routeName, values, protocol, host, fragment);
		}

		public override string Action(string action, string controller, object values, string protocol, string host, string fragment)
		{
			if (_options.UseLowercase)
				return base.Action(action, controller, values, protocol, host, fragment).ToLowercaseUrl();
			return base.Action(action, controller, values, protocol, host, fragment);
		}
	}
}
