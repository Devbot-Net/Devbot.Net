using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Hosting;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Mvc;
using Microsoft.AspNet.Routing;
using Microsoft.Framework.ConfigurationModel;
using Microsoft.Framework.DependencyInjection;
using Microsoft.Framework.Logging;
using Microsoft.Framework.Logging.Console;
using Microsoft.AspNet.Diagnostics;

namespace Devbot.Net.Web
{
    public class Startup
    {
		public IConfiguration Configuration { get; private set; }

		public Startup(IHostingEnvironment env)
		{
			Configuration = new Configuration()
				.AddJsonFile("config.json")
				.AddEnvironmentVariables();
		}

		public void ConfigureServices(IServiceCollection services)
		{
			services.AddEntityFramework(Configuration)
				.AddSqlServer()
				.AddDbContext<Identity.IdentityContext>();

			services.AddDefaultIdentity<Identity.IdentityContext, Identity.ApplicationUser, IdentityRole>(Configuration);

			services.AddMvc();

			services.AddScoped<IUrlHelper, Helpers.CustomUrlHelper>();
			services.Configure<Helpers.CustomUrlHelperOptions>(options => { options.UseLowercase = true; });
		}

        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
			loggerFactory.AddConsole();

			switch (env.EnvironmentName.ToLowerInvariant())
			{
				case "production":
					app.UseErrorHandler("/Home/Error");
					break;
				case "staging":
					app.UseErrorPage(ErrorPageOptions.ShowAll);
					app.UseRuntimeInfoPage();
					break;
				case "development":
					app.UseBrowserLink();
					app.UseErrorPage(ErrorPageOptions.ShowAll);
					app.UseRuntimeInfoPage();
					break;
			}

			app.UseIdentity();

			app.UseMvc(routes =>
			{
				routes.MapRoute(
					name: "default",
					template: "{controller}/{action}",
					defaults: new { controller = "Home", action = "Index" });
			});
        }
    }
}
