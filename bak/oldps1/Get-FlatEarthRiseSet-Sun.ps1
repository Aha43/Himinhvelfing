function Get-FlatEarthRiseSet-Sun {
    # Ensure observer position is set
    if (-not $env:ASTRO_OBS_LAT -or -not $env:ASTRO_OBS_LON) {
        Write-Host "ERROR: Observer position not set. Run 'Init-Astro' first."
        return
    }

    # Set dynamic environment variable names
    $sunRiseVar = "ASTRO_SUN_RISE_RAW"
    $sunSetVar = "ASTRO_SUN_SET_RAW"

    # API Key for TimeAndDate (replace with your actual key)
    # Get API Key from environment variable
    $apiKey = $env:ASTRO_IPGEO_API_KEY
    if (-not $apiKey) {
        Write-Host "ERROR: API key not set. Please set 'ASTRO_IPGEO_API_KEY' environment variable."
        return
    }

    # Construct API URL for Sun rise/set
    $apiUrl = "https://api.ipgeolocation.io/astronomy?apiKey=$apiKey&lat=$env:ASTRO_OBS_LAT&long=$env:ASTRO_OBS_LON"

    try {
        Write-Host "Fetching Sun rise/set times for Lat: $env:ASTRO_OBS_LAT, Lon: $env:ASTRO_OBS_LON..."
        
        # Call the API
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        
        # Extract rise and set times for the Sun
        $sunRise = $response.sunrise
        $sunSet = $response.sunset

        # Store in session environment variables
        Set-Item -Path "Env:$sunRiseVar" -Value $sunRise
        Set-Item -Path "Env:$sunSetVar" -Value $sunSet

        Write-Host "Sunrise at: $sunRise | Sunset at: $sunSet (Raw Flat Earth Calculation)"
    }
    catch {
        Write-Host "ERROR: Failed to retrieve Sun rise/set data."
    }
}

# Example usage:
#   Get-FlatEarthRiseSet-Sun    (Fetches rise/set times for the Sun)
