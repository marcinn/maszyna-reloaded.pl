# Zasady pracy w repozytorium

## Dodawanie wydań i changelogów

- Każde wydanie jest osobnym plikiem YAML w `data/changelog/<build>.yaml`. Nie twórz ręcznie strony w `content/`; strony `/changelog/<build>/` generuje adapter `content/changelog/_content.gotmpl`.
- Obowiązujący format numeru buildu to `YYYYmmdd-HHMM`, np. `20261001-0539`. Zachowaj myślnik w polu `build`, nazwie pliku, tytule i adresie strony.
- Numer buildu zapisany w treści dostarczonego changelogu jest ważniejszy niż nazwa pliku wejściowego, która może być błędna.
- Datę wydania wyprowadź z numeru buildu i zapisz jako `YYYY-MM-DD`. Pola `name` i `title` mają używać pełnej postaci `Pre-Alpha YYYY-MM-DD (build YYYYmmdd-HHMM)`; nie przedstawiaj samego numeru buildu jako nazwy wersji.
- Jako schematu użyj najnowszego pliku w `data/changelog/`, ale utwórz nowy plik. Nie zmieniaj danych historycznych przy dodawaniu kolejnego wydania.

### Linki do pobierania

- Każdy nowy release musi mieć własne, jawnie podane linki dla Windows 64-bit i Linux 64-bit. Nigdy nie kopiuj linków poprzedniego buildu jako domyślnych. Jeśli nowych linków nie ma w materiale od użytkownika, poproś o nie przed publikacją.
- Z linku Google Drive w postaci `https://drive.google.com/file/d/ID/view?...` utwórz bezpośredni adres `https://drive.usercontent.google.com/download?id=ID&export=download&confirm=t`.
- Zachowaj kolejność wpisów: Windows, potem Linux.
- Tylko najnowszy build ma być oferowany do pobrania. Starsze wpisy pozostają historią wydań; nie przywracaj dla nich przycisków pobierania w szablonach.
- Główne przyciski CTA „Pobierz” prowadzą do wersjonowanej strony najnowszego release’u `/changelog/<build>/`. Linki „Pobierz” w głównym menu i stopce pozostają pod `/pobierz/`. Nie stosuj query stringów do omijania cache.

### Treść wydania

- Pole `changes` ma zawierać zmiany wyłącznie z materiału dla danego buildu. Można poprawić oczywiste literówki, twarde spacje, interpunkcję i niezręczności językowe, ale nie dopisuj funkcji bez źródła.
- Zachowuj sens i poziom szczegółowości oryginału. Powiązane wpisy układaj obok siebie i stosuj spójne prefiksy kategorii, jeśli występują, np. `Symulacja:`, `HUD:` lub `Kabina:`.
- Sekcja zmian najnowszego buildu ma pozostać na początku strony pobierania, przed ostrzeżeniem instalacyjnym, z separatorem i odstępem przewidzianym w istniejącym layoucie.
- `limitations` należy do konkretnego buildu. Punktem wyjścia może być poprzednie wydanie, ale trzeba usunąć ograniczenia sprzeczne z nowym changelogiem i dodać tylko ograniczenia potwierdzone przez użytkownika lub materiał źródłowy. Nie trzymaj globalnej, sztywnej listy w szablonie.
- Zachowaj komunikat pre-alpha oraz instrukcję instalacji: pobrać ZIP, rozpakować wszystkie pliki do katalogu z oryginalną MaSzyną i uruchomić `reloaded.exe` z folderu gry.

### Mapa klawiszy

- Każdy plik release’u zawiera własną, kompletną sekcję `keymap`. `/pobierz/` wyświetla mapę najnowszego buildu, a szczegóły changelogu pokazują mapę właściwą dla danego wydania.
- Przy każdym nowym wydaniu porównaj mapę z bieżącym `~/Godot/MaSzyna-API-wrapper/demo/project.godot`, przede wszystkim z sekcją `[input]`.
- Grupowanie interfejsu sprawdzaj również w `~/Godot/MaSzyna-API-wrapper/demo/hud/help.gd` i `hud/help.tscn`. Nie polegaj wyłącznie na tych plikach: skróty obsługiwane poza listą akcji, np. `Esc`, mogą wynikać z changelogu lub kodu.
- Skopiowanie mapy poprzedniego buildu jest tylko punktem wyjścia. Dodaj nowe akcje, usuń nieaktualne i popraw zmienione kombinacje klawiszy.
- Używaj polskich, użytkowych opisów. Pisz `Bateria`, nie `Akumulator`. Nie dopisuj końcówki „— przełącz”; dla osobnych operacji używaj form `Włączenie ...` i `Wyłączenie ...`.
- Zachowuj istniejące grupy: `Pojazd`, `Gracz i widoki` oraz `Interfejs`, a funkcje układaj w odpowiedniej sekcji tematycznej.

### Kontrola przed przekazaniem

- Sprawdź czystość drzewa przed pracą i nie nadpisuj niezwiązanych zmian użytkownika.
- Uruchom `make build` oraz `git diff --check`.
- W wygenerowanym `public/` sprawdź co najmniej:
  - istnienie `/changelog/<build>/`,
  - wyświetlanie nowego buildu na `/pobierz/`,
  - wskazywanie strony głównej na najnowszy, wersjonowany changelog,
  - oba właściwe identyfikatory plików Google Drive,
  - obecność zmian, ograniczeń i kompletnej mapy klawiszy.
- Ostrzeżenie Hugo o wycofaniu `libsass` jest obecnie znane i nie oznacza nieudanego buildu.
- Nie wykonuj `git commit` ani `git push`, dopóki użytkownik wyraźnie o to nie poprosi.
