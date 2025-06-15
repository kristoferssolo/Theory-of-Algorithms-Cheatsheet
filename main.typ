#import "@preview/finite:0.5.0": automaton
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/gentle-clues:1.2.0": *
#import "@preview/tablex:0.0.9": tablex
#import "layout.typ": indent-par, project

#show: project.with(title: [Theory of Algorithms Cheatsheet], authors: (
  "Kristofers Solo",
  "jorenchik",
))

#let teo(title: "Teorēma", ..args) = memo(title: title, ..args)
#let uzd(title: "Uzdevums", ..args) = question(title: title, ..args)

#let TM = $"TM"$
#let qrej = $q_"rej"$
#let qacc = $q_"acc"$
#let qnew = $q_"new"$
#let halt = $"HALTING"$
#let halt2 = $"HALTING"_2$
#let NP = $"NP"$
#let hline = line(length: 50%, stroke: 0.5pt)

= Tjūringa Mašīnas
== Variācijas
Var būt 3 veida uzdevumi: stāvokļu, tekstuāls, vairāklenšu.

#info(title: "Čērča-Tjūringa tēze")[
  Viss, ko var intuitīvi saukt par "algoritmu" vai "efektīvu procedūru", var
  tikt izpildīts ar Tjūringa mašīnu.
  Tā nav pierādāma teorēma, bet gan skaitļošanas modeļa definīcija, kurai līdz
  šim nav atrasts pretpiemērs.
]

=== Viena lente <one_tape>
$(q, a) -> (q', a', d)$ -- stāvoklī $q$ redzot $a$, ieraksta $a'$
un iet virzienā $d space (<- "vai" ->)$.

=== Divas (vai vairākas fiksētas) lentes
$(q, a_1, a_2) -> (q', b_1, b_2, d_1, d_2)$ -- $a_1$, $b_1$, $d_1$ pirmai
lentei un $a_2$, $b_2$, $d_2$ otrai lentei.
Svarīga atšķirība ir ka vairāklenšu #TM papildus $<-$ un $->$ virzieniem ir
$arrow.b$ (stāvēšana uz vietas). #footnote[Derīgs ar uzdevumiem, kur palīdz
  kopēšana/salīdzināšana.]

=== Stāvēšana uz vietas
Nosimulēt stāvēšanu uz vietas jeb $d=0$ var šādi:
- $(q, a) -> (qnew, a', ->)$
- $(qnew, a slash b slash c slash * ) -> (qnew, a slash b slash c slash *, <-)$

=== Modelis, ko pamatā izmanto šajā kursā!

Šajā kursā fokusējas uz TM, kas ir:
+ Vienas lentes (skat. @one_tape);
+ Bezgalīga vienā virzienā -- pa labi;
+ Pirmais simbols ir tukšais simbols (`_`);
+ Pēc pirmā simbola ir ievade;
+ Pēc ievades ir bezgalīgs tukšu simbolu skaits;
+ Sāk uz pirmā ievades simbola (viens pēc pirmā tukšuma).

== Risinājuma shēma
+ Izdomāt, kā aizstājot simbolus ar $*$ var pārbaudīt virknes derību.
+ Atcerēties par secību -- aiz $a$ var sekot tikai $b slash c$, aiz $b$ var sekot tikai $c$, utt.
+ Doties katrā no virzieniem var doties arī līdz galam jeb tukšumam $\_$.
+ Vairāklenšu #TM pārraksta pirmo daļu līdz $\#$ uz otras lentes un salīdzina.

Tas ir bieži sastopamais formāts, bet var gadīties arī cits.

// Shit, the original wrong here too. It should be "n>=0"

== Piemērs $(a^n b^n c^n", kur" n >= 0)$

Vai ieejas virknē $a^n b^n c^n$, kur $n>=0$

#context [
  $(q_1, a) -> (q_2, *, ->)$ \
  $(q_1, b slash c) -> qrej$ \
  $(q_1, *) -> (q_1, *, ->)$ \
  $(q_1, \_) -> qacc$ \

  $hline$

  $(q_2, a) -> (q_2, a, ->)$ \
  $(q_2, b) -> (q_3, *, ->)$ \
  $(q_2, c) -> qrej$ \
  $(q_2, *) -> (q_2, *, ->)$ \
  $(q_2, \_) -> qrej$ \

  $hline$

  $(q_3, a) -> qrej$ \
  $(q_3, b) -> (q_3, b, ->)$ \
  $(q_3, c) -> (q_4, *, <-)$ \
  $(q_3, *) -> (q_3, *, ->)$ \
  $(q_3, \_) -> qrej$ \

  $hline$

  $(q_4, a slash b slash c slash *) -> (q_4, a slash b slash c slash *, <-)$ \
  $(q_4, \_) -> (q_1, \_, ->)$ \
]

== Piemērs (vai virkne atkārt. pēc `#`)
Vai ieejas virkne $x \# x$, kur $x in {0,1}^*$

#context [
  $(q_1, 0, \_) -> (q_1, 0, 0, ->, ->)$ \
  $(q_1, 1, \_) -> (q_1, 1, 1, ->, ->)$ \
  $(q_1, \#, \_) -> (q_2, \#, \_, arrow.b, <-)$ \

  $hline$

  $(q_2, \#, 1) -> (q_2, \#, 1, arrow.b, <-)$ \
  $(q_2, \#, 0) -> (q_2, \#, 0, arrow.b, <-)$ \
  $(q_2, \#, \_) -> (q_3, \#, \_, ->, ->)$ \

  $hline$

  $(q_3, 0, 0) -> (q_3, 0, 0, ->, ->)$ \
  $(q_3, 1, 1) -> (q_3, 1, 1 ->, ->)$ \
  $(q_3, 0, 1) -> qrej$ \
  $(q_3, 1, 0) -> qrej$ \
  $(q_3, 0 slash 1, \_) -> qrej$ \
  $(q_3, \_, 0 slash 1) -> qrej$ \
  $(q_3, \_, \_) -> qacc$ \

]

= Sanumurējamība
== Definīcija
- Bezgalīgas kopas $A$, $B$ ir vienāda izmēra, ja ir bijekcija ($1:1$ attiecība)
  $F: A->B$.
- $A$ ir sanumurējama ar atkārtojumiem, ja ir attēlojums $F:N->A$, kas par katru
  $a in A$ attēlo vismaz vienu $x in NN$.
#teo[$A$ ir sanumurējama ar atkārtojumiem tad un tikai tad, ja $A$ ir sanumurējama.]

== Sanumerātības pierādījums
- Kopa ir sanumurējama, ja tajā eksistē bijekcija starp kopas elementiem un
  naturāliem skaitļiem. Citos vārdos sakot, katram kopas elementam var piešķirt
  unikālu naturālu skaitli.
- Ja kopa ir galīga, tā ir triviāli sanumurējama, jo katram elementam var
  piešķirt unikālu naturālu skaitli.
- Ja kopa ir bezgalīga (ar ko bieži vien darbojamies), jāņem vērā divi varianti:
  - Ja var izveidot bijekciju starp kopu un naturāliem skaitļiem, tad
    jāpierāda, ka bijekcija pastāv -- Var skaidri definēt funkciju, kas katram
    kopas elementam piešķir unikālu naturālu skaitli un parādīt, ka tā apvieno
    visus elementus bez dublēšanās.
  - Ja nevar atrast bijekciju starp kopu un naturāliem skaitļiem, tad jāpierāda,
    ka bijekcija nepastāv.
    Parasti tas tiek darīts, izmantojot pierādīšanas tehnikas, piemēram,
    diagonālināciju vai pretrunu (sk. @diagonalization, @contradiction).
- Ja izdodas pierādīt, ka start kopu un naturāliem skaitļiem nav bijekcijas, tad
  kopa ir nesaskaitāma.

=== Algoritmiska sanumurētība (par sanumerātību)

- Kopa $A$ ir sanumurējama, ja $A={x_1, x_2, ...}$
- Kopa $A$ ir algoritmiski sanumurējama, ja ir Tjūringa mašīna, kas izdod virkni
  $x_1, x_2, ...$, kurai $A={x_1, x_2, ...}$
#let DL = $"DL"$
#let IL = $"IL"$
Divu lenšu #TM, kur viena ir klasiska darba lente (#DL) un otra ir izvada
lente (#IL) (tikai rakstīšanai).

==== Piemērs $(a^k b^k mid(|) k>=0)$ alg. sanum.
Pamatot, ka kopa ${a^k b^k mid(|) k>=0}$ ir algoritmiski sanumurējama.

+ Uzraksta uz izejas lentes tukšu vārdu.
+ Uzraksta vienu $a$ uz darba lentes.
+ Atkārto:
  + Uz ieejas lentes uzrakstām tikpat $a$, cik bija uz #DL;
  + Uz izejas lentes uzrakstām tikpat $b$, cik $a$ bija uz #DL;
  + Uz izejas lentes uzrakstām $\_$;
  + Uz darba lentes pierakstām klāt vienu $a$.
+ Izejas lente $=epsilon, a b, a a b b, a a a b b b,...$

==== Piemērs (atkārt. pēc \# ir sanum\.?)
Pamatot, ka kopa ${x \# x mid(|) x in {a, b}^* }$ ir algoritmiski sanumurējama.

+ Uz darba lentes iet cauri visiem $x$ (šeit būtu jāparāda/jāpaskaidro, kā to
  izdara).
+ Katram $x$ uz izejas lentes uzraksta $x \# x$.
+ Uz izejas lentes uzraksta $\#\_$.
+ Uz darba lentes uzraksta $a$.
+ Atkārto:
  + Pārraksta darba lentes saturu $x$ uz izejas lenti;
  + Uzraksta $\#$ uz #IL, vēlreiz pārraksta $x$ uz #IL, uzrakstām $\_$ uz #IL.
  + Uz #DL nomaina $x$ pret nākošo vārdu.

=== Diagonālinācija (pret sanumurējāmību) <diagonalization>
Ir saraksts (pieņem, ka ir iegūts saraksts) vai uzskaitījums ar visiem kopas
elementiem un tiek konstruēts jauns elements, kas neatrodas šajā sarakstā. Tas
demonstrē, ka kopa ir nesanumurējama, jo vienmēr var izveidot jaunu elementu,
kas nav iekļauts uzskaitē (piemēram, reālos skaitļos).

=== Pretruna (pret sanumurējāmību) <contradiction>
Pieņem, ka kopa ir saskaitāma un tad rodas pretruna. To var izdarīt, parādot,
ka kaut kādas kopas īpašības vai kardinalitāte ir pretrunā ar sanumurējamības
pieņēmumu.

== Piemērs $(ZZ "sanumurētība")$
Vai visu veselo skaitļu kopa $ZZ={..., -1, 0, 1, ...}$ ir sanumurējama?
Vai ir $F:{F(1), F(2), ..., F(n), ...}=ZZ$?

$F(n) = n/2 ", ja pāra un" -(n-1)/2 "ja nepāra"$.

Sākumā tiek iegūta nulle.

Iterējot par $n$:
+ Funkcijas vērtības skaitļa modulis palielinās par 1, tiek iegūts pozitīvais
  skaitlis;
+ Tiek iegūts negatīvais skaitlis;

$F(1)=0, F(2)=1, F(3)=-1, F(4)=2, F(5)=-2...$

Injekcija: ja $F(n_1) = F(n_2)$ no formulas seko, ka $n_1 = n_2$.

Surjekcija: katram $z in ZZ$ eksistē $n in NN$, ka $F(n) = z$.

= Redukcijas

== Definīcija

- $A <= B$, ja ir ar Tjūringa mašīnu izrēķināms pārveidojums
  - $R$: (ieejas dati $A$) $->$ (ieejas dati $B$),
  - $B(R(x)) = A(x)$.

Ja $A <= B$ -- ja var atrisināt $B$, tad var atrisināt $A$. $A$ ir reducējuma
par $B$.

Ja $A <= B and A >= B$, tad $A$ un $B$ ir ekvivalentas.

== Piemērs (var vai nevar reducēt)

// Jorens: Originally šeit bija sajaukta secība, bet uzdevums ir kinda valīds
// abās pusēs, kopumā risinājums ir nedaudz problemātisks.

#uzd[
  Dota problēma $halt2(M, x, y) = 1$, kur Tjūringa mašīna $M$ apstājas vismaz uz
  vienas no ievadēm $x$ vai $y$. Pierādīt, ka to var vai nevar reducēt uz
  $halt$, tas ir parādīt $(halt 2 <= halt)$.
]

Lai pierādītu, ka problēmu $halt2(M, x, y)$ var noreducēt uz #halt, mums
jāparāda, ka varam konstruēt Tjūringa mašīnu, kas atrisina #halt2, izmantojot
#halt kā atrisinātu problēmu (jeb kā apakšprogrammu).

Pieņemsim, ka mums ir Tjūringa mašīna $H$, kas atrisina #halt problēmu.
Konstruēsim jaunu Tjūringa mašīnu $H_2$, kas atrisina #halt2 problēmu:

Tjūringa mašīna $H_2$ darbojas sekojoši:
- Doti ievades dati $M$, $x$ un $y$.
- Palaiž $H$ ar ievaddatiem $(M, x)$.
- Ja $H$ akceptē $(M, x)$, apstājas un akceptē.
- Ja $H$ noraida $(M, x)$, palaiž $H$ ar ievaddatiem $(M, y)$.
- Ja $H$ akceptē $(M, y)$, apstājas un akceptē.
- Ja $H$ noraida $(M, y)$, apstājas un noraida.

// Jorens:Nav "vai nu", bet "vai". Citādi paliek abi pozitīvi, kas nav
// apskatīti.
Konstruējot $H_2$ šādā veidā, mēs simulējam $H$ darbību uz abām ievadēm $x$ un
$y$:
- Ja $H$ akceptē $(M, x)$ vai $(M, y)$, $H_2$ akceptēs un apstāsies.
- Ja $H$ noraida gan $(M, x)$, gan $(M, y)$, $H_2$ noraidīs un apstāsies.

// Jorens: Tas jau ir nedaudz liekvārdīgi, izņēmu dažas lietas.

_Tālākais teksts nav obligāts risinājumā._

Redukcijas analīze:
- Ja $halt2(M, x, y) = 1$, tas nozīmē, ka Tjūringa mašīna $M$ apstājas vismaz
  uz vienas no ievadēm $x$ vai $y$. Šajā gadījumā $H_2$ arī apstāsies un
  akceptēs, jo tā veiksmīgi simulē $H$ uz abām ievadēm un akceptē, ja $H$
  akceptē kādu no tām. Tādējādi #halt2 tiek reducēta uz #halt.
- Ja $halt2(M, x, y) = 0$, tas nozīmē, ka Tjūringa mašīna $M$ neapstājas ne uz
  $x$, ne uz $y$. Šajā gadījumā #halt2 arī neapstāsies un noraidīs, jo tā
  simulē $H$ uz abām ievadēm un noraida, ja $H$ norada abas.

Tādējādi #halt2 tiek reducēta uz #halt.

= Neatrisināmas (non-decidable) problēmas

#let acc = $"ACCEPTING"$
#let eqans = $"EQUAL-ANSWERS"$
#let one = $"ONE"$
#let infinite = $"INFINITE"$
#let equiv = $"EQUIV"$
#let hamcycle = $"HAMCYCLE"$
#let linineq = $"LIN-INEQ"$
#let M1 = $M_1$
#let M2 = $M_2$
#let SAT = $"SAT"$

== Definīcija

Neatrisināma problēma ir problēma ir problēma, kurai neeksistē TM, kas
atrisinātu šo problēmu.

== Funkcionālās īpašības

- $F(M)$, $M$ – Tjūringa mašīnas programma;
- $F$ var definēt caur $M$ atbildēm uz dažādām ieejas virknēm $x$.

Piemēram:
- $one(M) = 1$, ja $exists x: M(x) = 1$
- $infinite(M) = 1$, ja $exists^oo x: M(x) = 1$

Citiem vārdiem, ja $forall x: M_1(x) = M_2(x)$, tad $F(M_1) = F(M_2)$.

== Nefunkcionālās īpašības

- $A(M) = 1$, ja $exists x: M$ apstājas pēc $<= 17$ soļiem.
- $B(M) = 1$, ja Tjūringa mašīnā $M$ ir stāvoklis $q$, kurš netiek sasniegts
  nevienai ieejas virknei $x$.

Papildus Tjūringa mašīnas funkcionālam aprakstam, mums ir papildus informācija
par mašīnu, par tās struktūru utt.

== Raisa teorēma

#teo(
  title: "Raisa teorēma",
)[Ja $F$ nav triviāla (ir $M:F(M)=0$ un $M':F(M')=1$), tad $F$ -- neatrisināma.]

Teorēma "pasaka" mums priekšā, ka jebkuru netriviālu *funkcionālu* īpašību
nevar atrisināt.

== Uzskaitījums
- $halt(M\# x)=1$, ja $M$ apstājas, ja ieejas virkne $=x$.
- $acc(M\# x)=1$, ja $M$ uz ieejas virknes izdod atbildi $1$.
- $eqans(M\# x \# y)=1$, ja $M$ uz ieejas virknēm $x$ un $y$ izdod vienādas atbildes.
- $one(M)=1$, ja eksistē ieejas virkne $x$, uz kuras $M$ izdod atbildi $1$.
- $infinite(M)=1$, ja eksistē bezgalīgi daudzas ieejas virknes $x$, uz kurām $M$ izdod atbildi $1$.
- $equiv(M 1, M 2)=1$, ja $M1(x)=M2(x)$
- $"PCP"(S_1, S_2)=1$ (Post-correspondance problem), ja divām galībām kopām $A = [a_1,
    a_2, ..., a_n]$ un $B = [b_1, b_2, dots, b_n]$ var izvēlēties indeksu secības
  $a_("i1") a_("i2") ... a_("ik")$ = $b_("i1") b_("i2") ... b_("ik")$ (tā lai
  konkatenācijas būtu vienādas); domino kauliņi ar augšu un apakšu, ko saliekot
  kopā, globālai augšai un apakšai jāsakrīt.
- $"MORTAL-MATRIX"(S)=1$, vai no matricām $M_1, M_2, ..., M_n$ var izveidot
  secību (ar atkārtojumiem), ka matricu reizinājums būtu 0.
// LININEQ, HAMCYCLE are DECIDABLE!
// - $"hilbert's-10th"(S)=1$, ...?

#info[Ja var atrisināt #acc, tad var atrisināt arī #halt.]
#info[Ja var atrisināt #eqans / #one / #infinite / #equiv, tad var atrisināt arī #acc.]

== Pierādījums no redukcijas (Soļi)
+ Skaidri definē problēmu, kuru vēlas pierādīt kā #NP -- norādot, kas ir derīga
  ievade un kādus rezultātus programmai paredzēts izvadīt.
+ Pieņem, ka eksistē algoritms vai #TM, kas spēj atrisināt problēmu visiem
  iespējamiem ievaddatiem.
  Šī pieņēmuma mērķis ir rādīt pretrunu.
+ Definē citu problēmu, kas var tikt noreducēta līdz sākotnējai problēmai.
  Tas nozīmē, ka, ja var atrisināt sākotnējo problēmu, var atrisināt arī
  saistīto problēmu.
+ Izveido transformācijas vai redukcijas algoritmu, kas ņem saistītās problēmas
  instanci un pārveido to par sākotnējās problēmas instanci. Šai redukcijai
  vajadzētu saglabāt atbildi uz saistīto problēmu.
+ Pierāda, ka, ja sākotnējai problēmai ir risinājums, tad arī saistītajai
  problēmai ir risinājums.
  Šajā solī parasti ir jāpierāda, ka redukcijas algoritms ir pareizs un pareizi
  pārveido instances.
+ Pierāda, ka, ja saistītajai problēmai ir risinājums, tad arī sākotnējai
  problēmai ir risinājums.
  Šis solis parasti ietver pierādījumu, ka redukcijas algoritmu var atgriezt
  atpakaļ, lai iegūtu risinājumu sākotnējai problēmai.
+ Apvieno iepriekšējos soļus, lai parādītu, ka, ja sākotnējai problēmai ir
  risinājums, tad arī saistītajai problēmai ir risinājums.
  Šeit jārodas pretrunai.
#context [
  #set par(justify: false)
  == Piemēri (prob. ir neatr)
  === $halt <= acc$
  - #underline("Teorēma"): Ja var atrisināt #acc, tad var atrisināt arī #halt
  - #underline("Pierādījums"): Attēlojums $R:M->M'$ ar īpašību $halt(M\#x) = acc(M'\#x)$.
  - Tad $halt(M\#x)$ var atrisināt sekojoši:
  - izrēķina $M'=R(M)$, izrēķinām, vai $acc(M'\#x)$.
  - $M'$ -- programma, ko iegūst no $M$, visur aizstājot #qrej ar #qacc.
  - Ja $M$ akceptē/noraida, tad $M'$ akceptē (izdos $1$).
  - Ja $M$ neapstājas, $M'$ arī neapstājas.

  === $acc <= eqans$
  - #underline("Zinām"): #acc nav atrisināma
  - #underline("Pierādām"): Ja var atrisināt #eqans, tad var atrisināt arī #acc.
  - #underline("Secinām"): #eqans nevar atrisināt.
  - Dots: $M, x$
  - Jādefinē: $M', y: eqans(M' \# x \# y) = acc(M\# x)$.
  - $y$ -- virkne no viena simbola $s$, kas nav vārdā $x$.
  - Ja $M'$ redz simbolu $s$, $M'$ akceptē, citādi darbina $M$.
  - $M'(quote.angle.l.double s quote.angle.r.double)=1$, $M'(x)=M(x)$, ja $x$ nesatur $s$.
  - $eqans(M'\# x \# quote.angle.l.double s quote.angle.r.double)=acc(M\#x)$.

  === $acc <= one$
  - #underline("Pierādām"): Ja var atrisināt #one, tad var atrisināt arī #acc.
  - Dots: $M, x$
  - Jādefinē: $M': one(M') = acc(M\# x)$.
  - $M'$: nodzēš no lentes ieejas virkni $y$, uzraksta $x$, palaiž $M$ programmu.
  - Jebkurai $y, M'(y)=M(x)$.

  === $acc <= infinite$
  - #underline("Pierādām"): Ja var atrisināt #infinite, tad var atrisināt arī #acc.
  - Dots: $M, x$
  - Jādefinē: $M': infinite(M') = acc(M\# x)$.
  - Jebkurai $y, M'(y)=M(x)$.
  - Ja $M(x)=1$, tad $M'(y)=1$ jebkurai $y$.

  === $acc <= equiv$
  - #underline("Pierādām"): Ja var atrisināt #equiv, tad var atrisināt arī #acc.
  - Dots: $M, x$
  - Jādefinē: $M_1, M_2: equiv(M_1, M_2) = acc(M\# x)$.
  - Ja $M$ akceptē $x, M_1, M_2$ jābūt ekvivalentām.
  - Ja $M$ neakceptē $x, M_1, M_2$ nav jābūt ekvivalentām.
  - $M_1$: nodzēš ieejas virkni $y$, uzraksta $x$, darbina $M$.
  - $M_2$: uzreiz pāriet uz akceptējoši stāvokli.
  - Ja $acc(M\#x)=1$, tad $M_1(y)=1$ visiem $y$.
  Tā kā $M_2(y)=1$, tad $equiv(M_1, M_2)=1$.

  === #halt -- pierādījums no pretējā
  - Pieņemsism, ka ir #TM $M_H$, kas risina #halt.
  - Definē $M'$ šādā veidā:
    - Ieejas dati: $x$.
    - Atrod $x$ atbilstošo Tjūringa mašīnas programmu $M$.
    - Ja $M_H(M\#x)=1$, tad caur universālo #TM darbina $M$ uz $x$, izdod pretējo atbildi.
    - Ja $M_H(M\#x)=0$, tad izdod $1$.

  Jebkuram $x:M'(x) != M(x)$, kur $M$ -- #TM, kas atbilst $x$.

  === #acc -- pierādījums no pretējā
  - Pieņem, ka #acc ir atrisināma.
  - $M(x)$:
    - Atrod ieejas virknei $x$ atbilstošo $M_i$.
    - Ja $acc(M_i \# x)=1$, $M$ izdod $0$.
    - Ja $acc(M_i \# x)=0$, $M$ izdod $1$.

  Jebkurai $M_i$, būs $x$, kuram $M(x) != M_i(x)$.

  === $A(M)=1$, ja $M$ -- #TM programma un, darbinot $M$ uz tukšas ieejas virknes, tā apstājas un izdod $1$
  Pieņemsim, ka eksistē algoritms $D$ problēmai $A(M)$.
  $D$ ir algoritms, kas spēj noteikt, vai Tjūringa mašīna $M$, apstājas un
  atgriež $1$ ar tukšu ievades virkni.

  Tagad konstruēsim jaunu #TM, $N$:
  + Palaiž $M$ ar tukšu ievades virkni.
  + Ja $M$ apstājas un atgriež $1$, $N$ apstājas un atgriež $1$.
  + Ja $M$ apstājas, bet neatgriež $1$, $N$ ieiet bezgalīgā ciklā.
  + Ja $M$ neapstājas, $N$ apstājas un atgriež $0$.

  Dodot algoritmam $D$ ievadi $N$ notiks sekojošais:
  - Ja $D$ atgriež $1$, tas nozīmē, ka $M$ apstājas un atgriež $1$ ar tukšu
    ievades virkni (atbilstoši $A(M)$ definīcijai).
    Šajā gadījumā $N$ apstāsies un atgriezīs $1$, un $D$ būs devis pareizu
    atbildi.
  - Ja $D$ atgriež $0$, tas nozīmē, ka vai nu $M$ neapstājas, vai $M$ apstājas,
    bet neatgriež $1$ ar tukšu ievades virkni.
    Pirmajā gadījumā $N$ apstāsies un atgriezīs $0$, kas atbilst $D$ dotajai
    atbildei.
    Tomēr otrajā gadījumā $N$ ieies bezgalīgā ciklā, un $D$ būs devis nepareizu
    atbildi.

  Tā kā $D$ uz $N$ sniedz nepareizu atbildi vienā no gadījumiem, mēs varam
  secināt, ka problēma $A(M)$ ir #NP.
  Tāpēc neeksistē algoritms, kas spētu noteikt, vai dotā Tjūringa mašīna
  apstājas un atgriež $1$ ar tukšu ievades virkni visām iespējamām Tjūringa
  mašīnām.
]

#teo(
  title: "Kuka-Levina teorēma",
)[#SAT problēma (Boolean satisfiability problem) ir NP-pilna.]

#info[
  #SAT problēma: dots Būla algebras izteikums, vai ir iespējams piešķirt
  mainīgajiem vērtības (patiess/aplams) tā, lai viss izteikums būtu
  patiess?
]
Šī teorēma bija pirmā, kas pierādīja kādas problēmas NP-pilnību.
Pēc tās, lai pierādītu, ka cita problēma $L$ ir NP-pilna, pietiek parādīt,
ka $L in NP$ un ka $SAT <_p L$ (vai jebkura cita zināma NP-pilna problēma).


== Daļēja atrisināmība

// Jorens: Tas teksta blāķis, kas šeit bija var apjucināt cilvēkus, viss kas
// vajadzīgs ir sarakstāms īsāk.

- $A$ –- daļēji atrisināma, ja ir Tjūringa mašīna $T$:
  - Ja $A(x) = 1$, tad $T(x) = 1$.
  - Ja $A(x) = 0$, tad $T(x) = 0$ vai $T(x)$ neapstājas.

#teo[$A$ -- daļēji atrisināma tad un tikai tad, ja $A$ -- algoritmiski sanumurējama.]

Cits nosaukums daļējai atrisināmībai ir atpazīstamība (angl.
recognizability/recognizable).

=== Piemērs (daļēji neatrisināma)

Problēma $A$, kurai neviena no $A$, $overline(A)$ nav daļēji atrisināma?

- $equiv(M_1, M_2) = 1$, ja $forall x: M_1(x) = M_2(x)$.
- $overline(equiv)(M_1, M_2) = 1$, ja $exists x: M_1(x) != M_2(x)$.


= Nekustīgo punktu teorija

== Nekustīgā punkta teorēma

Lai $phi_x$ ir daļēji definēta funkcija, ko aprēķina Tjūringa mašīna ar
programmu $x$.  Lai $F: Sigma^* -> Sigma^*$ ir jebkurš visur definēts
aprēķināms pārveidojums uz programmām.

Tad: $"eksistē"(x): phi_{F(x)} = phi_x$

- $phi_x$: funkcija, ko aprēķina programma $x$.
- $F$: jebkura visur definēta aprēķināma funkcija virknēm (programmām).
- $Sigma^*$: visu galīgo virkņu kopa pār alfabētu $Sigma$.

== NPT pielietošanas piemērs

"Pierādīt, ka eksistē programma, kas pieņem tikai savu aprakstu."

Definējam skaitļojamu $F(x)$ ar ievadi -- aprakstu $x$, kas
pārveido to uz programmu, kas darbojas sekojoši:

+ Iegūst mašīnas ievadi $y$;
+ Programmai ir pieejams programmas apraksts $x$;
+ Iet cauri simboliem no $x$ un $y$ līdz nonāk līdz tukšumam:
  + Ja simboli sakrīt un simboli nav tukšumi, iet tālāk.
  + Ja abi simboli ir tukšumi, akceptē.
  + Ja simboli nesakrīt, apstājas un neakceptē.

$F(x)$ ir vienmēr izskaitļojama, jo ja mums ir pieejama $x$ programmas
apraksts, ir iespējams uzbūvēt programmu, kas salīdzina ar brīvi izvēlamu
ievadi $y$.

Pēc nekustīgā punkta teorēmas eksistē $x$, ka

$
  phi_(F(x)) = phi_x.
$

+ Tātad eksistē tāds $x$, ka $x$ ir funkcionāli ekvivalenta $F(x)$.
+ Tā kā funkcijas $F(x)$ rezultāts ir iepriekš aprakstītā programma, $x$ sakrīt
  ar uzdevumā prasīto uzvedību.

QED.

= Sarežģītības teorija

== Lielais $O$ un mazais $o$

Notācija, kas tiek izmantota, lai raksturotu *funkciju* sarežģītību
asimptotiski.

=== Lielais-$O$ (formālā definīcija)

$f(n) in O(g(n))$, ja:

$exists C > 0, exists n_0 > 0:$ $(forall n >= n_0: f(n) <= c dot g(n))$

Tas nozīmē, ka funkcija $f(n)$ asimptotiski nepārsniedz konstanti $c$ reizinātu
$g(n)$.

/*
=== Piemērs

$f(n) = 17n^2 + 23n + 4$
$g(n) = n^2$

Tad $f(n) in O(n^2)$, jo:

$17n^2 + 23n + 4 \leq 17n^2 + 23n^2 + 4n^2 = 44n^2$
tātad $C = 44$.
*/

=== Mazais-$o$ (formālā definīcija)

$f(n) in o(g(n))$, ja:

$
  lim_(i -> infinity) f(n) / g(n) = 0
$

Tas nozīmē, ka funkcija $f(n)$ kļūst nenozīmīga attiecībā pret $g(n)$, $n$
tiecoties uz bezgalību.

/*
=== Piemērs

$log(n) \in o(n)$
jo jebkuram $epsilon > 0$ pietiekami lieliem $n$:
$log(n) <= epsilon * n$.
*/

=== $f(n) in O(g(n))$ pamatojuma triks

Ja ir pierādījums, ka $f(n) in o(g(n))$, tad automātiski var secināt, ka $f(n)
in O(g(n))$. *Tikai pozitīvajā gadījumā!* Jo mazais $o$ ir stingrāka prasība
par lielo $O$.

=== Pamatojuma soļi

- Ja funkcija pielīdzināta lielajam $O$:
  + Salīdzina funkcijas augstāko pakāpi ar doto $O$ pakāpi.
  + Ja funkcijas pakāpe ir lielāka, tad vienādojums būs patiess, jo funkcija aug
    straujāk.
  + Korektam risinājumam jāpamato kāpēc definīcijas nevienādība ir patiesa
    visiem $n >= n_0$ un iespējams jāparāda piemēra $c$.
- Ja funkcija pielīdzināta mazajam $o$:
  + Jāievieto dotais robežā $lim_(x->oo)f(x)/g(x)$;
  + Rezultāts ir 0, patiess, citādi -- nepatiess.

=== Piemērs (lielais-$O$)

$ 2n^4 + 6n^2 + 17 =^? O(n^4) $

Izteiksme ir patiesa, tā kā kreisās puses izteiksmes augstākā pakāpe jeb kārta
ir $4$ un iekš $O$ tā arī ir $4$.

=== Piemērs (lielais-$O$)
$ 2n^4 + 6n^2 + 17 =^? O(n^3) $

Izteiksme ir aplama, jo kreisajā pusē augstākā pakāpe ir $4$, kamēr labajā ir
norādīta $3$, un $4$ pakāpes izteiksmi nevar izpildīt $O(n^3)$.

=== Piemērs (lielais-$O$)
$ n^3 + 17n + 4 in^? O(n^3) $

Jā, $n^3 + 17n + 4 <= n^3 + 17n^3 + 4n^3 = 22n^3$.

=== Piemērs (lielais-$O$)
$ n^4 + 17n + 4 in^? O(n^3) $

Nē $n^4 + 17n + 4 > n^4 = n dot n^3$

=== Piemērs (mazais-$o$) <small-o-example-3>
$ n log^4 n =^? o(n^1.5) $

Ir zināms, ka mazajā $O$ notācijai, ja $lim_(x->oo)f(x)/g(x)$, kur $f(x)$ ir
funkcija un $g(x)$ ir $o$, tad vienādība izpildās.
Ievietojot vērtības $ lim_(n->oo) (n log^4 n)/n^1.5=0 $
Tātad vienādojums ir
patiess.

=== Piemērs (mazais-$o$)
$ 2^n n^2 =^? o(n^3) $

Pēc tās pašas aprakstītās īpašības, kā @small-o-example-3, sanāktu
$ lim_(n->oo) (2^n n^2)/3^n $
un tā kā $3^n$ aug ātrāk kā $2^n$, šī robeža būs $0$ un sākotnējais
vienādojums būs patiess.


== Sarežģītības klases

#let time = $"TIME"$

=== Laiks (TIME)

$time(f(n))$ -- problēmas $L$, kurām eksistē Tjūringa mašīna $M$, kas pareizi
risina $L$ un izmanto $O(f(n))$ soļus.

==== #TM darbības laiks

+ Identificēt galvenās operācijas vai soļus, ko Tjūringa mašīna veic katrai
  ievadei.
  + Tas varētu ietvert simbolu lasīšanu no lentes, simbolu rakstīšanu lentē,
    lentes galviņas pārvietošanu, aprēķinu veikšanu vai lēmumu pieņemšanu,
    pamatojoties uz pašreizējo stāvokli un ievades simbolu.
+ Noteikt sliktākā gadījuma scenāriju.
  + Analizēt ievadi vai ievades secību, kas prasītu maksimālo soļu skaitu,
    lai Tjūringa mašīna pabeigtu savu aprēķinu.
  + Apsvērt ievades, kas maksimizē iterāciju skaitu vai liek mašīnai izpētīt
    visas iespējamās aprēķinu zaru versijas.
+ Izteikt darbības laiku atkarībā no ievades izmēra.
  + Definēt funkciju, kas attēlo Tjūringa mašīnas veikto soļu vai pāreju
    skaitu kā funkciju no ievad izmēra.
  + Piemēram, ja ievades izmērs ir $n$, darbības laika funkciju varētu apzīmēt
    kā $f(n)$.
+ Vienkāršot darbības laika funkciju un izsakot to, izmantojot lielā $O$
  notāciju.
  + Lielā $O$ notācija nodrošina augšējo robežu darbības laika funkcijas
    pieauguma ātrumam, palielinoties ievaddatu izmēram.
  + Noņemt konstantes faktorus un zemākas kārtas locekļus no darbības laika
    funkcijas, lai koncentrētos uz dominējošo locekli, kas atspoguļo pieauguma
    ātrumu.
+ Izteikt vienkāršoto darbības laika funkciju, izmantojot atbilstošo lielā $O$
  notāciju, piemēram, $O(n)$, $O(n log n)$, $O(n^2)$, $O(2^n)$ utt.

==== Programmas darbības laiks

Īstām programmām rindiņas var izpildīties atšķirīgā laikā -- tas ir atkarīgs
apakšprogrammu izsaukumi, procesora operācijām. Taču šajā tas tiek abstrahēts un
katra koda rindiņa tiek uzskatīta par vienu soli.

Lai atrastu koda izpildes laiku:
+ Novērtē katras rindiņas "globālo laiku" -- cik tā izpildās ņemot vērā visus
  ciklus, izmantojot summu funkcijas.
+ Novērtē kādos gadījumos tā izpildās, ja vispār izpildās.
+ Izvērtē to kāds gadījums (ievade) būtu vissliktākā un aprēķina tam funkciju
  no $n$ (skat. @time_analysis_expressions).
+ Novērtē šīs funkcijas klasi izmantojot lielā-O notāciju.

===== Piemērs ($abs(a) =^? abs(b)$)
Vai ieejas virknē ir vienāds skaits $a$ un $b$?

+ Virzās no kreisās puses uz labo, aizstājot vienu $a$ un vienu $b$ ar $x$;
+ Ja neatrod nedz $a$, nedz $b$, akceptē;
+ Ja neatrod vienu no $a$ vai $b$, noraida;
+ Ja atrod gan $a$, gan $b$, virzās atpakaļ uz pirmo simbolu un atkārto.

Kopējais soļu skaits:
- Ne vairāk kā $(n/2+1) 2n = n^2 + 2n$ soļi.
- Ja $n$ nav ļoti mazs, $n^2$ būs vairāk nekā $2n$ un soļu skaits $O(n^2)$.

=== Telpa/Vieta (SPACE)

==== SPACE Definīcija (Precīzs modelis)

- Ieejas lente - $x_1 ,..., x_n$, var tikai lasīt.
- Darba lente – sākumā tukša, var arī rakstīt.
- $S(x_1, ..., x_N)$ – šūnu skaits, kas tiek apmeklētas uz darba lentes.
- $S(N) = max S(x_1, ..., x_N)$.

$
  "SPACE"(f(N)) = \
  = {L mid(|) L "var atrisināt ar Tjūringa" \
    "mašīnu, kurai" S(N) <= C f(N)}. \
$

==== NSPACE Definīcija

$
  "NSPACE"(f(N)) = \
  = {L mid(|) L "ir determinēta" M, "visiem" x, L(x)=M(x), \
    "un" M "izmanto " <= c f(N) "šūnas uz darba lentes"}. \
$

#teo(title: "Savča teorēma", [$"NSPACE"(f(N)) subset.eq "SPACE" (f^2(N))$])

==== LOGSPACE Definīcija

$
  "LOGSPACE" = "SPACE" (log N).
$

$
  "LOGSPACE" subset.eq U_c "TIME"(c^(log N)) = \
  U_c "TIME" (N^c) = P
$

Labs mentālais modelis, lai pierādītu, ka algoritms pieder $"LOGSPACE"$ -- ja
var iztikt ar $O(1)$ mainīgo daudzumu, kur katrs mainīgais ir no $0$ līdz $N$
vai noteikts fiksētu vērtību skaits.

=== Laika-Telpas sakarības

#teo[
  Ja $f(n) >= log N$, tad
  $
    "TIME"(f(N)) subset.eq "SPACE"(f(N)) subset.eq \
    subset.eq union.big_c "TIME" (c^(f(N)))
  $
]

Laiks $O(f(N)) ->$ atmiņa $O(f(N))$.

=== Asimptotiskas augšanas hierarhija

Sekojošas funkcijas pieaugums pie $x -> oo$:

$log(x) << x << x dot log(x) << x^k << a^x << x! << x^x$

- $x$: mainīgais (parasti $n$).
- $k$: jebkurš vesels pozitīvs skaitlis ($k in NN$).
- $a$: reāla konstante lielāka par $1$ ($a > 1$).

Šo hierarhiju var izmantot intuīcijai par to vai funkcija pieder klasei
sarežģītības klasei, bet kā pamatojums tas nederētu.

_$x^epsilon$ ir izņemts laukā, lai nejauktu galvu_

_Source; Mathematics for Computer Science, 2018, Eric Lehman, Google Inc._

= Klase P

== Definīcija

Klase $P$ ir problēmu kopa, ko var atrisināt ar deterministisku Tjūringa mašīnu
polinomiālā laikā.

- $P=union.big_k "TIME"(n^k)$

Citiem vārdiem: problēma pieder $P$, ja eksistē deterministiska Tjūringa
mašīna, kas to atrisina O($n^k$) soļos, kādai konstantei $k$.

Klase $P$ tiek uzskatīta par praktiski atrisināmo problēmu klasi. Visi
saprātīgie deterministiskie skaitļošanas modeļi ir polinomiāli ekvivalenti
(vienu var simulēt ar otru polinomiālā laikā).

== Piemērs ($"PATH"$)

- Dots grafs $G$ un divas virsotnes $u$, $v$.
- Jautājums: vai eksistē ceļš no $u$ uz $v$?
- Rupjais-spēks: pārbaudīt visus ceļus -- eksponenciāls laiks.
- Efektīvs algoritms: meklēšana plašumā (breadth-first search); laika
  sarežģītība: $O(abs(V) + abs(E))$.

== Piemērs ($"RELPRIME"$)

- Doti skaitļi $x$, $y$ (binārā kodējumā).
- Jautājums: vai skaitļi ir savstarpēji pirmskaitļi?
- Efektīvs algoritms: Eiklīda algoritms (izmantojot $mod$); laika sarežģītība:
  $O(log n)$ (jo katrā iterācijā skaitļi būtiski samazinās).

= Klase NP

== NP problēmas

#NP (nederminēti-polinomiālas) problēmas
ir problēmas (2 ekvivalentas definīcijas):

+ $L in NP$, ja eksistē pārbaudes algoritms -- $O(n^c)$ laika Tjūringa mašīna $M$:
  + Ja $L(x) = 1$, tad eksistē y: $M(x, y) = 1$.
  + Ja $L(x) = 0$, tad visiem y: $M(x, y) = 0$.
  + _Informācija $y$ var saturēt brīvi definētu informāciju._
  + _Pārbaudes algoritmā tas ir risinājums, ko tas pārbauda._
+ #NP = problēmas $L$, ko var atrisināt ar nedeterminētu mašīnu $O(n^c)$ laikā.

Ekvivalence ir pierādīta ar abpusēju pārveidojumu no pārbaudītāja uz nedet.
#TM un atpakaļ.

== NP-pilnas probēmas un to redukcijas

=== Polinomiāla redukcija $(<=#sub("poly"))$

- $A <= B$ – A var atrisināt, noreducējot to uz B.
- $A <=_("poly") B$, ja ir $O(n^c)$ laika algoritms (Tjūringa mašīna) $P$:
  - $M$ pārveido $A$ ieejas datus par $B$ ieejas datiem;
  - $A(x) = B(M(x))$.

=== NP-pilnīgums

- A – NP-pilna, ja:
  - $A in "NP"$;
  - Ja $B in NP$, tad $B <=#sub("poly") A$.

=== 3-SAT problēma

Vai formulai 3-CNF formā var piemeklēt katra mainīgā vērtības tā, lai formula
būtu 1 (patiess).

=== CIRCUIT-SAT problēma

Dota funkcija $F(x_1, ..., x_n)$, kas sastāv no vārtiem (`AND`, `OR`, `NOT`).

#figure(
  diagram(
    cell-size: 1mm,
    node-stroke: 0.5pt,
    node-shape: circle,
    spacing: 1em,
    node((0, 0), `OR`, name: <or-1>, radius: 1em),
    node((-1, 1), `AND`, name: <and-1>, radius: 1em),
    node((1, 1), `AND`, name: <and-2>, radius: 1em),
    node((-2, 2), $x_1$, stroke: none, name: <x1>, radius: 1em),
    node((0, 2), `OR`, name: <or-2>, radius: 1em),
    node((1, 2), `NOT`, name: <not>, radius: 1em),
    node((-1, 3), $x_2$, stroke: none, name: <x2>, radius: 1em),
    node((1, 3), $x_3$, stroke: none, name: <x3>, radius: 1em),

    edge((0, -1), <or-1>),
    edge(<or-1>, <and-1>),
    edge(<or-1>, <and-2>),
    edge(<and-1>, <x1>),
    edge(<and-1>, <or-2>),
    edge(<and-2>, <not>),
    edge(<or-2>, <x2>),
    edge(<or-2>, <x3>),
    edge(<not>, <x3>),
  ),
  caption: "CIRCUIT-SAT visual",
)

Vai var atrast mainīgo vērtības tā lai gala izvade būtu 1 (patiess).

=== CLIQUE problēma

$exists C subset.eq V: (abs(C) = k) and (forall (u, v in C): (u, v) in E)$

Vārdiski. Vai eksistē virsotņu kopa $S$ lielumā $k$, kurā katra virsotne ir
savienota ar katru otro no kopas $S$.

=== IND-SET problēma

$exists S subset.eq V: (abs(S) = k) and (forall (u, v in S): (u, v) in.not E)$

Vārdiski. Vai grafā $G=(V, E)$ eksistē virsotņu kopa $S$ lielumā $k$, kurā
katra no virsotnēm nav savienota ar nevienu citu virsotni no šīs
kopas.

=== LIN-INEQ problēma

Vai dotā lineāru nevienādību sistēma ar bināriem mainīgajiem ir atrisināma.

=== CIRCUIT-SAT $<=#sub("p")$ 3-SAT

- Katram starprezultātam (kas nav pirmajā ievadē, i.e., $x_1$, $x_2$, $dots$,
  $x_n$) ievieš jaunus mainīgos $y_i$.
- Katriem vārtiem formulē atbilstošas izteiksmes.

Piemērs `AND` vārtiem. Nosaucam ievades kā x, y un izvadi kā z: $z = x and y$

#table(
  columns: 4,
  [*$x$*], [*$y$*], [*$z$*], [*$z = x and y$?*],
  $0$, $0$, $0$, [jā],
  $0$, $0$, $1$, [nē],
  $0$, $1$, $0$, [jā],
  $0$, $1$, $1$, [nē],
  $1$, $0$, $0$, [jā],
  $1$, $0$, $1$, [nē],
  $1$, $1$, $0$, [nē],
  $1$, $1$, $1$, [jā],
)

Izveidojam pretrunas katrai rindai. Tas ir, konjunkciju katrai rindai ar "nē".

Piemēram, 2. rindai $(0, 0, 1)$: $x or y or not z$.

Tad uzbūvējam konjunkciju vārtiem:

$
  (x or y or not z) and (x or not y or not z) and \
  and (not x or y or not z) and (not x or not y or z)
$

Veido konjunkciju no visiem vārtiem shēmā. Tā kā 3-SAT sagaida 3 mainīgos katrā
iekavā.
Tiem, kas satur 1 vai 2 (identitātes vārti un not vārti attiecīgi), pārveido tos
par 3-CNF konjunkciju pievienojot jaunu mainīgo, kas vienā formulā ir pozitīvs
un otrā -- negācija.

$
  (x or not b) = (x or not b or a) and (x or not b or not a)
$

Analoģiski iekavām ar vienu elementu. Rezultātā ir 3-CNF formula, ko var
izmantot ar 3-SAT algoritmu.

=== 3-SAT $<=#sub("p")$ IND-SET

Katrai iekavai no formulas veido $3$ virsotnes (grafa komponenti), kas apzīmē
mainīgo (ar `NOT`, ja ir negācija). Katra virsotne (literālis) no komponentes ir
savā starpā savienota ar pārējām. Starp pretrunīgiem literāliem starp
komponentēm pievieno šķautni.

Piemērs formulai $(x or y or not z) and (not x or y or z)$:


#let dot-node(pos, name) = node(pos, name: name, fill: black, radius: 2pt)
#figure(
  diagram(
    cell-size: 1mm,
    node-stroke: 0pt,
    spacing: 1em,
    node-shape: circle,
    // phantom location nodes
    dot-node((0, 0), <y1>),
    dot-node((1, -1), <x>),
    dot-node((1, 1), <not-z>),
    dot-node((4, -1), <not-x>),
    dot-node((4, 1), <y2>),
    dot-node((5, 0), <z>),

    // label nodes
    node((rel: (-0.7em, 0em), to: <y1>), $y$),
    node((rel: (0em, 0.7em), to: <x>), $x$),
    node((rel: (0em, 0.7em), to: <not-x>), $not x$),
    node((rel: (0.7em, 0em), to: <z>), $z$),
    node((rel: (0em, -0.7em), to: <not-z>), $not z$),
    node((rel: (0em, -0.7em), to: <y2>), $y$),

    edge(<x>, <y1>),
    edge(<x>, <not-x>),
    edge(<x>, <not-z>),
    edge(<y1>, <not-z>),
    edge(<z>, <not-z>),
    edge(<z>, <not-x>),
    edge(<z>, <y2>),
    edge(<y2>, <not-x>),
  ),
  caption: [3-SAT $->$ INDSET visual],
)

Tagad varam pielietot $"IND-SET"(G, m)$ ar izveidoto grafu un $m$ kā iekavu
skaitu originālajā formulā.

=== IND-SET $<=#sub("p")$ CLIQUE

- Veido grafa papildinājumu (komplementu) $G' = (V, E')$:

$ E' := {(u, v) in V times V mid(|) (u, v) in.not E} $

Vārdiski. Jauns grafs $G$, kurā ir visas virsotnes no $V$, bet
visas šķautnes, kas ir $G$ nav $G'$ un pretēji -- visas šķautnes
kā nav $G$ ir $G'$.

#figure(
  diagram(
    cell-size: 1mm,
    node-stroke: 0pt,
    spacing: 1em,
    node-shape: circle,
    // phantom location nodes
    dot-node((0, 0), <b1>),
    dot-node((-2, 1), <a1>),
    dot-node((0, 2), <c1>),

    dot-node((0, 4), <b2>),
    dot-node((-2, 5), <a2>),
    dot-node((0, 6), <c2>),

    // label nodes
    node((rel: (0.7em, 0.7em), to: <b1>), $B$),
    node((rel: (-0.7em, 0em), to: <a1>), $A$),
    node((rel: (0.7em, 0.7em), to: <c1>), $C$),
    node((1, 1), text(green, $G$)),

    node((rel: (0.7em, 0.7em), to: <b2>), $B$),
    node((rel: (-0.7em, 0em), to: <a2>), $A$),
    node((rel: (0.7em, 0.7em), to: <c2>), $C$),
    node((1.6, 5), text(green, $G "papildinājums"$)),

    edge(<a1>, <b1>),
    edge(<c1>, <b1>, "--", stroke: yellow),
    edge(<c1>, <a1>),
    edge(<a2>, <b2>, "--", stroke: yellow),
    edge(<c2>, <b2>),
    edge(<c2>, <a2>, "--", stroke: yellow),
  ),
  caption: "Papildgrafa piemērs",
)

Ir spēkā sakarība $"INDSET"(G, k) = "CLIQUE"(G', k)$.

= Extras

== Logaritmu īpašības

#context [
  #set text(size: 10pt)
  #show math.equation: set text(weight: 400, size: 8pt)

  #figure(table(
    columns: 3,
    [*Property*], [*Definition*], [*Example*],
    [Product],
    $ log_b m n = log_b m + log_b n $,
    $ log_3 9 = log_3 9 + log_3 x $,

    [Quotient],
    $ log_b m/n = log_b m - log_b n $,
    $
      log_(1/4) 4/5 = log_(1/4) 4
      - log_(1/4) 5
    $,

    [Power], $ log_b m^p=p dot log_b m $, $ log_2 8^x = x dot log_2 8 $,
    [Equality],
    $ "If" log_b m = log_b n, \ "then" m=n $,
    $
      log_8(3x-4)=log_8(5x+2) \
      "so," 3x-4=5x+2
    $,

    [Pow. to log],
    $
      a^(log_a (x)) = x
    $,
    $
      2^(log_2 (x)) = x
    $,
  ))
]

== Atvasinājumu tabula
#context [
  #set text(size: 11pt)
  #show math.equation: set text(weight: 400, size: 11pt)

  #table(
    columns: 3,
    // vert. padding
    [*Funkcija*],
    [*Atvasinājums #footnote[Ja $x = g(x)$ (kompleksa funkcija), tad pie atvasinājuma piereizina $g(x)'$.]*],
    [*Piezīmes*],

    $ x^n $, $ n x^(n-1) $, "",
    $ e^x $, $ e^x $, "",
    $ a^x $, $ a^x ln(a) $, $ a > 0 $,
    $ ln(x) $, $ 1 / x $, "",
    $ log_a (x) $, $ 1 / (x ln(a)) $, "",
    $ 1 / x $, $ -1 / x^2 $, "",
    $ 1 / x^n $, $ -n / x^(n+1) $, "",
    $ sqrt(x) $, $ 1 / (2 sqrt(x)) $, "",
    $ 1 / sqrt(x) $, $ -1 / (2 x^(3/2)) $, "",
  )
]

== Atvasinājumu īpašības
#context [
  #set text(size: 11pt)
  #show math.equation: set text(weight: 400, size: 11pt)

  #table(
    columns: 3,
    [*Rule Name*], [*Function*], [*Derivative*],

    [Summa], [$ f(x) + g(x) $], [$ f'(x) + g'(x) $],
    [Starpība], [$ f(x) - g(x) $], [$ f'(x) - g'(x) $],
    [Reizinājums], [$ f(x) dot g(x) $],
    [
      $
        f'(x) dot g(x) + \
        f(x) dot g'(x)
      $
    ],

    /*
    [Quotient Rule], [$ (f'(x) dot g(x) - f(x) * g'(x)) / (g(x))^2 $], [$ (f'(x) * g(x) - f(x) * g'(x)) / (g(x))^2 $],
    [Chain Rule], [$ f(g(x)) $], [$ f'(g(x)) dot g'(x) $],
    [Euler’s Number Exponent Rule], [$ e^x $], [$ e^x $],
    [Constant Exponent Rule], [$ a^x $], [$ a^x dot ln(a) $],
    [Natural Log Rule], [$ ln(x) $], [$ 1 / x $],
    [Logarithm Rule], [$ log_a(x) $], [$ 1 / (x dot ln(a)) $],
    [Sine Rule], [$ sin(x) $], [$ cos(x) $],
    [Cosine Rule], [$ cos(x) $], [$ -sin(x) $],
    [Tangent Rule], [$ tan(x) $], [$ sec^2(x) $],
    [Cosecant Rule], [$ csc(x) $], [$ -csc(x) dot cot(x) $],
    [Secant Rule], [$ sec(x) $], [$ sec(x) dot tan(x) $],
    [Cotangent Rule], [$ cot(x) $], [$ -csc^2(x) $],
    */
  )
]

== Kāpinājumu īpašības
#context [
  #set text(size: 11pt)
  #show math.equation: set text(weight: 400, size: 11pt)

  #table(
    columns: 2,
    [*Rule Name*], [*Formula*],

    [Reizinājums], [$ a^m dot a^n = a^(m+n) $],
    [Dalījums], [$ a^m / a^n = a^(m-n) $],
    [Pakāpes pakāpe], [$ (a^m)^n = a^(m dot n) $],
    [Reizinājuma pakāpe], [$ (a dot b)^m = a^m dot b^m $],
    [Dalījuma pakāpe], [$ (a/b)^m = a^m / b^m $],
    [0-pakāpe], [$ a^0 = 1 $],
    [Negatīva pakāpe], [$ a^(-m) = 1 / a^m $],
    [Saikne ar sakni], [$ a^(m/n) = root(n, a^m) $],
  )
]



== Noderīgas izteiksmes laika analīzē<time_analysis_expressions>

$
  sum_(i=1)^(n) i = (n(n+1))/(2) \
  sum_(i=1)^(n) i^2 = (n(n+1)(2n+1))/(6)\
  sum_(i=1)^(n) i^3 = ( (n(n+1))/(2))^2 \
  // Geometric series (ratio r \neq 1)
  r > 1: sum_(i=0)^(n) a dot r^i = a dot (r^(n+1)-1)/(r-1) quad \
  r < 1: sum_(i=0)^(oo) a dot r^i = (a)/(1-r) \
  // Logarithmic sum
  sum_(i=1)^(n) log i = log(n!) approx n log n - n + O(log n) \
  // Exponential sum (appears in brute-force algorithms)
  sum_(i=0)^(n) 2^i = 2^(n+1) - 1 \
$
