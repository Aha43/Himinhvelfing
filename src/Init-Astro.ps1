function Init-Astro {
    param(
        [string]$Location
    )

    # Environment variable names for observer position
    $latVar = "ASTRO_OBS_LAT"
    $lonVar = "ASTRO_OBS_LON"
    $altVar = "ASTRO_OBS_ALT"

    if (-not $Location) {
        Write-Host "No location provided. You can enter latitude and longitude manually."
        $lat = Read-Host "Enter latitude"
        $lon = Read-Host "Enter longitude"
        $alt = Read-Host "Enter altitude in meters (optional, default 0)"
    }
    else {
        Write-Host "Looking up coordinates for '$Location'..."
        $apiUrl = "https://nominatim.openstreetmap.org/search?format=json&q=$([uri]::EscapeDataString($Location))"
        
        try {
            $response = Invoke-RestMethod -Uri $apiUrl -Method Get
            if ($response.Count -eq 0) {
                Write-Host "Error: Could not find coordinates for '$Location'. Try a more specific place name."
                return
            }
            
            $lat = $response[0].lat
            $lon = $response[0].lon

            # Get elevation (altitude) from OpenTopoData or Google Elevation API (Optional)
            $elevationUrl = "https://api.opentopodata.org/v1/eudem25m?locations=$lat,$lon"
            $elevationResponse = Invoke-RestMethod -Uri $elevationUrl -Method Get
            $alt = if ($elevationResponse.results[0].elevation) { $elevationResponse.results[0].elevation } else { "0" }

            Write-Host "Found coordinates: Latitude $lat, Longitude $lon, Altitude $alt m"
        }
        catch {
            Write-Host "Error: Failed to connect to geolocation services."
            return
        }
    }

    # Set environment variables dynamically for the session only
    Set-Item -Path "Env:$latVar" -Value $lat
    Set-Item -Path "Env:$lonVar" -Value $lon
    Set-Item -Path "Env:$altVar" -Value $alt

    Write-Host "Observer position set for this session: (Lat: $lat, Lon: $lon, Alt: $alt m)"
    Write-Host "These values will be reset when you close the session."
}

# Example usage:
#   Init-Astro                    (Prompts for lat/lon manually)
#   Init-Astro "Norway, Bergen"    (Looks up coordinates and altitude)
