function Log-ObservedRiseSet {
    param(
        [ValidateSet("Moon", "Sun")]
        [string]$CelestialBody,  # Choose Moon or Sun

        [string]$ObservedTime,    # Manually entered rise time (HH:mm format)

        [string]$ObservedAzimuth  # Optional: If known (compass, app, etc.)
    )

    # Determine the computed rise time variable
    $computedVar = if ($CelestialBody -eq "Moon") { "ASTRO_MOON_RISE_FINAL" } else { "ASTRO_SUN_RISE_FINAL" }

    # Check if the computed rise time exists
    if (-not (Get-Item -Path "Env:$computedVar" -ErrorAction SilentlyContinue)) {
        Write-Host "ERROR: No computed rise time for $CelestialBody found. Run relevant rise/set functions first."
        return
    }

    # Default log file location
    $logFile = "$HOME/Himinhvelfing/rise_set_log.csv"

    # Ensure observed time is in correct format (HH:mm)
    if ($ObservedTime -notmatch "^\d{2}:\d{2}$") {
        Write-Host "ERROR: Invalid time format. Please enter as HH:mm (e.g., '06:45')."
        return
    }

    # Get current date
    $date = (Get-Date).ToString("yyyy-MM-dd")

    # Default to "Unknown" if azimuth is not provided
    if (-not $ObservedAzimuth) {
        $ObservedAzimuth = "Unknown"
    }

    # Retrieve computed rise time
    $computedRiseTime = Get-Item -Path "Env:$computedVar" | Select-Object -ExpandProperty Value

    # Create log entry
    $logEntry = [PSCustomObject]@{
        Date             = $date
        CelestialBody    = $CelestialBody
        ObservedTime     = $ObservedTime
        ObservedAzimuth  = $ObservedAzimuth
        ComputedRiseTime = $computedRiseTime
    }

    # Save to CSV (Append Mode)
    $logEntry | Export-Csv -Path $logFile -Append -NoTypeInformation

    Write-Host "Logged $CelestialBody rise observation:"
    Write-Host " - Date: $date"
    Write-Host " - Observed Time: $ObservedTime"
    Write-Host " - Observed Azimuth: $ObservedAzimuth"
    Write-Host " - Computed Rise: $computedRiseTime"
    Write-Host "Data saved to: $logFile"
}
