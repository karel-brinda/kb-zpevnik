# kb-zpevnik

Pravidla pro organizaci souborů, pojmenování a sazbu písní v tomto zpěvníku.

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

## Jak pojmenovat a připravit novou píseň

1. **Pojmenování souboru a zařazení**
      * Vzor: `Cele_Jmeno_Interpreta____Jmeno_pisne.tex`, umístěný do `songs/01_english/`, `songs/02_french_spanish/`
        nebo `songs/03_czech/` podle jazyka textu.
      * Jestliže se jiná píseň od interpreta ve zpěvníku už vyskytuje, ověřte, že je jeho jméno v přesně stejné formě.
      * V případě nejistoty si ověřte křestní jméno nebo pravopis na Google.
      * Jména písní by měla mít velké jen první písmeno a pak tam, kde patří podle jiných pravidel (vlastní jména, anglické dny v týdnu a měsíce apod.)
      * Dodržujte přesně čtyři podtržítka mezi jménem interpreta a názvem písně.
2. **Sazba textu**
      * České a slovenské písně by měly mít texty psané jako celé věty včetně kompletní interpunkce, zalámané do veršů.
      * Anglické, francouzské a ostatní cizojazyčné písně mají velké písmeno na začátku každé řádky a interpunkce na jejich koncích (kromě té se speciálním významem), včetně tečky na konci věty, se ruší.
      * "Sólo", "předehra" / "intro", "mezihra" a podobné nepotřebují text a vlastní `\zs ... \ks` (výjimkou je sloka nahrazená sólem beze zpívání). Stačí v odpovídajícím místě napsat řadu akordů s prázdným textem; delší výdrž bez textu lze značit pomocí `~~~`.
3. **Zápis akordů**
      * Do jedné značky `<...>` vkládejte právě jeden akord (jinak program ohlásí neznámý formát akordové značky).
      * Ověřte správnost akordů a jejich umístění nad začátky slabik (ideálně podle originální nahrávky, ne jen podle prvního tabu, který najdete).
      * Pro všechny písně včetně cizojazyčných používejte důsledně české/německé značení akordů:
        * `H` = B (anglicky "B natural"), `B` = B♭ (anglicky "Bb") - nikdy nepoužívejte anglické `Bb`.
        * Ostatní bemoly pište německy: `Es` (Eb), `As` (Ab), `Des` (Db), `Ges` (Gb) - nikdy `Eb`, `Ab` apod.
        * `A#=B`, `A##=H`, `B#=H` - enharmonické zápisy blízké tónu H převádějte na `H`/`B`.
      * Mollové akordy zapisujte vždy s příponou `mi`, nikdy anglickým `m`: `Ami`, `Dmi7`, `Emi`, `Gmi` apod.
        V rámci jedné písně nemíchejte `Am`/`Ami` styl - buď důsledně jedno, nebo druhé (preferovaně `Ami`).
      * Před dokončením zkontrolujte přes `grep -oE '<[A-Za-z#0-9/]+>' soubor.tex | sort -u`, že se ve stejné písni nevyskytují ekvivalentní zápisy stejného akordu v různých stylech (např. `Am` i `Ami`, nebo `B` i `Bb`).
      * Akord neopakujte, pokud je jeho platnost jasná z kontextu (tj. dokud nedojde ke změně akordu, další značku nepište) - značte jen místa, kde se akord skutečně mění.
4. **Cílem je, aby se píseň vešla na jednu stránku A4.** Pokud přetéká na druhou stránku, postupujte následovně:
      * Pokud přetéká jen o několik řádků, zkuste ji zkrátit nebo přeskládat tak, aby se vešla na jednu A4 celou.
      * Sekvenci akordů, které se v průběhu písně nebo v jejích částech opakuje v přesně stejném sledu, stačí napsat jen jednou (pomocí prázdného `\zr\kr` pro opakování stejného refrénu). Totéž platí i pro sloky: pokud další sloka jede na naprosto stejnou akordovou sekvenci jako sloka předchozí, akordy u ní znovu nevypisujte - napište jen holý text. Akordy uveďte znovu jen tam, kde se od dosud zavedeného sledu skutečně odchylují (a jen pro tu odchylující se část).
      * Řádky od druhé sloky dále (typicky po dvou) spojujte do jedné řádky - stejný postup lze použít preventivně i na celou píseň, pokud je to potřeba k vejití na jednu stránku, ne až jako záchranu při přetečení.
      * Zkrátit opakovaný text pomocí repetic `/: ... :/` nebo tří teček, refrény vynechat.
      * Vynechat od druhé sloky dále výplně jako u Zítra ráno v pět nebo u Milionáře od Nohavici.
      * Když se vtěsnat na jednu stránku nepovede, využijte dobře prostor obou stránek. Je možno i ponechat na výběr dvě verze (viz Veličenstvo Kat).

## Přehled značek

* `\zp{jméno písně}{autor písně nebo interpret}`: začátek písně
* `\kp`: konec písně
* `\zr`: začátek refrénu
* `\kr`: konec refrénu
* `\zs`: začátek sloky
* `\ks`: konec sloky
* `<Dmi>Text`: akord nad následujícím textem
* `~~~`: výplň pro delší výdrž akordu bez textu

## Jak zařadit/vyřadit píseň ve zpěvníku

* V `Snakefile.karel_zpevnik` jsou aktivní písně v `songs = [...]` jako obyčejné řetězce (transpozice 0) nebo dvojice `("cesta", N)` (transpozice o N půltónů).
* Neaktivní/nepoužité písně se drží zakomentované pod aktivním seznamem (`# ---- unused songs ... ----`) ve formě `#   ("songs/.../Soubor.tex", 0),`, seřazené abecedně podle cesty - tento seznam by měl být vyčerpávající, tj. pokrývat úplně všechny `.tex` soubory v `songs/`, které nejsou aktivní.
* Pokud chcete píseň z konkrétního zpěvníku jen dočasně vyřadit (ne smazat), přesuňte její řádek z aktivního seznamu do zakomentovaného, nemažte soubor.
* Skutečné smazání písně (soubor už nikde nemá být, ani v komentářích) = smazat `.tex` soubor a zároveň smazat jeho řádek úplně (nepřidávat do zakomentovaného seznamu).
