using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Data.Entity;
using Microsoft.Data.Entity.Metadata;

namespace Devbot.Net.Identity
{
    public class IdentityContext : IdentityDbContext<ApplicationUser>
	{
		private static object _syncLock = new object();
		private static bool _created;

		public IdentityContext()
		{
			if (!_created) createDatabase();
		}

		private void createDatabase()
		{
			// Workaround until ASP.Net 5 Supports EF Migrations
			lock (_syncLock)
			{
				if (_created) return;
				Database.AsRelational().ApplyMigrations();
				_created = true;
			}
		}

		protected override void OnConfiguring(DbContextOptions options)
		{
			options.UseSqlServer();
		}

		protected override void OnModelCreating(ModelBuilder builder)
		{
			base.OnModelCreating(builder);
			// Can override Identity Model schema here
		}
	}
}
