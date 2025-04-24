<#
.SYNOPSIS
  Corrige l'encodage et les artefacts dans les fichiers HTML de fiches.
.DESCRIPTION
  - Supprime le BOM UTF-8 et les séquences littérales "`n".
  - Assure la présence de <meta charset="utf-8" /> dans le <head>.
  - Enlève tout bloc <style>...</style> inline.
  - Supprime les balises <script> nav.js et <nav id="main-nav"> résiduelles.
#>

$folder = "fiches"
Get-ChildItem -Path $folder -Filter "fiche-*.html" | ForEach-Object {
    $file = $_.FullName
    Write-Host "Traitement de $file"

    # Lire en UTF8 sans BOM
    $html = Get-Content -Path $file -Encoding UTF8 -Raw

    # Supprimer BOM s'il existe
    $html = $html.TrimStart([char]0xFEFF)

    # Retirer les artefacts de newlines littéraux
    $html = $html -replace "`n", ""

    # S'assurer meta charset utf-8 dans head
    if ($html -notmatch '(?i)<meta\s+charset="utf-8"') {
        $html = $html -replace '(?i)(<head>)', '$1`n  <meta charset="utf-8" />'
    }

    # Supprimer tous les blocs <style>...</style>
    $html = [Regex]::Replace($html, '(?s)<style>.*?</style>', '', [Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Supprimer les scripts nav.js injectés
    $html = [Regex]::Replace($html, '(?s)<script[^>]*nav\.js.*?</script>', '', [Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Supprimer nav id="main-nav" résiduel
    $html = [Regex]::Replace($html, '(?s)<nav[^>]*id="main-nav".*?</nav>', '', [Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Réécrire le fichier sans BOM
    Set-Content -Path $file -Value $html -Encoding UTF8
    Write-Host "✓ $file corrigé"
}
