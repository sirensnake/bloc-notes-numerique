document.addEventListener("DOMContentLoaded", function () {
  // Gestion des menus déroulants
  const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
  
  dropdownToggles.forEach(toggle => {
    toggle.addEventListener('click', function() {
      const parentLi = this.parentElement;
      parentLi.classList.toggle('show');
      
      // Fermer les autres menus déroulants
      dropdownToggles.forEach(otherToggle => {
        if (otherToggle !== toggle) {
          otherToggle.parentElement.classList.remove('show');
        }
      });
    });
  });
  
  // Fermer les menus déroulants en cliquant ailleurs
  document.addEventListener('click', function(event) {
    if (!event.target.closest('.dropdown')) {
      dropdownToggles.forEach(toggle => {
        toggle.parentElement.classList.remove('show');
      });
    }
  });
});