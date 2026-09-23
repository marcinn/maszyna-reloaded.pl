(() => {
  const navToggle = document.querySelector('.nav-toggle');
  const nav = document.querySelector('.main-nav');

  const closeNav = () => {
    if (!navToggle || !nav) return;
    navToggle.setAttribute('aria-expanded', 'false');
    nav.classList.remove('is-open');
  };

  if (navToggle && nav) {
    navToggle.addEventListener('click', () => {
      const willOpen = navToggle.getAttribute('aria-expanded') !== 'true';
      navToggle.setAttribute('aria-expanded', String(willOpen));
      nav.classList.toggle('is-open', willOpen);
    });

    nav.querySelectorAll('a').forEach((link) => link.addEventListener('click', closeNav));
  }

  const downloads = [...document.querySelectorAll('[data-download]')];

  const closeDownloads = (except) => {
    downloads.forEach((download) => {
      if (download === except) return;
      const toggle = download.querySelector('[data-download-toggle]');
      const menu = download.querySelector('[data-download-menu]');
      toggle?.setAttribute('aria-expanded', 'false');
      if (menu) menu.hidden = true;
    });
  };

  downloads.forEach((download) => {
    const toggle = download.querySelector('[data-download-toggle]');
    const menu = download.querySelector('[data-download-menu]');
    if (!toggle || !menu) return;

    toggle.addEventListener('click', () => {
      const willOpen = toggle.getAttribute('aria-expanded') !== 'true';
      closeDownloads(download);
      toggle.setAttribute('aria-expanded', String(willOpen));
      menu.hidden = !willOpen;
      if (willOpen) menu.querySelector('a')?.focus();
    });
  });

  document.addEventListener('click', (event) => {
    if (!event.target.closest('[data-download]')) closeDownloads();
    if (nav && navToggle && !event.target.closest('.header-inner')) closeNav();
  });

  document.addEventListener('keydown', (event) => {
    if (event.key !== 'Escape') return;
    closeDownloads();
    closeNav();
  });
})();
