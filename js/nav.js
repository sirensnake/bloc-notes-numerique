// js/nav.js
document.addEventListener('DOMContentLoaded', () => {
    fetch('../partials/nav.html')
      .then(resp => resp.text())
      .then(html => {
        const nav = document.getElementById('main-nav');
        nav.innerHTML = html;
  
        // Marquer le lien actif
        const current = window.location.pathname.split('/').pop();
        nav.querySelectorAll('a').forEach(a => {
          if (a.getAttribute('href') === current) {
            a.classList.add('active');
          }
        });
      })
      .catch(err => console.error('Impossible de charger le menu :', err));
  });
  