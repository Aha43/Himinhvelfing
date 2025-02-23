function Get-FlatEarthRiseSet {
    # Ensure observer position is set
    if (-not $env:ASTRO_OBS_LAT -or -not $env:ASTRO_OBS_LON) {
        Write-Host "ERROR: Observer position not set. Run 'Init-Astro' first."
        return
    }

    # Set dynamic environment variable names
    $moonRiseVar = "ASTRO_MOON_RISE_RAW"
    $moonSetVar = "ASTRO_MOON_SET_RAW"

    # API Key for TimeAndDate (replace with your actual key)
    $apiKey = "191de10a6c8742e6aee9216b67bf7d8f"

    # Construct API URL
    $apiUrl = "https://api.ipgeolocation.io/astronomy?apiKey=$apiKey&lat=$env:ASTRO_OBS_LAT&long=$env:ASTRO_OBS_LON"

    try {
        Write-Host "Fetching Moon rise/set times for Lat: $env:ASTRO_OBS_LAT, Lon: $env:ASTRO_OBS_LON..."
        
        # Call the API
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        
        # Extract rise and set times
        $moonRise = $response.moonrise
        $moonSet = $response.moonset

        # Store in session environment variables
        Set-Item -Path "Env:$moonRiseVar" -Value $moonRise
        Set-Item -Path "Env:$moonSetVar" -Value $moonSet

        Write-Host "Moon rise at: $moonRise | Moon set at: $moonSet (Raw Flat Earth Calculation)"
    }
    catch {
        Write-Host "ERROR: Failed to retrieve Moon rise/set data."
    }
}

# Example usage:
#   Get-FlatEarthRiseSet    (Fetches rise/set times for the current observer location)
