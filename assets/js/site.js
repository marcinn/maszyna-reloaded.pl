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

  const lightbox = document.querySelector('[data-lightbox-dialog]');
  const lightboxLinks = [...document.querySelectorAll('[data-lightbox]')];

  if (lightbox && lightboxLinks.length) {
    const image = lightbox.querySelector('[data-lightbox-image]');
    const caption = lightbox.querySelector('[data-lightbox-caption]');
    const closeButton = lightbox.querySelector('[data-lightbox-close]');
    const previousButton = lightbox.querySelector('[data-lightbox-previous]');
    const nextButton = lightbox.querySelector('[data-lightbox-next]');
    let activeIndex = 0;
    let returnFocus = null;

    const showImage = (index) => {
      activeIndex = (index + lightboxLinks.length) % lightboxLinks.length;
      const link = lightboxLinks[activeIndex];
      const text = link.dataset.caption || link.querySelector('img')?.alt || '';
      image.src = link.href;
      image.alt = text;
      caption.textContent = text;
    };

    const openLightbox = (index, trigger) => {
      returnFocus = trigger;
      showImage(index);
      lightbox.showModal();
      document.body.classList.add('lightbox-open');
      closeButton?.focus();
    };

    const closeLightbox = () => {
      if (lightbox.open) lightbox.close();
    };

    lightboxLinks.forEach((link, index) => {
      link.addEventListener('click', (event) => {
        event.preventDefault();
        openLightbox(index, link);
      });
    });

    closeButton?.addEventListener('click', closeLightbox);
    previousButton?.addEventListener('click', () => showImage(activeIndex - 1));
    nextButton?.addEventListener('click', () => showImage(activeIndex + 1));

    lightbox.addEventListener('click', (event) => {
      if (event.target === lightbox) closeLightbox();
    });

    lightbox.addEventListener('keydown', (event) => {
      if (event.key === 'ArrowLeft') showImage(activeIndex - 1);
      if (event.key === 'ArrowRight') showImage(activeIndex + 1);
    });

    lightbox.addEventListener('close', () => {
      document.body.classList.remove('lightbox-open');
      image.removeAttribute('src');
      returnFocus?.focus();
    });
  }
})();
