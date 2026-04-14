# SQL-Project-Data-Analysis

### A. Zadání projektu

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast. Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období. Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.
___
### B. Úvod do projektu

Cílem tohoto projektu je odpovědět na klíčové výzkumné otázky týkající se životní úrovně občanů v České republice v období let **2006–2018**. Analýza se zaměřuje na porovnání dostupnosti základních potravin na základě průměrných příjmů a sleduje vliv makroekonomických ukazatelů (HDP) na ceny a mzdy.   
___
### C. Datové sady k použití

**Primární tabulky:**

**1. czechia_payroll** – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.

**2. czechia_payroll_calculation** – Číselník kalkulací v tabulce mezd.

**3. czechia_payroll_industry_branch** – Číselník odvětví v tabulce mezd.

**4. czechia_payroll_unit** – Číselník jednotek hodnot v tabulce mezd.

**5. czechia_payroll_value_type** – Číselník typů hodnot v tabulce mezd.

**6. czechia_price** – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.

**7. czechia_price_category** – Číselník kategorií potravin, které se vyskytují v našem přehledu.

  
**Číselníky sdílených informací o ČR:**

**1. czechia_region** – Číselník krajů České republiky dle normy CZ-NUTS

**2. czechia_district** – Číselník okresů České republiky dle normy LAU.

  
**Dodatečné tabulky:**

**1. countries** - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.

**2. economies** - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.
  
___
### D. Výzkumné otázky

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Odpověď na tuto otázku ziskáme pomoci CTE "**industry_year_average**", ze kterého můžeme zjistit, že mzdy v průběhu 12 let, konkrétně v období od roku **2006 do roku 2018**, vzrostly, růst však nebyl lineární. Například v sektoru "**Administrativní a podpůrné činnosti**" můžeme v roce **2013** vidět pokles mzdy o **0.36 %**. Toto byl však jediný pokles, celkově hodnoty v tomto odvětví rostly. Nejmenší nárůst obecně, respektive největší pokles, byl zaznamenán v sektoru "**Peněžnictví a pojišťovnictví**", o **8.91 %** v roce **2013**. Z celkového počtu **19** sektorů došlo v tomto roce k poklesu mzdy v **11** sektorech, což mohla být kombinace mnoha faktorů, hlavním z nich byla nejspíše doznívající krize, která probíhala v letech 2008 - 2009. Jinak ale v cca **90 %** všech měření došlo k nárůstu. Největší navýšení mzdy proběhlo v odvětví "**Těžba a dobývání**", o **13.81 %** mezi lety 2007 a 2008, nicméně další rok došlo naopak ke snížení o **3.74 %**. Ve stejném období (před krizí) došlo k růstu i v mnoha jiných sektorech.

V rámci CTE "**industry_yearly_averages**" můžeme vidět průměrný meziroční nárůst mezd ve všech pracovních sektorech v procentech (sloupec avg_yearly_growth_pct). Nejvyšší průměr je zaznamenán v oblasti "**Zdravotní a sociální péče**", a to **4.91 %**, nárůst vyšší než 4 procenta přišel hned v 8 sektorech z celkových 12. Nejmenší procentuální meziroční nárůst vidíme v oblasti "**Peněžnictví a pojišťovnictví**", a to pouhých **2.7 %**.

Co se celkového rozdílu ve mzdách mezi roky 2006 a 2018 týká, na ten se můžeme podívat v CTE **"salary_extremes"**. Největší nárůst proběhl v sektoru "**Zdravotní a sociální péče**", o **76.94 %**. Velmi podobná situace nastala v sektorech "**Zemědělství, lesnictví a rybářství**" (**73 %**) a "**Zpracovatelský průmysl**" (**72.85 %**). Naopak nejmenší nárůst můžeme vidět v sektoru "**Peněžnictví a pojišťovnictví**", **36.33 %**, tento nárůst je o více jak polovinu menší než v sektoru s největším nárůstem ("**Zdravotní a sociální péče**").

Nejmenší platy jsou obecně v odvětví "**Ubytování, stravování a pohostinství**" (**2006 - 11,390 Kč; 2018 - 18,770 Kč**), i když navýšení mezd patří mezi ty výraznější, **5.** největší mezi 19 sektory celkově (**64.79 %**). Největší platy se objevují v sektorech "**Peněžnictví a pojišťovnictví**" (**2006 - 39,690 Kč; 2018 - 54,111 Kč**), tady byl ale zároveň nejmenší procentuální vzrůst během 12 analyzovaných let, a "**Informační a komunikační činnosti**", kde byl naopak nárůst na konci sledovaného období signifikantnější (téměř 60 %, mzda v roce **2018** činila **56,101 Kč**).


### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

V CTE "**milk_bread_2006_2018**" můžeme vidět, že v prvním sledovaném roce, **2006**, byla průměrná nezaokrouhlená hodnota mzdy **20,753.78 Kč**, cena 1 kg chleba "**Chléb konzumní kmínový**" činila **16.12 Kč**, kupní síla (sloupec purchasing_power) byla tedy **1,287.46 kg**. Cena mléka "**Mléko polotučné pasterované**" za 1 l byla **14.44 Kč**, takže kupní síla byla o něco vyšší - **1,437.24 l**. V roce **2018** průměrný plat vzrostl na **32,535.86 Kč**, cena chleba vzrostla o cca **8 Kč**, ale o něco se zvýšila i kupní síla vlivem výraznějšího zvýšení mzdy (purchasing_power: **1,342.24** jednotek). V případě mléka je pak situace ještě lepší, protože kupní síla vzrostla o více než **204 litrů** na finálních **1,641.57 litrů**, což je nejvyšší hodnota z celého sledovaného období.

### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Nejnižší meziroční procentuální nárůst (CTE "**food_prices_average**"), který je dokonce ve dvou kategoriích záporný, což znamená celkové zlevnění těchto konkrétních potravin, se týká kategorie "**Cukr krystalový**" (**-1.92 %**) a "**Rajská jablka červená kulatá**" (**-0.74 %**). Nízký meziroční nárůst pak sledujeme u kategorií "**Banány žluté**" (**0.81 %**), "**Vepřová pečeně s kostí**" (**0,99 %**) a "**Přírodní minerální voda uhličitá**" (**1.03 %**). K největšímu meziročnímu procentuálnímu nárůstu došlo naopak u paprik (**7.29 %**). Měření se týkalo celkem **27** kategorií potravin. K poklesu ceny došlo v **10** kategoriích, tedy ve větší části zkoumaných kategorií došlo naopak ke zvýšení ceny. Přihlédnutí k jednotlivým rokům máme dodatečně zobrazeno ještě v poupravené verzi CTE. K velmi výraznému zdražení došlo například u **mrkve**, v tomto posledním zmiňovaném roce (**49.37 %**). Avšak největší zaznamenané zdražení proběhlo mezi lety **2006 a 2007** v kategorii "**Papriky**". Největší snížení ceny ve zkoumaných kategoriích naopak můžeme vidět v kategorii "**Rajská jablka červená kulatá**", v roce **2007** (**94.82 %**).

### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Takový rok neexistuje, všude vychází hodnoty pod **10 %**. Co je ale potřeba zmínit, že v tabulce "**Czechia_payroll**", ve sloupci "**value_type_code**" s hodnotou 316 (Průměrný počet zaměstnaných osob), se většina hodnot rovná NULL, takže nemáme tyto údaje a to může výsledky značně zkreslovat, nemůžeme totiž provést vážený průměr. Jako CTE slouží "**annual_averages**", kde největší meziroční mzdový nárůst můžeme vidět v roce **2008**, naopak největší meziroční nárůst cen potravin je viditelný v roce **2017**.

Nejvíce signifikantního rozdílu v tomto srovnání bylo dosáhnuto v roce **2009**. V roce **2007** a **2010** byly tyto rozdíly naopak minimální.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Z analýzy (CTE "**gdp_trend**") vyplývá, že přímá lineární závislost mezi HDP, mzdami a cenami potravin není jednoznačně patrná, nicméně lze vysledovat určité reakce s časovým zpožděním. Jako příklad můžeme uvést rok **2009**, kdy při výrazném propadu ekonomiky (**-4.66 %**) reagovaly ceny potravin okamžitým poklesem o **6.75 %**, zatímco růst mezd se pouze zpomalil. Naopak ekonomický pokles v roce **2012** se na mzdách projevil až s ročním zpožděním v roce **2013**, kdy došlo k jejich reálnému poklesu o **1.56 %**.


Lze tedy shrnout, že výrazné změny v HDP se na cenách a mzdách projevují, ale vstupují do nich další faktory a často k tomu vlivu dochází až s určitým zpožděním.
___  
### E. Výstupy z projektu

Pomozte kolegům s daným úkolem. Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech). Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky. Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! Záleží na tom, co říkají data. Na svém GitHub účtu vytvořte veřejný repozitář, kam uložíte všechny informace k projektu – hlavně SQL skript generující výslednou tabulku, popis mezivýsledků (průvodní listinu) ve formátu markdown (.md) a informace o výstupních datech (například kde chybí hodnoty apod.). Neupravujte data v primárních tabulkách! Pokud bude potřeba transformovat hodnoty, dělejte tak až v tabulkách nebo pohledech, které si nově vytváříte.

___  
### F. Nahrané dokumenty

**1. README. md**
Dokument s potřebnými informacemi k projektu

**2. SQL script**
Samotný sql script je psaný v programu DBeaver, jazykem PostgreSQL. Script obsahuje primární a sekundární tabulku, ze kterých dále čerpá potřebná data pro další views (pohledy), tato views umožňují zobrazovat data nutná k zodpovězení zadaných výzkumných otázek.
Skripty jsou pro maximální přehlednost rozděleny do samostatných souborů:

**`01_tables_creation.sql`: Tvorba a plnění základních tabulek.**

**Primární a sekundární tabulka:**

- **t_denisa_bartonova_project_SQL_primary_final**
(sjednocená data cen potravin a průměrných mezd v ČR na společné porovnatelné období 2006–2018)

- **t_denisa_bartonova_project_SQL_secondary_final**
(dodatečná data o evropských státech – HDP, GINI a populace pro roky 2006–2018)

**`02_question_1.sql` až `06_question_5.sql`: Dotazy využívající **CTE** a okenní funkce (`LAG`) pro výpočet trendů.**

**3. Result Description. md**
Tento dokument obsahuje odpovědi na výzkumné otázky.
___
### G. Upozornění na nedokonalosti/neúplnosti v datech

Některé záznamy mohou mít například hodnotu NULL (chybějící údaj), která nasledně může zkreslit výsledek, jelikož nelze spočítat vážený průměr. Dalším příklad zkreslení mohou být duplicitní hodnoty nebo jiné počty měření.
