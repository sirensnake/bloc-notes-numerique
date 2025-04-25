# Lire le nav de index.html
$indexFile = "index.html"
$indexContent = Get-Content $indexFile -Raw
$navBlock = [regex]::Match($indexContent, "<nav>.*?</nav>", "Singleline").Value

# Répertoire des fiches
$fichesDir = "fiches"

# Boucle sur toutes les fiches
Get-ChildItem -Path $fichesDir -Filter *.html | ForEach-Object {
    $filePath = $_.FullName
    $original = Get-Content $filePath -Raw

    # Sauvegarde du fichier original
    Copy-Item $filePath "$filePath.bak"

    # Remplace le bloc <nav> uniquement si trouvé
    if ($original -match "<nav>.*?</nav>") {
        $updated = [regex]::Replace($original, "<nav>.*?</nav>", $navBlock, "Singleline")
        Set-Content -Path $filePath -Value $updated -Encoding utf8NoBOM
        Write-Host "✅ Menu mis à jour dans $($_.Name)"
    } else {
        Write-Host "⚠️ Aucune balise <nav> trouvée dans $($_.Name)"
    }
}
