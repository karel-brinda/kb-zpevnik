# kb-zpevnik

Repozitář obsahuje podklady pro sazbu osobního zpěvníku a příbuzných variant. Aktivní konfigurace zpěvníků
jsou definované v souborech `Snakefile.*` (např. `Snakefile.karel_zpevnik` je hlavní zpěvník, `Snakefile.test`
je minimální ukázková/testovací konfigurace).

Co tento systém umožňuje:
* Sestavit existující zpěvníky.
* Opravit chyby v písních nebo sazbě.
* Vytvořit si vlastní zpěvník na bázi existujících písní.
* Transponovat jednotlivé písně do jiné tóniny.

## Jak je repozitář uspořádán

* `songs/` - texty a akordy písní rozdělené do 3 kategorií podle jazyka:
  * `01_english` - anglické písně
  * `02_french_spanish` - francouzské, španělské a ostatní románské/cizojazyčné písně (viz níže)
  * `03_czech` - české a slovenské písně
* `Snakefile.*` - soubory definující jednotlivé zpěvníky
* `tpcb/` - společná sazební logika, LaTeX šablony a generování rejstříků
* `output/` - výstupní soubory

Jazyk se určuje podle skutečného jazyka textu písně (ne podle národnosti interpreta) - např. anglická
verze písně od neanglického interpreta patří do `01_english`. Písně v jazyce, který nemá vlastní kategorii
(např. ruština, italština, portugalština), se řadí do `02_french_spanish` jako obecná kategorie
"ostatní cizojazyčné".

## Požadavky

### Prostředí

Preferované prostředí je Linux nebo macOS (build ale může fungovat i na Windows).


### Potřebný software

* Python 3 a `pip`
* [Snakemake](https://snakemake.readthedocs.io/)
* LuaLaTeX
* Git
* Česká locale pro správné řazení:
  * `cs_CZ.UTF-8`
  * případně systémový alias `czech`

Instalace pythonových závislostí:

```bash
python3 -m pip install -r requirements.txt
```

Poznámky:
* Rejstříky i pomocné generátory spoléhají na české řazení, takže bez české locale může být build chybný nebo skončí chybou.
* Pro webový výstup v `output/` jsou navíc potřeba `ghostscript` a `pdfcrop`.


## Jak sestavit zpěvníky

1. Naklonujte repozitář:

```bash
git clone https://github.com/karel-brinda/kb-zpevnik
cd kb-zpevnik
```

2. Nainstalujte Python závislosti:

```bash
python3 -m pip install -r requirements.txt
```

3. Ujistěte se, že máte aktivní českou locale, například:

```bash
export LANG=cs_CZ.UTF-8
export LC_ALL=cs_CZ.UTF-8
```

4. Sestavte požadovaný zpěvník:

```bash
snakemake -p -s Snakefile.karel_zpevnik --cores all
```

Výstup vznikne v `output/`, například `output/karel_zpevnik.pdf`. Rychlý zástupce pro otevření hlavního
zpěvníku po sestavení: `make view`.

### Sestavení více zpěvníků

Všechny `Snakefile.*` konfigurace lze spustit například jako:

```bash
make -j
```


## Webový výstup

Webový výstup se generuje z PDF souborů v adresáři `output/`. Po sestavení zpěvníků stačí spustit:

```bash
make -C output
```

Tím vznikne:
* ořezaná PDF `*.tablet.pdf`
* `output/index.html`
* `output/Snakefile.sablona`


## Jak opravit chybu v písni

1. Opravte příslušný soubor v `songs/`.
2. Zpěvník znovu přeložte (`snakemake -p -s Snakefile.karel_zpevnik --cores all`) a vizuálně zkontrolujte výsledek.
3. Odešlete změny:

```bash
git add jmeno_upraveneho_souboru.tex
git commit -m "Krátký popis změny"
git push
```

## Jak přidat novou píseň

Postupujte obdobně jako při opravě chyby. Dodržujte, prosím, logiku celého zpěvníku:

1. **Pojmenujte píseň a zařaďte ji do správné jazykové kategorie**
      * Vzor: `Cele_Jmeno_Interpreta____Jmeno_pisne.tex`, umístěný do `songs/01_english/`, `songs/02_french_spanish/`
        nebo `songs/03_czech/` podle jazyka textu (viz sekce výše).
      * Jestliže se jiná píseň od interpreta ve zpěvníku už vyskytuje, ověřte, že je jeho jméno v přesně stejné formě.
      * V případě nejistoty si ověřte křestní jméno nebo pravopis na Google.
      * Jména písní by měla mít velké jen první písmeno a pak tam, kde patří podle jiných pravidel (vlastní jména, anglické dny v týdnu a měsíce apod.)
      * Dodržujte přesně čtyři podtržítka mezi jménem interpreta a názvem písně.
2. **Vložte text**
      * České a slovenské písně by měly mít texty psané jako celé věty včetně kompletní interpunkce, zalámané do veršů.
      * Anglické, francouzské a ostatní cizojazyčné písně mají velké písmeno na začátku každé řádky a interpunkce na jejich koncích (kromě té se speciálním významem), včetně tečky na konci věty, se ruší.
      * Zkontrolujte překlepy v textovém editoru nebo pomocí LLM.
      * "Sólo", "předehra" / "intro", "mezihra" a podobné nepotřebují text a vlastní `\zs ... \ks` (výjimkou je sloka nahrazená sólem beze zpívání). Stačí v odpovídajícím místě napsat řadu akordů s prázdným textem; delší výdrž bez textu lze značit pomocí `~~~`.
3. **Vložte akordy**
      * Do jedné značky `<...>` vkládejte právě jeden akord (jinak program ohlásí neznámý formát akordové značky).
      * Ověřte správnost akordů a jejich umístění nad začátky slabik (ideálně podle originální nahrávky, ne jen podle prvního tabu, který najdete).
      * Pro všechny písně včetně cizojazyčných používejte důsledně české/německé značení akordů:
        * `H` = B (anglicky "B natural"), `B` = B♭ (anglicky "Bb") - nikdy nepoužívejte anglické `Bb`.
        * Ostatní bemoly pište německy: `Es` (Eb), `As` (Ab), `Des` (Db), `Ges` (Gb) - nikdy `Eb`, `Ab` apod.
        * `A#=B`, `A##=H`, `B#=H` - enharmonické zápisy blízké tónu H převádějte na `H`/`B`.
      * Mollové akordy zapisujte vždy s příponou `mi`, nikdy anglickým `m`: `Ami`, `Dmi7`, `Emi`, `Gmi` apod.
        V rámci jedné písně nemíchejte `Am`/`Ami` styl - buď důsledně jedno, nebo druhé (preferovaně `Ami`).
      * Před dokončením zkontrolujte přes `grep -oE '<[A-Za-z#0-9/]+>' soubor.tex | sort -u`, že se ve stejné písni nevyskytují ekvivalentní zápisy stejného akordu v různých stylech (např. `Am` i `Ami`, nebo `B` i `Bb`).
4. **Zpěvník znovu přeložte** a **vizuálně zkontrolujte** výsledek.
5. **Zařaďte píseň do zpěvníku (`Snakefile.karel_zpevnik`)**
      * Aktivní písně jsou v `songs = [...]` jako obyčejné řetězce (transpozice 0) nebo dvojice `("cesta", N)` (transpozice o N půltónů).
      * Neaktivní/nepoužité písně se drží zakomentované pod aktivním seznamem (`# ---- unused songs ... ----`) ve formě `#   ("songs/.../Soubor.tex", 0),`, seřazené abecedně podle cesty - tento seznam by měl být vyčerpávající, tj. pokrývat úplně všechny `.tex` soubory v `songs/`, které nejsou aktivní.
      * Pokud chcete píseň z konkrétního zpěvníku jen dočasně vyřadit (ne smazat), přesuňte její řádek z aktivního seznamu do zakomentovaného, nemažte soubor.
      * Skutečné smazání písně (soubor už nikde nemá být, ani v komentářích) = smazat `.tex` soubor a zároveň smazat jeho řádek úplně (nepřidávat do zakomentovaného seznamu).
6. **Pokud píseň přetéká** na druhou stránku, postupujte následovně:
      * Pokud přetéká jen o několik řádků, zkuste ji zkrátit nebo přeskládat tak, aby se vešla na jednu A4 celou.
      * Sekvenci akordů, které se v průběhu písně nebo v jejích částech opakuje v přesně stejném sledu, stačí napsat jen jednou (pomocí prázdného `\zr\kr` pro opakování stejného refrénu).
      * Řádky od druhé sloky dále pospojovat po dvou nebo po celých slokách.
      * Zkrátit opakovaný text pomocí repetic `/: ... :/` nebo tří teček, refrény vynechat.
      * Vynechat od druhé sloky dále výplně jako u Zítra ráno v pět nebo u Milionáře od Nohavici.
      * Když se vtěsnat na jednu stránku nepovede, využijte dobře prostor obou stránek. Je možno i ponechat na výběr dvě verze (viz Veličenstvo Kat).


## Jak vytvořit vlastní zpěvník

Nejjednodušší je vyjít ze `Snakefile.test` nebo si nechat vygenerovat šablonu:

```bash
python3 vygeneruj_novy_zpevnik.py > Snakefile.muj
```

Minimální vlastní `Snakefile.muj` může vypadat takto:

```python
# -*-coding: utf-8 -*-

left_page_head = "Levá hlavička"
right_page_head = "Pravá hlavička"
chordbook = "muj_novy_zpevnik"

options = [
    "ONESIDE",
]

songs = [
    ("songs/01_english/Beatles____Let_it_be.tex", 5),
    "songs/01_english/Beatles____Love_me_do.tex",
]

include: "tpcb/include.smk"


rule all:
    input:
        run(),
```

Pak spusťte:

```bash
snakemake -p -s Snakefile.muj --cores all
```

Hlavní výstup bude v:

```text
output/muj_novy_zpevnik.pdf
```

### Jednotlivé písně jako samostatná PDF

Pokud chcete vygenerovat i jednotlivé písně zvlášť, přidejte do `options` položku `"SINGLES"`:

```python
options = [
    "SINGLES",
    "ONESIDE",
]
```

Pak vzniknou i soubory v adresáři:

```text
output/muj_novy_zpevnik_singles/
```


## Přehled značek

* `\zp{jméno písně}{autor písně nebo interpret}`: začátek písně
* `\kp`: konec písně
* `\zr`: začátek refrénu
* `\kr`: konec refrénu
* `\zs`: začátek sloky
* `\ks`: konec sloky
* `<Dmi>Text`: akord nad následujícím textem
* `~~~`: výplň pro delší výdrž akordu bez textu

## Poznámky

* Pořadí písní i rejstříků je citlivé na správně nastavenou českou locale.
* Po jakékoli změně v `songs/` nebo v `Snakefile.*` vždy zpěvník znovu přeložte, abyste odhalili syntaktické chyby (neznámý formát akordu apod.) dřív, než skončí v gitu.

## Podobné zpěvníky

* [VOC songbook](https://github.com/ababaian/VOCsongbook)
