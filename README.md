# MaSzyna Reloaded — Hugo

Jednostronicowy serwis projektu MaSzyna Reloaded, publikowany pod adresem [maszyna-reloaded.pl](https://maszyna-reloaded.pl/).

## Uruchomienie

Wymagany jest Hugo Extended 0.165 lub nowszy.

```bash
make runserver
```

Inny port można podać przez `PORT=1314 make runserver`.

Build produkcyjny:

```bash
make build
```

## Treść i materiały

- `layouts/index.html` — sekcje landing page'a i podpisy galerii.
- `layouts/_default/download.html` — instrukcja, ograniczenia, changelog i pliki aktualnego wydania.
- `data/changelog/<build>.yaml` — komplet danych wydania, w tym lista zmian, pliki, ograniczenia i mapa klawiszy.
- Strona pobierania automatycznie wybiera plik z najwyższym numerem buildu.
- Pliki można pobierać wyłącznie dla najnowszego buildu; szczegóły starszych wydań automatycznie kierują do aktualnej wersji.
- `hugo.toml` — linki społecznościowe i konfiguracja witryny.
- `assets/img/gallery/` — oryginalne zrzuty ekranu przetwarzane przez Hugo.
- `assets/img/` — lokalne obrazy i SVG publikowane z hashem zawartości; SVG są dodatkowo minifikowane.
- `assets/scss/main.scss` — cała warstwa wizualna.
- `assets/js/site.js` — menu mobilne, widgety i lightbox galerii; Hugo nadaje skryptowi wersjonowany adres.

Informacje o wykorzystanych materiałach zewnętrznych znajdują się w `THIRD_PARTY_NOTICES.md`.

## GitHub Pages

Workflow `.github/workflows/pages.yml` buduje witrynę po pushu na `main` lub `master`. W ustawieniach repozytorium należy wybrać **Settings → Pages → Source: GitHub Actions**. Plik `static/CNAME` przypisuje domenę `maszyna-reloaded.pl`.
