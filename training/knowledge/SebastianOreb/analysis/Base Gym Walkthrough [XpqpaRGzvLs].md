# Base Gym Walkthrough [XpqpaRGzvLs]

## Metadane
| Pole | Wartość |
|---|---|
| Autor | Sebastian Oreb |
| Typ materiału | analiza infrastruktury obiektu treningowego dla sportów siłowych |
| Kontekst | prezentacja wyposażenia `Base Gym` w Sydney; uzasadnienie doboru sprzętu pod `powerlifting`, częściowo `weightlifting` i przygotowanie ogólnosiłowe |
| Główna wartość materiału | logika selekcji sprzętu, standaryzacja warunków startowych, projektowanie stref pod ciężkie boje |

## Założenia projektowe obiektu
- Priorytet: maksymalna zgodność środowiska treningowego z warunkami startowymi w zawodach siłowych.
- Filozofia doboru sprzętu: używać w treningu dokładnie tych typów stanowisk, sztang i ławek, które pojawiają się na zawodach.
- Priorytet infrastrukturalny: trzy główne platformy bojowe o identycznej geometrii i wypoziomowaniu.
- Priorytet operacyjny: możliwość równoczesnej pracy wielu zawodników bez konfliktu o sprzęt startowy.
- Priorytet bezpieczeństwa: wysoka nośność konstrukcji, powierzchnie przygotowane pod zrzut dużych obciążeń, zabezpieczenia dla ekstremalnych ciężarów.

## Architektura stref bojowych
| Element | Specyfikacja | Funkcja praktyczna |
|---|---|---|
| Liczba głównych platform | `3` | równoległa praca zawodników; jednolite środowisko do bojów głównych |
| Poziomowanie | platformy wypoziomowane indywidualnie | eliminacja toczenia sztangi; powtarzalny kontakt sztangi z podłożem |
| Materiał centralny | drewniany insert `Eleiko` | sztywna, przewidywalna strefa kontaktu |
| Materiał boczny | wysokiej jakości guma | tłumienie energii, ochrona podłoża i sprzętu |
| Zakres użycia | `powerlifting`, częściowo `weightlifting`, ciężkie zrzuty | szeroka kompatybilność przy zachowaniu specyficzności |

## Platforma 1: `IPF combo rack`
- `IPF combo rack` wskazany jako „gold standard” dla stanowiska bojowego w `powerlifting`.
- Konfiguracja `all-in-one`: możliwość usunięcia ławki i przekształcenia stanowiska w rack do przysiadu.
- Stanowisko wykorzystywane jako główna strefa ekspozycji na warunki startowe.
- Powiązana sztanga: `Eleiko IPF-spec powerlifting bar` z czerwonym oznaczeniem końców.

## Platforma 2: squat stand + bar do przysiadu
- Stojaki do przysiadu `Eleiko` używane mimo internetowej krytyki dotyczącej rzekomej „wiotkości”; autor podkreśla praktyczną nośność pod bardzo ciężkie przysiady.
- Główna sztanga: `Goliath squat bar`.
- Parametry funkcjonalne sztangi:
  - masa: `25 kg`
  - większa średnica chwytu
  - agresywniejszy `knurling`
  - przeznaczenie: bardzo duże obciążenia w przysiadzie
- Potwierdzony przykład obciążenia: `420 kg` przysiadu Grahama Hicksa na tym typie stanowiska.

## Platforma 3: `mono rack` / `mono lift`
- Zastosowanie: bardzo ciężkie przysiady bez konieczności `walkout`.
- Mechanizm: po wyjęciu sztangi uchwyty/ruchome ramiona odsuwają stanowisko od zawodnika.
- Główna korzyść: redukcja kosztu stabilizacji i ryzyka utraty pozycji podczas wyjścia z ciężarem.
- Zabezpieczenia: ciężkie liny bezpieczeństwa.
- Zweryfikowana nośność praktyczna zabezpieczeń: przechwycenie zrzutu `365 kg`.
- Główna funkcja: bezpieczna ekspozycja na ekstremalne obciążenia osiowe.

## System sztang i standaryzacja
### Sztangi `powerlifting`
- Oznaczenie wizualne: czerwone końcówki / czerwony marker.
- Standard: `IPF spec`.
- Masa: `20 kg`.
- Zastosowanie: `bench press`, część przysiadów i martwych ciągów zależnie od federacji.
- Cel doboru: trening na dokładnie takim bodźcu mechanicznym, jaki występuje podczas startu.

### Sztangi `weightlifting`
- Oznaczenie wizualne: niebieskie końcówki / niebieski marker.
- Standard: `IWF spec`.
- Masa: `20 kg`.
- Zastosowanie: `snatch`, `clean & jerk`.
- Uzasadnienie obecności w obiekcie: obiekt nie jest wyłącznie siłownią trójbojową; zachowano kompatybilność z podnoszeniem ciężarów.

### Sztangi `squat-specific`
- Marka: `Goliath`.
- Masa: `25 kg`.
- Właściwości: grubszy trzon, większa agresja chwytu, wyższa stabilność przy dużych ciężarach.
- Uzasadnienie: zgodność z częścią zawodów rozgrywanych lokalnie; poprawa stabilności przy bardzo ciężkich przysiadach.
- Logika mechaniczna: gruba sztanga + cienkie talerze zmniejszają „chatter” zestawu i ograniczają kołysanie ładunku.

### Dodatkowe sztangi
- Obecność sztang zapasowych pod wielu zawodników i równoległe serie.
- Obecność lekkiej sztangi technicznej `10 kg` do nauki wzorców ruchowych i pracy z młodszymi/nowymi zawodnikami.

## System obciążeń
### Talerze `weightlifting`
- Typ: bumper plates `Eleiko`.
- Kalibracja: deklarowana zgodność realnej masy z oznaczeniem.
- Przeznaczenie: zrzut z pozycji nad głową.
- Funkcja: ochrona podłoża i sztangi przy bojach olimpijskich.

### Talerze `powerlifting`
- Typ: cienkie talerze metalowe.
- Cel konstrukcyjny: możliwość załadowania większej masy absolutnej na gryf.
- Uzasadnienie: w bojach trójbojowych nie przewiduje się zrzutu z pozycji nad głową, więc priorytetem jest kompaktowość i możliwość załadowania maksymalnego tonażu.
- Efekt praktyczny: masa bliżej środka sztangi, mniejsza niestabilność zestawu przy ciężkich przysiadach.

## Sekcja hantli i ławek
### Hantle
- Marka: `Watson`.
- Zakres: od `5 kg` do `80 kg`.
- Skoki:
  - do `50 kg`: co `2.5 kg`
  - od `55 kg` do `80 kg`: co `5 kg`
- Wybrany wariant chwytu: `medium handle`.
- Wybrany wariant mechaniczny: rękojeści nierotujące.
- Logika doboru uchwytu: zbyt gruby chwyt przy `80 kg` zwiększałby próg wejścia i ograniczał praktyczne wykorzystanie hantli przez bardzo silnych zawodników.

### Ławki
- Marka: `Watson`.
- Charakterystyka: bardzo ciężkie, głośne, ale skrajnie stabilne.
- Cel: zapewnienie sztywnej podstawy wsparcia dla ciężkiego `dumbbell press`.
- Priorytet konstrukcyjny: stabilność nad mobilnością sprzętu.

## Sekcja maszynowa
### `Bench press`
- Stanowisko startowe: `AMFX Dominator`.
- Uzasadnienie: to model używany w zawodach, w których autor i lokalni zawodnicy startują.
- Zasada doboru: nie „najlepsza” ławka abstrakcyjnie, lecz dokładnie ta, której używa się podczas startu.

### Maszyny akcesoryjne
- W materiale potwierdzono obecność strefy maszynowej i akcesoryjnej.
- Materiał semantycznie wskazuje `Atlantis` dla części maszyn, ale w udostępnionych czytelnych fragmentach transkryptu nazwa ta nie jest jednoznacznie słyszalna; nie należy traktować tego jako w pełni pewnego faktu bez dodatkowej weryfikacji audio.

## Reguły projektowe wynikające z materiału
1. Środowisko treningowe dla sportów siłowych powinno minimalizować różnicę między treningiem a startem.
2. Wypoziomowanie stanowisk bojowych nie jest detalem estetycznym, lecz warunkiem powtarzalności mechaniki podniesienia.
3. Dobór sprzętu należy opierać na profilu obciążeń: inny system pod zrzuty z góry, inny pod maksymalny tonaż w `powerlifting`.
4. Sprzęt dla elity musi być używalny praktycznie; zbyt „utrudnione” rozwiązania ograniczają ekspozycję na pożądany bodziec.
5. Nadmiar różnorodności sprzętowej zwiększa zmienność bodźca; autor preferuje standaryzację marek i parametrów.

## Ograniczenia materiału
- Materiał ma charakter infrastrukturalny, nie programistyczny; nie zawiera szczegółów periodyzacji ani doboru objętości.
- Część nazw marek i modeli w dalszych segmentach jest częściowo zaszumiona przez hałas otoczenia i automatyczną transkrypcję.
- Subiektywne oceny typu „najlepsze na świecie” mają wartość opinii użytkownika sprzętu, nie obiektywnego testu porównawczego.