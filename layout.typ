#import "@preview/i-figured:0.2.4"
#import "@preview/tablex:0.0.9": tablex
#import "@preview/headcount:0.1.0": *

#let indent = 1cm

#let indent-par(body) = par(h(indent) + body)

#let project(
  title: [],
  authors: (),
  body,
) = {
  set document(author: authors)

  set page(
    columns: 2,
    margin: (
      left: 10mm,
      right: 10mm,
      top: 10mm,
      bottom: 10mm,
    ),
    number-align: center,
    paper: "a4",
  )
  set text(
    font: (
      "Times New Roman",
      "New Computer Modern",
    ),
    size: 12pt,
    hyphenate: auto,
    lang: "lv",
    region: "lv",
  )
  show raw: set text(
    font: (
      "JetBrainsMono NF",
      "JetBrains Mono",
      "Fira Code",
    ),
    features: (calt: 0),
  )

  show math.equation: set text(weight: 400)

  // Formatting for regular text
  set par(justify: true, leading: 1em)
  show heading: set block(spacing: 0.7em)
  show heading: set text(size: 14pt)
  show heading: set par(justify: false)

  set terms(separator: [ -- ])

  // Headings
  set heading(numbering: "1.1.")

  // Start page numbering
  set page(numbering: "1", number-align: center)

  // WARNING: remove before sending
  // outline(title: "TODOs", target: figure.where(kind: "todo"))
  /* --- Figure/Table config start --- */
  show heading: i-figured.reset-counters
  show figure: i-figured.show-figure.with(numbering: "1.1.")
  set figure(numbering: dependent-numbering("1.1"))
  set figure(placement: none)

  show figure.where(kind: "i-figured-table"): set block(breakable: true)
  show figure.where(kind: "i-figured-table"): set figure.caption(position: top)
  show figure.where(kind: "attachment"): set figure.caption(position: top)
  show figure.where(kind: raw): set figure.caption(position: top)


  show figure: set par(justify: false) // disable justify for figures (tables)
  show figure.where(kind: table): set par(leading: 1em)
  show figure.where(kind: image): set par(leading: 0.75em)
  show figure.caption: set text(size: 11pt)

  show figure.caption: it => {
    if it.kind == "i-figured-table" {
      return align(
        end,
        emph(it.counter.display(it.numbering) + " tabula ")
          + text(weight: "bold", it.body),
      )
    }
    if it.kind == "i-figured-image" {
      return align(
        start,
        emph(it.counter.display(it.numbering) + " att. ")
          + text(weight: "bold", it.body),
      )
    }
    if (
      it.kind
        in (
          "i-figured-raw",
          "i-figured-\"attachment\"",
        )
    ) {
      return align(end, it.counter.display() + ". pielikums. " + text(it.body))
    }
    it
  }

  // disable default reference suppliments
  set ref(supplement: it => { })

  // Custom show rule for references
  show ref: it => {
    let el = it.element

    if el == none {
      return it
    }

    if el.func() == heading {
      return link(
        el.location(),
        numbering(el.numbering, ..counter(heading).at(el.location()))
          + " "
          + el.body,
      )
    }

    if el.func() == figure {
      let kind = el.kind

      // Map for different kinds of supplements
      let supplement_map = (
        i-figured-table: "tab.",
        i-figured-image: "att.",
        attachment: "pielikumu",
      )


      // Get the supplement value properly
      let supplement = if type(it.supplement) != function {
        it.supplement
      } else {
        if kind in supplement_map {
          supplement_map.at(kind)
        } else {
          ""
        }
      }

      let number = if kind == "attachment" {
        (
          numbering(el.numbering, ..counter(figure.where(kind: kind)).at(
            el.location(),
          ))
            + "."
        ) // Only add dot for attachments
      } else {
        numbering(el.numbering, ..counter(figure.where(kind: kind)).at(
          el.location(),
        )) // No extra dot for tables and images
      }

      // Create counter based on the kind
      return link(
        el.location(),
        number
          + if supplement != "" {
            " " + supplement
          } else {
            ""
          },
      )
    }

    // Default case for non-figure elements
    it
  }
  /* --- Figure/Table config end --- */

  set list(marker: ([•], [--], [\*], [·]))
  set enum(
    numbering: "1aiA)",
  ) // TODO: make the same style as LaTeX: 1. | (a) | i. | A.


  outline(depth: 3, indent: indent, title: text(size: 14pt, "Saturs"))

  body
}
