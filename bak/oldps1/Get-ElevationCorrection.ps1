function Get-ElevationCorrection {
    param(
        [string]$CelestialBody = "MOON"  # Default to Moon if not specified
    )

    # Construct env variable names dynamically
    $rawRiseVar = "ASTRO_${CelestialBody}_RISE_RAW"
    $adjRiseVar = "ASTRO_${CelestialBody}_RISE_ADJ"


    # Ensure observer altitude is set
    if (-not $env:ASTRO_OBS_ALT) {
        Write-Host "ERROR: Observer altitude not set. Run 'Init-Astro' first."
        return
    }

    # Ensure raw rise time is available
    if (-not (Get-Item -Path "Env:$rawRiseVar" -ErrorAction SilentlyContinue)) {
        Write-Host "ERROR: No raw $CelestialBody rise time found. Run the base rise time function first."
        return
    }

    # Force Invariant Culture for decimal consistency
    $culture = [System.Globalization.CultureInfo]::InvariantCulture

    # Convert altitude to numeric
    try {
        $altitude = [double]::Parse($env:ASTRO_OBS_ALT, $culture)
    }
    catch {
        Write-Host "ERROR: Altitude is not a valid number: $env:ASTRO_OBS_ALT"
        return
    }

    # Convert altitude to numeric
    $altitude = [double]$env:ASTRO_OBS_ALT

    # If observer is at sea level, no correction needed
    if ($altitude -le 0) {
        Write-Host "No elevation correction needed (altitude <= 0m)."
        Set-Item -Path "Env:ASTRO_MOON_RISE_ADJ" -Value $env:ASTRO_MOON_RISE_RAW
        return
    }

    # Compute time correction (in minutes)
    $timeCorrection = [math]::Sqrt(2 * $altitude) / 15  # Formula approximation

    # Convert Moon rise time from string to DateTime
    try {
        $rawTime = [datetime]::ParseExact($env:ASTRO_MOON_RISE_RAW, "HH:mm", $null)
    }
    catch {
        Write-Host "ERROR: Invalid time format in ASTRO_MOON_RISE_RAW ($env:ASTRO_MOON_RISE_RAW)."
        return
    }

    # Apply correction
    $adjustedTime = $rawTime.AddMinutes(-$timeCorrection)

    # Store corrected rise time
    Set-Item -Path "Env:$adjRiseVar" -Value $adjustedTime.ToString("HH:mm")

    Write-Host "Elevation correction applied for ${CelestialBody}:"
    Write-Host " - Altitude: $altitude m"
    Write-Host " - Raw Rise Time: $rawRiseVar"
    Write-Host " - Adjusted Rise Time: $adjustedTime (Corrected for elevation)"
}
