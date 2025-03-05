namespace Himinhvelfing.Domain.Services;

public interface IAstroApiProvider
{
    /// <summary>
    /// Returns the base URI for the given API provider (e.g., IPGEO, OpenMeteo, JPL).
    /// </summary>
    string GetBaseUri(string providerName);

    /// <summary>
    /// Returns a list of available API providers.
    /// </summary>
    IEnumerable<(string api, string uri)> GetProviders();

    /// <summary>
    /// Returns the full API URL for a specific data type (e.g., SunRiseSet, MoonPhase) based on available providers.
    /// Supports fallback if the preferred API is unavailable.
    /// </summary>
    string GetApiUrl(string dataType);

    /// <summary>
    /// Registers or updates a provider's base URI.
    /// </summary>
    void RegisterProvider(string providerName, string baseUri);
}
