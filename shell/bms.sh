#!/bin/bash -e
#Shell-Skript für die Transformation von BMS PICA-Daten nach BibTeX für RILM
#$ bash bms.sh
# https://wiki.ubuntuusers.de/Shell/Bash-Skripting-Guide_f%C3%BCr_Anf%C3%A4nger/

## Abfrage des aktuellen RILM-Stempels "JJJJ-MM-TT"
read -p "Bitte den aktuellen Stempel der RILM-Daten in der Form JJJJ-MM-TT eingeben: " Date
while [[ ! "$Date" =~ ^20[23][0-9]-(0[369]|12)-(0?[1-9]|[12][0-9]|3[01])$ ]] ; do
  echo "Ungültige Eingabe. Der Stempel besteht aus einer Datumsangabe in der Form JJJJ-MM-TT. Erlaubte Werte für MM= 03,06,09,12."
  read -p "Bitte den aktuellen Stempel der RILM-Daten eingeben: " Date
done && echo "Stempel erfolgreich eingegeben.
Transformation der Daten nach BibTeX wird ausgeführt."

# Löscht überflüssige Einträge im PICA-Abzug. 
sed -i '/^nohup:/d' dmpbms_${Date}.pp

# Alte Dateien Löschen oder Verschieben.
if [ -f dmpbms*.btx ]; then
   rm dmpbms*.btx
fi

if [ -f formschlagwort.csv ]; then
   rm formschlagwort.csv
fi

if [ -f fehlermeldung*.csv ]; then
   mv fehlermeldung*.csv ./fehlermeldungen_ablage/
fi

# PICA-Datei auf eventuell fehlende Formschlagwörter (Festschrift/Konferenzschrift) prüfen
catmandu convert PICA --type plain to CSV --fields Festschrift,Konferenzschrift,PPN --fix ./fix/formschlagwort.fix < dmpbms_${Date}.pp > formschlagwort.csv

if [ -f formschlagwort.csv ]; then
   echo "Bitte die Datei \"formschlagwort.csv\" prüfen und in den PICA-Daten bei Bedarf Formschlagwörter ergänzen!!!"
fi

read -p "Mit \"y\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: " Bestaetigung
while [[ ! "$Bestaetigung" == y ]]; do
  echo "Warte auf Bestätigung"
  read -p "Mit \"y\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: " Bestaetigung
done && echo "Transformation der Daten nach BibTeX wird fortgeführt."

# CSV von allen HAs ihrer Materialart und ihren PPNs erstellen.
catmandu convert PICA --type plain to CSV --fix ./fix/type_ha.fix --fields ppn,type < dmpbms_${Date}.pp > ./dictionary/type_ha.csv
# CSV_Datei der HAs ihrer PPN und ihrer zugehörigen Materialart erstellen. Wird für die Bestimmung des types der Aufsätze benötigt.
catmandu convert PICA --type plain to CSV --fix ./fix/type_as.fix --fields ppn,type < dmpbms_${Date}.pp > ./dictionary/type_as.csv
# CSV_Datei der HAs ihrer PPN und ihrer zugehörigen Materialart erstellen. Wird für die Bestimmung des types der Rezensionen benötigt.
catmandu convert PICA --type plain to CSV --fix ./fix/type_re.fix --fields ppn,type < dmpbms_${Date}.pp > ./dictionary/type_re.csv
# Ländercodes der HAs für die Übergabe an die Aufsätze einsammeln
catmandu convert PICA --type plain to CSV --fix ./fix/countrycode.fix < dmpbms_${Date}.pp > ./dictionary/countrycodelist.csv

# Transformation ausführen.
catmandu -I /home_ext/PK/siwallor/lib convert PICA --type plain to BibTeX --fix ./fix/pica2bibtex.fix --fix ./fix/replace.fix < dmpbms_${Date}.pp 1> dmpbms_${Date}.btx 2>/dev/null

# BTX-Datei auf mögliche Fehler prüfen
catmandu convert BibTeX to CSV --fields Type,Country,Note,Pages,Number,Volume,Year,Abstract,Abstractor,Series,Crossref,Ausschluss,PPN --fix ./fix/fehlermeldung.fix < dmpbms_${Date}.btx > fehlermeldung.csv
if [ -f fehlermeldung.csv ]; then
   echo "
   Transformation abgeschlossen.
   Der Abzug im Format Bibtex für RILM befindet sich in der Datei dmpbms_${Date}.btx.
   
   Bitte die Datei fehlermeldung.csv prüfen!!!
   "
else
   echo "
   Transformation abgeschlossen.
   Der Abzug im Format Bibtex für RILM befindet sich in der Datei dmpbms_${Date}.btx.
" 
fi

echo "Statistik der transformierten Daten:"
# Erstelle Export-Statistik
catmandu convert BibTeX to Stat --fix ./fix/stat.fix --fields Aufsätze_Monografien,Rezensionen,Abstracts < dmpbms_${Date}.btx 2>/dev/null | tee ./statistics/rilm_export_statistik_${Date}.csv 

##Abruf und Transformation der OENB-Daten
read -p "Daten der OENB per SRU abrufen und transformieren. Mit \"y\" bestätigen: " Bestaetigung
while [[ ! "$Bestaetigung" == y ]]; do
  echo "Warte auf Bestätigung"
  read -p "Mit \"y\" bestätigen, wenn die Daten der OENB bearbeitet werden können: " Bestaetigung
done && echo "Abruf der Daten der OENB und Transformation nach BibTeX wird ausgeführt."


tmpDate=${Date:0:7}
tmpDate_I=${tmpDate//-/}

if [[ "${tmpDate_I:5:1}" == "3" ]]; then
   TEIL1="${tmpDate_I:0:3}"
   Vierte_Stelle=$(( ${tmpDate_I:3:1} - 1))
   TEIL3="${tmpDate_I:4:1}"
   Sechste_Stelle="4"
   DateOENB="${TEIL1}${Vierte_Stelle}${TEIL3}${Sechste_Stelle}"
elif [[ "${tmpDate_I:5:1}" == "6" ]]; then
   DateOENB=$(( ${tmpDate_I} -5))
elif [[ "${tmpDate_I:5:1}" == "9" ]]; then
   DateOENB=$(( ${tmpDate_I} -7))
elif [[ "${tmpDate_I:4:2}" == "12" ]]; then
   DateOENB=$(( ${tmpDate_I} -9))
else
   echo "Der Zeitstempel der OENB-Daten konnte nicht ermittelt werden"
   kill -15 -1
fi
echo "Zeitstempel der OENB-Daten:" ${DateOENB}

