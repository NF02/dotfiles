<TeXmacs|2.1.5>

<style|source>

<\body>
  <\active*>
    <\src-title>
      <src-style-file|Academy|1.0>

      <\src-purpose>
        Scrittura di saggi su formato tascabile e strutturato
      </src-purpose>

      <\src-copyright|2026>
        Nicola Ferru Aka NFVblog
      </src-copyright>

      <\src-license>
        This software falls under the <hlink|GNU general public license,
        version 3 or later|$TEXMACS_PATH/LICENSE>. It comes WITHOUT ANY
        WARRANTY WHATSOEVER. You should have received a copy of the license
        which the software. If not, see <hlink|http://www.gnu.org/licenses/gpl-3.0.html|http://www.gnu.org/licenses/gpl-3.0.html>.
      </src-license>
    </src-title>
  </active*>

  <use-package|std|env|title-book|header-book|section-book>

  \;

  <assign|language|italian>

  <\active*>
    <\src-comment>
      Font.
    </src-comment>
  </active*>

  <assign|font|Stix>

  <assign|font-family|rm>

  <assign|font-base-size|10>

  \;

  <\active*>
    <\src-comment>
      Formato pagina
    </src-comment>
  </active*>

  <assign|page-width-text|120mm>

  <assign|page-odd|35mm>

  \;

  <assign|page-type|In ottava>

  <assign|page-width|152mm>

  <assign|page-height|228mm>

  \;

  <\active*>
    <\src-comment>
      Testatine.
    </src-comment>
  </active*>

  <assign|odd-page-text|<macro|s|<assign|page-odd-header|<quasiquote|<small|<style-with|src-compact|none|<wide-std-underlined|<with|font-shape|small-caps|<unquote|<arg|s>>><htab|5mm><unquote|<page-number>>>>>>>>>

  <assign|even-page-text|<macro|s|<assign|page-even-header|<quasiquote|<small|<style-with|src-compact|none|<wide-std-underlined|<unquote|<page-number>><htab|5mm><with|font-shape|small-caps|<unquote|<arg|s>>>>>>>>>>

  \;

  <\active*>
    <\src-comment>
      Pagina del titolo
    </src-comment>
  </active*>

  <assign|doc-title|<macro|x|<\surround|<vspace*|0.5fn>|<vspace|0.8fn>>
    <doc-title-block|<font-magnify|1.682|<doc-title-name|<arg|x>>>>
  </surround>>>

  <assign|doc-subtitle|<macro|x|<\surround|<vspace*|0.25fn>|<vspace|0.5fn>>
    <doc-title-block|<font-magnify|0.8|<doc-title-name|<with|font-shape|italic|<arg|x>>>>>
  </surround>>>

  <assign|author-email|<macro|x|<surround|<vspace*|0.6fn>||<font-magnify|0.8|<doc-author-block|<style-with|src-compact|none|||<with|font-shape|italic|<email-text><localize|:>
  ><with|font-family|tt|<arg|x>>>>>>>>

  <\active*>
    <\src-comment>
      Capitoli.
    </src-comment>
  </active*>

  <assign|sectional-sep|<macro|.<space|2spc>>>

  <assign|sectional-post-sep|<macro|<space|2spc>>>

  <assign|chapter-title|<macro|name|<style-with|src-compact|none|<new-dpage*><new-line><style-with|src-compact|none|<sectional-centered-bold|<vspace*|2fn><with|font-shape|small-caps|<really-large|<arg|name>>><vspace|3fn>>>>>>

  <assign|chapter-long-title|<macro|first-title|second-title|<style-with|src-compact|none|<chapter-title|<style-with|src-compact|none|<very-huge|<arg|first-title>><right-flush><vspace|1.5fn><new-line><left-flush><arg|second-title>>>>>>

  <assign|chapter-numbered-title|<macro|title|<style-with|src-compact|none|<chapter-long-title|<chapter-text>
  <the-chapter>|<arg|title>>>>>

  <assign|appendix-numbered-title|<macro|title|<style-with|src-compact|none|<chapter-long-title|<appendix-text>
  <the-appendix>|<arg|title>>>>>

  <\active*>
    <\src-comment>
      Sezioni, Sottosezioni, Sottosottosezioni
    </src-comment>
  </active*>

  <assign|section-title|<macro|name|<style-with|src-compact|none|<sectional-centered-bold|<vspace*|2fn><with|font-shape|small-caps|<larger|<arg|name>>><vspace|1fn>>>>>

  <assign|subsection-title|<macro|name|<style-with|src-compact|none|<sectional-normal-bold|<vspace*|1.5fn><large|<arg|name>><vspace|0.5fn>>>>>

  <assign|subsubsection-title|<macro|name|<style-with|src-compact|none|<sectional-normal-bold|<vspace*|1fn><arg|name><vspace|0.5fn>>>>>
</body>

<\initial>
  <\collection>
    <associate|preamble|true>
  </collection>
</initial>