<details>

<summary>us English version (click here)</summary>

# pica2bibtex

Transformation of bibliographic data from PICA Plain format to BibTeX format for RILM

The German editorial office of the Répertoire International de Littérature Musicale (RILM) is located at the Staatliches Institut für Musikforschung (SIM). As such, the SIM transmits all entries of the [Bibliographie des Musikschrifttums](https://www.musikbibliographie.de/) (BMS online) published in Germany to the central editorial office of [RILM Abstracts of Music Literature](https://www.rilm.org/abstracts/) on a quarterly basis. The bibliographic data of the BMS online are in PICAplus format and has to be transformed into BibTeX format for further processing at the RILM central editorial office. For this purpose, the SIM uses the command line tool Catmandu. Further information on Catmandu is available here https://librecat.org/Catmandu. 

# Files description

[dictionary](https://github.com/musikforschung/pica2bibtex/blob/main/dictionary)

* [note.csv](https://github.com/musikforschung/pica2bibtex/blob/main/dictionary/note.csv) contains illustration details of the PICA field 034M and the corresponding RILM tag.

[fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix)

* [countrycode.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/countrycode.fix) selects the country codes and IDs of all journals and collections. The loader codes are written to a csv file and transferred to the essays contained in the journals or collections in a later step.
* [fehlermeldung_bms.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/fehlermeldung_bms.fix) validates the transformed BibTeX data.
* [formschlagwort_bms.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/formschlagwort_bms.fix) checks PICA field 013D for missing information.
* [pica2bibtex.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/picafix.fix) contains fixes to transform the necessary PICA+ data into the BibTeX format.
* [replace.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/replace.fix) is needed for cleaning up the transformed data.
* [sru_map.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/sru_map.fix) is needed for adding the country of publication to the articles of journals and collections.
* [stat.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/stat.fix) creates statistics of the transformed data.
* [type_as.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/type_as.fix) is needed to determine the RILM document type of articles in journals and collections.
* [type_ha.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/type_ha.fix) is needed to determine the RILM document type of books, journals, electronic ressources, weblogs, theses ... .
* [type_re.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/type_re.fix) is needed to determine the RILM document type of reviews.

[shell](https://github.com/musikforschung/pica2bibtex/blob/main/shell)

* [bms.sh](https://github.com/musikforschung/pica2bibtex/blob/main/shell/bms.sh) Bash script to execute all steps of the transformation from PICA to BibTex for RILM.

# Required Catmandu modules

* [Catmandu::PICA](https://metacpan.org/dist/Catmandu-PICA)
* [Catmandu::BibTeX](https://metacpan.org/pod/Catmandu::BibTeX)
* [BibTeX.pm](https://github.com/musikforschung/Exporter/blob/main/BibTeX.pm)

# Authors

René Wallor, wallor at sim.spk-berlin.de

# Contributors

* [pica2bibtex.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/pica2bibtex.fix):
Johann Rolschewski, jorol at cpan.org

# License an copyright

Copyright (c) 2022 Stiftung Preußischer Kulturbesitz - Staatliches Institut für Musikforschung

This program is free software; you can redistribute it and/or modify it under the terms of either: the GNU General Public License as published by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information. 


</details>

---

<details open>

<summary>DE Deutsche Version</summary>


# Catmandu_PICAtoBibTex

Transformation bibliographischer Daten aus dem Format PICA Plain in das Format BibTeX für RILM

Am Staatlichen Institut für Musikforschung (SIM) befindet sich die deutsche Redaktion des Répertoire International de Littérature Musicale (RILM). Als diese übermittelt das SIM vierteljährlich alle in Deutschland erscheinenden Einträge der [Bibliographie des Musikschrifttums](https://www.musikbibliographie.de/) (BMS online) an die Zentralredaktion von [RILM Abstracts of Music Literature](https://www.rilm.org/abstracts/). Die bibliographischen Daten aus BMS online liegen im PICAplus-Format vor und müssen für die Weiterverarbeitung in der RILM-Zentralredaktion in das Format BibTeX transformiert werden. Dafür nutzt das SIM das Kommandozeilentool Catmandu. Weitere Informationen zu Catmandu gibt hier https://librecat.org/Catmandu. 

# Beschreibung der Dateien

[dictionary](https://github.com/musikforschung/pica2bibtex/blob/main/dictionary)

* [note.csv](https://github.com/musikforschung/pica2bibtex/blob/main/dictionary/note.csv) enthält Angaben zu Illustrationen us dem Feld 034M und die jeweils entsprechenden RILM-tags.

[fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix)

* [countrycode.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/countrycode.fix) ermittelt die Ländercodes von Zeitschriften und Sammlungen zur Weitergabe an die enthaltenen Aufsätze.
* [fehlermeldung_bms.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/fehlermeldung_bms.fix) validiert die transformierten BibTeX-Daten.
* [formschlagwort_bms.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/formschlagwort_bms.fix) überpfüft das Pica-Feld 013D auf fehlende Formschlagwörter.
* [pica2bibtex.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/picafix.fix) fixes zur Transformation der PICA-Plain Daten nach BibTeX.
* [replace.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/replace.fix) wird für die Bereinigung der transformierten BibTeX-Daten benötigt.
* [sru_map.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/sru_map.fix) Ermittlung und Ergänzung von Ländercodes in Aufsätzen mittels SRU.
* [stat.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/stat.fix) erstellt Statistiken der transformierten Daten.
* [type_as.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/type_as.fix) wird benötigt, um den RILM-Dokumenttyp von Artikeln in Zeitschriften und Sammlungen zu bestimmen.
* [type_ha.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/type_ha.fix) wird benötigt, um den RILM-Dokumenttyp von Büchern, Zeitschriften, elektronischen Ressourcen, Weblogs, Dissertationen usw. zu bestimmen.
* [type_re.fix](https://github.com/musikforschung/pica2bibtex/blob/main/fix/type_re.fix) bestimmt den RILM-Dokumenttyp von Rezensionen.

[shell](https://github.com/musikforschung/pica2bibtex/blob/main/shell)

* [bms.sh](https://github.com/musikforschung/pica2bibtex/blob/main/shell/bms.sh) Bash-Skript zur Ausführung aller Schritte der Transformation von PICA nach BibTex für RILM.

#  benötigte Catmandu-Module

* [Catmandu::PICA](https://metacpan.org/dist/Catmandu-PICA)
* [Catmandu::BibTeX](https://metacpan.org/pod/Catmandu::BibTeX)
* [BibTeX.pm](https://github.com/musikforschung/Exporter/blob/main/BibTeX.pm)

# Autoren

René Wallor, wallor at sim.spk-berlin.de

# Mitwirkende

* [picafix.fix](https://github.com/musikforschung/pica2bibtex/blob/main/picafix.fix):
Johann Rolschewski, jorol at cpan.org

# Lizenz und Copyright

Copyright (c) 2022 Stiftung Preußischer Kulturbesitz - Staatliches Institut für Musikforschung

This program is free software; you can redistribute it and/or modify it under the terms of either: the GNU General Public License as published by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

</details>

---
