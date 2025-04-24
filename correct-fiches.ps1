<#
.SYNOPSIS
  Script pour corriger automatiquement les fichiers HTML de fiches selon le modèle unifié.
.DESCRIPTION
  Ce script remplace l'entête (header + nav principal) et supprime les styles inline
  pour harmoniser toutes les fiches dans le répertoire 'fiches'.
#>

# Chemin vers le répertoire contenant les fiches
$folder = "fiches"

# Modèle d'entête retiré de fiche-template.html
$headerTemplate = @'
  <header class="banner">
    <div class="banner-container">
      <img src="../img/banner.png" alt="Bannière du site" class="banner-img">
    </div>
    <h1>📘 {0}</h1>
    <nav>
      <ul>
        <li><a href="../index.html">🏠 Accueil</a></li>
        <li><a href="fiche-git.html">🔧 Git</a></li>
        <li><a href="fiche-chocolatey.html">🍫 Chocolatey</a></li>
        <li><a href="fiche-modele.html">📋 Modèle</a></li>
        <li><a href="fiche-linux.html">🐧 Linux</a></li>
        <li><a href="fiche-python.html">🐍 Python</a></li>
        <li><a href="fiche-docker.html">🐳 Docker</a></li>
        <li><a href="fiche-powershell.html">⚡ PowerShell</a></li>
        <li><a href="fiche-vboxmanage.html">🖥️ VBoxManage</a></li>
        <li><a href="fiche-vboxmanage-interactive.html">🖥️ VBoxInteractif</a></li>
      </ul>
    </nav>
  </header>
'@

# Parcours des fichiers fiche-*.html
Get-ChildItem -Path $folder -Filter "fiche-*.html" | ForEach-Object {
    $file = $_.FullName
    Write-Host "Traitement de $file"
    $html = Get-Content $file -Raw

    # Extraire le titre de la page entre <h1> et </h1>
    if ($html -match '<h1>(.*?)</h1>') {
        $title = $Matches[1]
    } else {
        $title = 'Titre'
    }

    # Supprimer tout <style>...</style> dans le header
    $html = [Regex]::Replace($html, '(?s)<header.*?<\/header>', '', [Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Supprimer les styles inline restant
    $html = [Regex]::Replace($html, '(?s)<style>.*?<\/style>', '', [Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Construire le nouvel header
    $newHeader = [String]::Format($headerTemplate, $title)

    # Insérer le nouvel header après <body>
    $html = [Regex]::Replace($html, '(?s)(<body[^>]*>)', '${1}`n'+$newHeader, [Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Écrire le fichier mis à jour
    Set-Content -Path $file -Value $html -Encoding UTF8
    Write-Host "✓ $file mis à jour"
}
