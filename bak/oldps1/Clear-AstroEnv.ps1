function Clear-AstroEnv {
    # Get all environment variables starting with "ASTRO_"
    $astroVars = Get-ChildItem Env: | Where-Object { $_.Name -like "ASTRO_*" }

    if ($astroVars.Count -eq 0) {
        Write-Host "No ASTRO_* environment variables found."
        return
    }

    # Remove each found variable
    foreach ($var in $astroVars) {
        Remove-Item -Path "Env:$($var.Name)"
        Write-Host "Cleared: $($var.Name)"
    }

    Write-Host "All ASTRO_* environment variables have been cleared."
}
