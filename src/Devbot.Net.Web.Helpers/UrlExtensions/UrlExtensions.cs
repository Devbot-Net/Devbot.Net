namespace Devbot.Net.Web.Helpers.UrlExtensions
{
    public static class UrlExtensions
    {
		public static string ToLowercaseUrl(this string url)
		{
			if (!string.IsNullOrWhiteSpace(url))
				return url.ToLowerInvariant();
			return url;
		}
	}
}