#import "@preview/finite:0.5.0": automaton
#import "@preview/fletcher:0.5.7" as fletcher: diagram, edge, node
#import "@preview/gentle-clues:1.2.0": *
#import "layout.typ": indent-par, project

#show: project.with(title: [Theory of Algorithms Cheatsheet], authors: (
  "Kristofers Solo",
))

#let teo(title: "Teorēma", ..args) = memo(title: title, ..args)

#let TM = `TM`
#let qrej = $q_"rej"$
#let qacc = $q_"acc"$
#let halt = `HALTING`
#let halt2 = `HALTING2`
#let NP = `NP`

= Tjūringa Mašīnas
== Info
Var būt 3 veida uzdevumi: stāvokļu, tekstuāls, vairāklenšu.

=== Viena lente
$(q, a) -> (q', a', d)$ -- stāvoklī $q$ redzot $a$, ieraksta $a'$
un iet virzienā $d space (<- "vai" ->)$.

=== Divas lentes
$(q, a_1, a_2) -> (q', b_1, b_2, d_1, d_2)$ -- $a_1$, $b_1$, $d_1$ pirmai lentei
un $a_2$, $b_2$, $d_2$ otrai lentei.

=== Stāvēšana uz vietas
Nosimulēt stāvēšanu uz vietas jeb $d=0$ var šādi:
- $(q, a) -> (q_"new", a', ->)$
- $(q_"new", a slash b slash c slash * ) -> (q_"new", a slash b slash c slash *, <-)$

== Soļi
+ Izdomāt, kā aizstājot simbolus ar $*$ var pārbaudīt virknes derību.
+ Atcerēties par secību -- aiz $a$ var sekot tikai $b slash c$, aiz $b$ var sekot tikai $c$, utt.
+ Doties katrā no virzieniem var doties arī līdz galam jeb tukšumam $\_$.
+ Vairāklenšu #TM pārraksta pirmo daļu līdz $\#$ uz otras lentes un salīdzina.

== Piemērs
Vai ieejas virknē $a^n b^n c^n$, kur $n>0$

#context [
  $(q_1, a) -> (q_2, *, ->)$ \
  $(q_1, b slash c) -> qrej$ \
  $(q_1, *) -> (q_1, *, ->)$ \
  $(q_1, \_) -> qacc$ \

  $(q_2, a) -> (q_2, a, ->)$ \
  $(q_2, b) -> (q_3, *, ->)$ \
  $(q_2, c) -> qrej$ \
  $(q_2, *) -> (q_2, *, ->)$ \

  $(q_3, a) -> qrej$ \
  $(q_3, b) -> (q_3, b, ->)$ \
  $(q_3, c) -> (q_4, *, ->)$ \
  $(q_3, *) -> (q_3, *, ->)$ \

  $(q_4, a slash b) -> qrej$ \
  $(q_4, c) -> (q_4, c, ->)$ \
  $(q_4, \_) -> (q_5, \_, <-)$ \

  $(q_5, a slash b slash c slash *) -> (q_5, a slash b slash c slash *, <-)$ \
  $(q_5, \_) -> (q_1, \_, ->)$ \
]

- Aizstāj $a$ ar $*$, $b$ ar $*$, $c$ ar $*$.
- Kontrolē secību (pēc $a$ jāseko $a$ vai $b$, pēc $b$ jāseko $b$ vai $c$, pēc
  $c$ var sekot tikai $c$).
- Ja kādu simbolu nevar atrast, noraida.

== Piemērs
Vai ieejas virkne $x \# x$, kur $x in {0,1}^*$

#context [
  $(q_1, 0, \_) -> (q_1, 0, 0, ->, ->)$ \
  $(q_1, 1, \_) -> (q_1, 1, 1, ->, ->)$ \
  $(q_1, \#, \_) -> (q_2, \#, \_, 0, <-)$ \

  $(q_2, 0, 0) -> (q_2, 0, 0, <-)$ \
  $(q_2, 1, 1) -> (q_2, 1, 0, <-)$ \
  $(q_2, \#, \_) -> (q_3, \#, \_, ->, ->)$ \

  $(q_3, 0, 0) -> (q_3, 0, 0, ->, ->)$ \
  $(q_3, 0, 1) -> qrej$ \
  $(q_3, 1, 0) -> qrej$ \
  $(q_3, 1, 1) -> (q_3, 1, 1 ->, ->)$ \
  $(q_3, 0 slash 1, \_) -> qrej$ \
  $(q_3, \_, 0 slash 1) -> qrej$ \
  $(q_3, \_, \_) -> qacc$ \
]

- Nokopē simbolus līdz $\#$ uz otras lentes.
- Sasniedzot $\#$, uz otras lentes iet atpakaļ līdz pirmajam simbolam.
- Salīdzina pirmās lentes simbolus pēc $\#$ ar otro lenti.

#set page(columns: 2)
= Lielais $O$ un mazais $o$
== Info
- Tiek dota funkcija un jānosaka vai tā atrisināma dotajā lielā $O$ vai mazā $o$
  laikā.
- Ja funkcija aug straujāk par lielo $O$, tad apgalvotā vienādība būs patiesa.
- Ja funkcija aug straujāk par mazo $o$, tad apgalvotā vienādība būs nepatiesa.

== Soļi
- Ja funkcija pielīdzināta lielajam $O$:
  + Salīdzina funkcijas augstāko pakāpi ar doto $O$ pakāpi.
  + Ja funkcijas pakāpe ir lielāka, tad vienādojums būs patiess, jo funkcija aug
    straujāk.
- Ja funkcija pielīdzināta mazajam $o$:
  + Jāievieto dotais robežā $lim_(x->oo)f(x)/g(x)$, kur $f(x)$ ir funkcija un
    $g(x)$ ir $o$.
  + Ja rezultāts sanāk tuvu $0$, tad vienādojums būs patiess, jo funkcija aug
    lēnāk.

== Piemērs
$ 2n^4 + 6n^2 + 17 =^? O(n^4) $

Izteiksme ir patiesa, tā kā kreisās puses izteiksmes augstākā pakāpe jeb kārta
ir $4$ un iekš $O$ tā arī ir $4$.

== Piemērs
$ 2n^4 + 6n^2 + 17 =^? O(n^3) $

Izteiksme ir aplama, jo kreisajā pusē augstākā pakāpe ir $4$, kamēr labajā ir norādīta $3$, un $4$ pakāpes izteiksmi nevar izpildīt $O(n^3)$.


== Piemērs <small-o-example-3>
$ n log^4 n =^? o(n^1.5) $

Ir zināms, ka mazajā $O$ notācijai, ja $lim_(x->oo)f(x)/g(x)$, kur $f(x)$ ir
funkcija un $g(x)$ ir $o$, tad vienādība izpildās.
Ievietojot vērtības $ lim_(n->oo) (n log^4 n)/n^1.5=0 $
Tātad vienādojums ir
patiess.

== Piemērs
$ 2^n n^2 =^? o(n^3) $

Pēc tās pašas aprakstītās īpašības, kā @small-o-example-3, sanāktu
$ lim_(n->oo) (2^n n^2)/3^n $
un tā kā $3^n$ aug ātrāk kā $2^n$, šī robeža būs $0$ un sākotnējais
vienādojums būs patiess.

== Piemērs
$ n^3 + 17n + 4 in^? O(n^3) $

Jā, $n^3 + 17n + 4 <= n^3 + 17n^3 + 4n^3 = 22n^3$.

== Piemērs
$ n^4 + 17n + 4 in^? O(n^3) $

Nē $n^4 + 17n + 4 > n^4 = n dot n^3$

= Sanumurējamība
== Info
- Bezgalīgas kopas $A$, $B$ ir vienāda izmēra, ja ir bijekcija ($1:1$ attiecība)
  $F: A->B$.
- $A$ ir sanumurējama ar atkārtojumiem, ja ir attēlojums $F:N->A$, kas par katru
  $a$ $E$ $A$ attēlo vismaz vienu $x$ $E$ $N$.
#teo[$A$ ir sanumurējama ar atkārtojumiem tad un tikai tad, ja $A$ ir sanumurējama.]

== Soļi
- Kopa ir sanumurējama, ja tajā eksistē viennozīmīga atbilstība (bijekcija)
  starp kopas elementiem un naturāliem skaitļiem.
  Citos vārdos sakot, katram kopas elementam var piešķirt unikālu naturālu
  skaitli.
- Ja kopa ir galīga, tā ir triviāli sanumurējama, jo katram elementam var
  piešķirt unikālu naturālu skaitli.
- Ja kopa ir bezgalīga, jāņem vērā divi varianti:
  - Ja var izveidot bijekciju starp kopu un naturāliem skaitļiem, tad jāpierāda,
    ka bijekcija nepastāv.
    Var skaidri definēt funkciju, kas katram kopas elementam piešķir unikālu
    naturālu skaitli un parādīt, ka tā apvieno visus elementus bez dublēšanās.
  - Ja nevar atrast bijekciju starp kopu un naturāliem skaitļiem, tad jāpierāda,
    ka bijekcija nepastāv.
    Parasti tas tiek darīts, izmantojot pierādīšanas tehnikas, piemēram,
    diagonālināciju vai pretrunu (sk. @diagonalization, @contradiction).
- Ja izdodas pierādīt, ka start kopu un naturāliem skaitļiem nav bijekcijas, tad
  kopa ir nesaskaitāma.

=== Diagonālinācija <diagonalization>
Ietver paņēmienu, ka ir saraksts vai uzskaitījums ar visiem kopas elementiem un
tiek konstruēts jauns elementu, kas neatrodas šajā sarakstā.
Tas demonstrē, ka kopa ir nesaskaitāma, jo vienmēr var izveidot jaunu elementu,
kas nav iekļauts uzskaitē.

=== Pretruna <contradiction>
Pieņem, ka kopa ir saskaitāma un tad rodas pretruna.
To var izdarīt, parādot, ka kaut kādas kopas īpašības vai kardinalitāte ir
pretrunā ar sanumurējamības pieņēmumu.

== Piemērs
Vai visu veselo skaitļu kopa $ZZ={..., -1, 0, 1, ...}$ ir sanumurējama? \
Vai ir $F:{F(1), F(2), ..., F(n), ...}=ZZ$? \


$ F(1)=0, F(2)=-1, F(3)=1, F(4)=-2, ... $

Viens no veidiem, kā izveidot bijekciju pāra kopai, ir izmantot metodi, ko sauc
par Kantoro pārošanas funkciju.
Kantora pārošanas funkcija ir definēta sekojoši:
$f(k_1, k_2) := 1/2(k_1 + k_2)(k_1 + k_2 + 1) + k_2$, kur $k_1,k_2 in NN = {0, 1, 2, ...}$

#figure(
  image("assets/img/cantors-pairing-function.png", width: 50%),
  caption: "Cantor's pairing function",
)

Šī funkcija kā ievadi pieņem naturālo skaitļu pāri $(k_1, k_2)$ un to attēlo
kā unikālu naturālo skaitli.
Tā nodrošina, ka katram pārim tiek piešķirts unikāls skaitlis un tiek aptverti
visi iespējamie pāri bez atkārtojumiem.

Lai pierādītu, ka naturālo skaitļu pāru $(k_1, k_2)$ kopa ir saskaitāma, mēs
varam parādīt, ka funkcija $f(k_1, k_2)$ nodrošina bijekciju starp naturālo
skaitļu pāru kopu un naturālo skaitļu kopu.

=== Injektivitāte
Pieņemsim, ka $f(k_1, k_2) = f(k_3, k_4)$, kur $(k_1, k_2)$ un $(k_3, k_4)$
ir atšķirīgi pāri no naturālo skaitļu kopas.
Vienkāršojot un nolīdzinot izteiksmes, varam parādīt, ka
$k_1 = k_3$ un $k_2 = k_4$.
Tātad funkcija $f$ ir injektīva.

=== Surjektivitāte
Jebkuram naturālam skaitlim $n$ varam atrast pāri $(k_1, k_2)$, kas tiek
attēlots uz $n$, izmantojot Kantora pārošanas funkcijas apgriezto funkciju.
Pielietojot apgriezto funkciju uz $n$, varam atgūt sākotnējo pāri $(k_1, k_2)$.
Tādējādi funkcija $f$ ir surjektīva.

= Redukcijas
Given a problem $halt2(M, x, y) = 1$ where turing machine $M$ halts on at least
one of the inputs $x$ or $y$, prove and show that it can or can't be reduced to
$halt(halt <= halt 2)$.

To prove that the problem $halt2(M, x, y)$ can be reduced to #halt, we need to
show that we can construct a Turing machine that solves #halt2 using a
subroutine for solving #halt.

Let's assume we have a Turing machine $H$ that solves the #halt problem.
We will construct a new Turing machine $H 2$ that solves the #halt2 problem
using $H$ as a subroutine.

The Turing machine $H 2$ works as follows:
+ Given inputs $M$, $x$, and $y$.
+ Run $H$ on the input $(M, x)$.
+ If $H$ accepts $(M, x)$, halt and accept.
+ If $H$ rejects $(M, x)$, run $H$ on the input $(M, y)$.
+ If $H$ accepts $(M, y)$, halt and accept.
+ If $H$ rejects $(M, y)$, halt and reject.

By constructing $H 2$ in this way, we are simulating the behavior of $H$ on
both inputs $x$ and $y$.
If $H$ accepts either $(M, x)$ or $(M, y)$, $H 2$ will also accept and halt.
If $H$ rejects both $(M, x)$ and $(M, y)$, $H 2$ will also reject and halt.

Now, let's analyze the reduction:

- If $halt2(M, x, y) = 1$, it means that Turing machine $M$ halts on at least
  one of the inputs $x$ or $y$.
  In this case, $H 2$ will also halt and accept, because it successfully
  simulates $H$ on both inputs and accepts if $H$ accepts either of them.
  Thus, #halt2 is reduced to #halt.
- If $halt2(M, x, y) = 0$, it means that Turing machine $M$ does not halt on
  both inputs $x$ and $y$.
  In this case, $H 2$ will also not halt and will reject, because it simulates
  $H$ on both inputs and rejects if $H$ rejects both of them.
  Thus, #halt2 is reduced to #halt.

Therefore, we have shown that the problem #halt2 can be reduced to #halt by
constructing a Turing machine $H 2$ that uses $H$ as a subroutine.
This reduction demonstrates that #halt2 is computationally no harder than
#halt, implying that #halt2 is at least as undecidable as #halt.

= Daļēja atrisināmība
== Info
A problem is considered partially undecidable if it is not decidable, meaning
there is no algorithm that can correctly determines a "yes" or "no" answer for
every input instance of the problem.
However, it may still be semidecidable, also known as recursively enumerable.

In the context of Turing machines and computability theory, a problem is
partially undecidable if there exists a Turing machine that halts and produces a
"yes" answer for every instance that belongs to the problem, but may either loop
indefinitely or reject instances that do not belong to the problem.
In other words, there is an algorithm that can recognize the instances that
satisfy the problem's criteria but may not halt on instances that do not.

A problem being partially undecidable means that there is no total algorithm
that can always produce a correct "no" answer for instances outside the problem.
It may be possible to construct a Turing machine that halts and produces a "no"
answer for certain instances outside the problem, but this is not guaranteed for
all instances.

#teo(
  title: "Raisa teorēma",
)[Ja $F$ nav triviāla (ir $M:F(M)=0$ un $M':F(M')=1$), tad $F$ -- neatrisināma.]

$A$ -- daļēji atrisināma, ja ir Tjūringa mašīna $T$:
- Ja $A(x)=1$, tad $T(x)=1$.
- Ja $A(x)=0$, tad $T(x)=0$ vai $T(x)$ neapstājas.

#teo[$A$ -- daļēji atrisināma tad un tikai tad, ja $A$ -- algoritmiski sanumurējama.]

= Algoritmiskā sanumurējamība
== Info
- Kopa $A$ ir sanumurējama, ja $A={x_1, x_2, ...}$
- Kopa $A$ ir algoritmiski sanumurējama, ja ir Tjūringa mašīna, kas izdod virkni
  $x_1, x_2, ...$, kurai $A={x_1, x_2, ...}$
#let DL = `DL`
#let IL = `IL`
Divu lenšu #TM, kur viena ir klasiska darba lente (#DL) un otra ir izvada
lente (#IL) (tikai rakstīšanai).

== Piemērs
Pamatot, ka kopa ${a^k b^k mid(|) k>=0}$ ir algoritmiski sanumurējama.

+ Uzraksta uz izejas lentes tukšu vārdu.
+ Uzraksta vienu $a$ uz darba lentes.
+ Atkārto:
  + Uz ieejas lentes uzrakstām tikpat $a$, cik bija uz #DL;
  + Uz izejas lentes uzrakstām tikpat $b$, cik $a$ bija uz #DL;
  + Uz izejas lentes uzrakstām $\_$;
  + Uz darba lentes pierakstām klāt vienu $a$.
+ Izejas lente $=epsilon, a b, a a b b, a a a b b b,...$

== Piemērs
Pamatot, ka kopa ${x \# x mid(|) x in {a, b}^* }$ ir algoritmiski sanumurējama.

+ Uz darba lentes iet cauri visiem $x$.
+ Katram $x$ uz izejas lentes uzraksta $x \# x$.
+ Uz izejas lentes uzraksta $\#\_$.
+ Uz darba lentes uzraksta $a$.
+ Atkārto:
  + Pārraksta darba lentes saturu $x$ uz izejas lenti;
  + Uzraksta $\#$ uz #IL, vēlreiz pārraksta $x$ uz #IL, uzrakstām $\_$ uz #IL.
  + Uz #DL nomaina $x$ pret nākošo vārdu.

= #TM darbības laiks
== Info
- Laiks ir soļu skaits un ir atkarīgs no ieejas virknes $x_1, x_2, ..., x_n$.
- Ja ir algoritms ar sarežģītību $n^2$, tad bieži ir arī algoritms ar
  sarežģītību $n^2/2, n^2/3,...$

== Soļi
+ Identify the key operations or steps performed by the Turing machine for each
  input.
  + This could include reading symbols from the tape, writing symbols to the
    tape, moving the tape head, performing computations, or making decisions
    based on the current state and input symbol.
+ Determine the worst-case scenario.
  + Analyze the input or sequence of inputs that would require the maximum
    number of steps for the Turing machine to complete its computation.
  + Consider inputs that maximize the number of iterations or force the machine
    to explore all possible branches of computation.
+ Express the runtime in terms of the input size.
  + Define a function that represents the number of steps or transitions taken
    by the Turing machine as a function of the input size.
  + For example, if the input size is $n$, the runtime function could be denoted
    as $f(n)$.
+ Simplify the runtime function and express it using Big $O$ notation.
  + Big $O$ notation provides an upper bound on the growth rate of the runtime
    function as the input size increases.
  + Remove constant factors and lower-order terms from the runtime function to
    focus on the dominant term that represents the growth rate.
  + Express the simplified runtime function using the appropriate Big $O$ notation,
    such as $O(n)$, $O(n log n)$, $O(n^2)$, $O(2^n)$, etc.

== Piemērs
Vai ieejas virknē ir vienāds skaits $a$ un $b$?

+ Virzās no kreisās puses uz labo, aizstājot vienu $a$ un vienu $b$ ar $x$;
+ Ja neatrod nedz $a$, nedz $b$, akceptē;
+ Ja neatrod vienu no $a$ vai $b$, noraida;
+ Ja atrod gan $a$, gan $b$, virzās atpakaļ uz pirmo simbolu un atkārto.

Kopējais soļu skaits:
- Ne vairāk kā $(n/2+1) 2n = n^2 + 2n$ soļi.
- Ja $n$ nav ļoti mazs, $n^2$ būs vairāk nekā $2n$ un soļu skaits $O(n^2)$.

= #NP (neatrisināmas problēmas)

#let acc = `ACCEPTING`
#let eqans = `EQUAL_ANSWERS`
#let one = `ONE`
#let infinite = `INFINITE`
#let equiv = `EQUIV`
#let hamcycle = `HAMCYCLE`
#let linineq = `LIN-INEQ`
#let M1 = $M 1$
#let M2 = $M 2$

== Info
- $halt(M\# x)=1$, ja $M$ apstājas, ja ieejas virkne $=x$.
- $acc(M\# x)=1$, ja $M$ uz ieejas virknes izdod atbildi $1$.
- $eqans(M\# x \# y)=1$, ja $M$ uz ieejas virknēm $x$ un $y$ izdod vienādas atbildes.
- $one(M)=1$, ja eksistē ieejas virkne $x$, uz kuras $M$ izdod atbildi $1$.
- $infinite(M)=1$, ja eksistē bezgalīgi daudzas ieejas virknes $x$, uz kurām $M$ izdod atbildi $1$.
- $equiv(M 1, M 2)=1$, ja $M1(x)=M2(x)$
- $hamcycle(G)=1$, ja grafā $G$ ir cikls (šķautņu virkne
  $v_1 v_2,v_2 v_3, ..., v_n v_1$), kurā katra virsotne ir tieši $1$ reizi.
- $linineq(S)=1$, ja sistēmai ir atrisinājums $x_1, x_2, ..., x_n in {0,1}$

#info[Ja var atrisināt #acc, tad var atrisināt arī #halt.]
#info[Ja var atrisināt #eqans / #one / #infinite / #equiv, tad var atrisināt arī #acc.]

== Soļi
+ Skaidri definē problēmu, kuru vēlas pierādīt kā #NP -- norādot, kas ir derīga
  ievade un kādus rezultātus programmai paredzēts izvadīt.
+ Pieņem, ka eksistē algoritms vai #TM, kas spēj atrisināt problēmu visiem
  iespējamiem ievaddatiem.
  Šī pieņēmuma mērķis ir rādīt pretrunu.
+ Definē citu problēmu, kas var tikt samazināta līdz sākotnējai problēmai.
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
  == Piemēri
  === #halt / #acc
  - #underline("Teorēma"): Ja var atrisināt #acc, tad var atrisināt arī #halt
  - #underline("Pierādījums"): Attēlojums $R:M->M'$ ar īpašību $halt(M\#x) = acc(M'\#x)$.
  - Tad $halt(M\#x)$ var atrisināt sekojoši:
  - izrēķina $M'=R(M)$, izrēķinām, vai $acc(M'\#x)$.
  - $M'$ -- programma, ko iegūst no $M$, visur aizstājot #qrej ar #qacc.
  - Ja $M$ akceptē/noraida, tad $M'$ akceptē (izdos $1$).
  - Ja $M$ neapstājas, $M'$ arī neapstājas.

  === #eqans/ #acc
  - #underline("Zinām"): #acc nav atrisināma
  - #underline("Pierādām"): Ja var atrisināt #eqans, tad var atrisināt arī #acc.
  - #underline("Secinām"): #eqans nevar atrisināt.
  - Dots: $M, x$
  - Jādefinē: $M', y: eqans(M' \# x \# y) = acc(M\# x)$.
  - $y$ -- virkne no viena simbola $s$, kas nav vārdā $x$.
  - Ja $M'$ redz simbolu $s$, $M'$ akceptē, citādi darbina $M$.
  - $M'(quote.angle.l.double s quote.angle.r.double)=1$, $M'(x)=M(x)$, ja $x$ nesatur $s$.
  - $eqans(M'\# x \# quote.angle.l.double s quote.angle.r.double)=acc(M\#x)$.

  === #one/ #acc
  - #underline("Pierādām"): Ja var atrisināt #one, tad var atrisināt arī #acc.
  - Dots: $M, x$
  - Jādefinē: $M': one(M') = acc(M\# x)$.
  - $M'$: nodzēš no lentes ieejas virkni $y$, uzraksta $x$, palaiž $M$ programmu.
  - Jebkurai $y, M'(y)=M(x)$.

  === #infinite/ #acc
  - #underline("Pierādām"): Ja var atrisināt #infinite, tad var atrisināt arī #acc.
  - Dots: $M, x$
  - Jādefinē: $M': infinite(M') = acc(M\# x)$.
  - Jebkurai $y, M'(y)=M(x)$.
  - Ja $M(x)=1$, tad $M'(y)=1$ jebkurai $y$.

  === #equiv / #acc
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

= Sarežģītības klases
#let time = `TIME`
== Info
$n, n log n, n^2, n^3, 2^n$

$time(f(n))$ -- problēmas $L$, kurām eksistē Tjūringa mašīna $M$, kas pareizi
risina $L$ un izmanto $O(f(n))$ soļus.

#info(
  title: "Vispārīgāk",
)[Ja $a<b$, tad $n^3 in o(n^b)$, jo $n^a/n^b=1/n^(b-a)->0$.]

$ lim n/2^n=lim (n)'/(2^n)'=lim 1/(2^n ln 2) $

Augot $n$, $2^n->oo$, tātad $1/n^2->0$.

$ n^2/2^n=(n/2^(n slash 2))^2 $
Mēs zinām, ka $n/2^(n slash 2)->0$.

$ lim (log n)/n = lim (log n)'/(n)' = lim (1 slash n)/1 = lim 1/n $

$ lim (log^17 n)/n = lim (m^17)/c^m = lim (m/c^(m slash 17))^17 -> 0 $

- $time(n)$ -- `2x` lielākā laikā var atrisināt problēmu `2x` lielākam $n$.
- $time(n^2)$ -- `4x` lielākā laikā var atrisināt problēmu `2x` lielākam $n$.
- $time(n^3)$ -- `8x` lielākā laikā var atrisināt problēmu `2x` lielākam $n$.
