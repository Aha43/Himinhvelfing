namespace Himinhvelfing.Services;

using System;
using System.Collections.Generic;
using Himinhvelfing.Domain.Services;

public class AstroApiProvider : IAstroApiProvider
{
    private readonly Dictionary<string, string> _apiProviders = [];

    public AstroApiProvider()
    {
        // Default API providers
        _apiProviders["IPGEO"] = "https://api.ipgeolocation.io/astronomy";
        _apiProviders["OPENMETEO"] = "https://api.open-meteo.com/v1/astronomy";
        _apiProviders["JPL"] = "https://ssd.jpl.nasa.gov/api/horizons.api";
    }

    public IEnumerable<(string api, string uri)> GetProviders()
    {
        return _apiProviders.Select(kvp => (kvp.Key, kvp.Value));
    }

    public string GetBaseUri(string providerName)
    {
        return _apiProviders.TryGetValue(providerName.ToUpper(), out var uri) ? uri : throw new Exception($"Unknown API provider: {providerName}");
    }

    public string GetApiUrl(string dataType)
    {
        switch (dataType.ToUpper())
        {
            case "SUNRISESET":
                return _apiProviders.ContainsKey("IPGEO") ? $"{_apiProviders["IPGEO"]}?apiKey={{API_KEY}}&lat={{LAT}}&long={{LON}}"
                     : _apiProviders.ContainsKey("OPENMETEO") ? $"{_apiProviders["OPENMETEO"]}?latitude={{LAT}}&longitude={{LON}}"
                     : throw new Exception("No available provider for sunrise/set data.");

            case "MOONPHASE":
                return _apiProviders.ContainsKey("IPGEO") ? $"{_apiProviders["IPGEO"]}?apiKey={{API_KEY}}&lat={{LAT}}&long={{LON}}"
                     : throw new Exception("No available provider for Moon phase data.");

            case "EPHEMERIS":
                return _apiProviders.ContainsKey("JPL") ? _apiProviders["JPL"]
                     : throw new Exception("No available provider for ephemeris data.");

            default:
                throw new Exception($"Unknown data type: {dataType}");
        }
    }

    public void RegisterProvider(string providerName, string baseUri)
    {
        _apiProviders[providerName.ToUpper()] = baseUri;
    }
}
