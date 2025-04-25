# Corrige les caractères encodés corrompus dans les fichiers HTML
# Et remplace la section <nav> par celle de index.html

# Chargement du menu HTML depuis index.html
$indexPath = ".\index.html"
$indexContent = Get-Content $indexPath -Raw
$menuHtml = [regex]::Match($indexContent, "<nav>.*?</nav>", "Singleline").Value

# Liste des remplacements à effectuer
$remplacements = @{
    "Ã¢â‚¬â„¢" = "'"
    "Ã¢â‚¬Å“" = '"'
    "Ã¢â‚¬Â" = '"'
    "Ã¢â‚¬â€œ" = "-"
    "Ã¢â‚¬â€" = "--"
    "Ã¢â‚¬Â¦" = "..."
    "Ã‚"       = ""
    "â€™"     = "'"
    "â€œ"     = '"'
    "â€"     = '"'
    "â€“"     = "-"
    "â€”"     = "--"
    "â€¦"     = "..."
    "Â"       = ""
}

# Parcours des fichiers HTML du dossier "fiches"
Get-ChildItem -Path ".\fiches" -Filter "*.html" | ForEach-Object {
    $fiche = $_.FullName
    $content = Get-Content $fiche -Raw

    # Application des remplacements
    foreach ($cle in $remplacements.Keys) {
        $content = $content -replace [regex]::Escape($cle), $remplacements[$cle]
    }

    # Remplacement du menu <nav>
    $content = [regex]::Replace($content, "<nav>.*?</nav>", $menuHtml, "Singleline")

    # Sauvegarde avec encodage UTF8
    Set-Content -Path $fiche -Value $content -Encoding UTF8

    Write-Host "✅ Corrigé : $($fiche)"
}
