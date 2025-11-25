#pica2bibtex.sh
#!/bin/bash -e


green="`tput setaf 2`"
red="`tput setaf 1`"
sgr0="`tput sgr0`"
cyan="`tput setaf 6`"

# Git-Synchronisation (https://github.com/musikforschung)
REPOS=(
"$HOME/rilm/pica2bibtex/"
"$HOME/lib/Catmandu/Exporter/"
)

echo "Prüfe auf Aktualisierungen..."

for repo_path in "${REPOS[@]}"; do
   if [ ! -d "$repo_path" ]; then
      echo "Fehler: Verzeichnis nicht gefunden: $repo_path!"
	     continue
   fi

   cd "$repo_path" || { echo  "Fehler: Konnte nicht in $repo_path wechseln!"; continue; }
   git fetch &> /dev/null
   if [ $? -ne 0 ]; then
      echo "Fehler beim Abrufen der Remote_Daten."
      continue
   fi
   STATUS=$(git status)
   if [[ $STATUS =~ "Ihr Branch ist auf demselben Stand wie" ]]; then
      echo "$repo_path ist aktuell"
   elif [[ $STATUS =~ "git pull" ]]; then
      echo "Aktualisierungen für $repo_path gefunden"
      git config pull.rebase false && git pull &> /dev/null
      echo "$repo_path wurde aktualisiert"
   else
      echo "Bitte Aktualisierungen prüfen."
      echo "$STATUS"
   fi
done
echo "------------------------------------------------------"
echo "Synchronisierung abgeschlossen.
"



##Abruf und Transformation der RILM-Daten
## Abfrage des aktuellen RILM-Stempels "JJJJ-MM-TT"
read -p "${cyan}			Bitte den aktuellen RILM-Stempel in der Form JJJJ-MM-TT eingeben: ${sgr0}" Date
while [[ ! "$Date" =~ ^20[23][0-9]-(0[369]|12)-(0?[1-9]|[12][0-9]|3[01])$ ]] ; do
  echo "${red}Ungültige Eingabe. Der Stempel besteht aus einer Datumsangabe in der Form JJJJ-MM-TT. Erlaubte Werte für MM = 03,06,09,12.${sgr0}"
  read -p "${cyan}			Bitte den aktuellen RILM-Stempel eingeben: ${sgr0}" Date
done
echo "
Transformation der BMS-Daten nach BibTeX gestartet."

cd $HOME/rilm/pica2bibtex/

# Löscht überflüssige Einträge im PICA-Abzug. 
sed -i '/^nohup:/d' $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp &&

# Alte Dateien Löschen oder Verschieben.
if [ -f $HOME/rilm/pica2bibtex/dmpbms_*.btx ]; then
   mv $HOME/rilm/pica2bibtex/dmpbms_*.btx $HOME/rilm/pica2bibtex/ablage/
fi &&

# PICA-Datei auf eventuell fehlende Formschlagwörter (Festschrift/Konferenzschrift) prüfen
catmandu convert PICA --type plain to CSV --fields Festschrift,Konferenzschrift,PPN --fix $HOME/rilm/pica2bibtex/fix/formschlagwort_bms.fix < $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp > $HOME/rilm/pica2bibtex/formschlagwort_bms.csv &&

if [ -f $HOME/rilm/formschlagwort_bms.csv ]; then
   echo "${cyan}			Bitte die Datei ${green}formschlagwort_bms.csv${cyan} prüfen und bei Bedarf in der Datei ${green}dmpbms_${Date}.pp${cyan} Formschlagwörter ergänzen!!!${sgr0}"
fi

read -p "${cyan}			Mit \"${green}y${cyan}\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: ${sgr0}" Bestaetigung
while [[ ! "$Bestaetigung" == y ]]; do
  echo "${red}			Warte auf Bestätigung${sgr0}"
  read -p "			Mit \"${green}y${cyan}\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: " Bestaetigung
done  

echo "Transformation der BMS-Daten wird fortgesetzt."

# Lösche formschalgwort_bms.csv
if [ -f $HOME/rilm/pica2bibtex/formschlagwort_bms.csv ]; then
   rm $HOME/rilm/pica2bibtex/formschlagwort_bms.csv
fi &&

# CSV von allen HAs ihrer Materialart und ihren PPNs erstellen.
catmandu convert PICA --type plain to CSV --fix $HOME/rilm/pica2bibtex/fix/type_ha.fix --fields ppn,type < $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp > $HOME/rilm/pica2bibtex/data/type_ha.csv &&
# CSV_Datei der HAs ihrer PPN und ihrer zugehörigen Materialart erstellen. Wird für die Bestimmung des types der Aufsätze benötigt.
catmandu convert PICA --type plain to CSV --fix $HOME/rilm/pica2bibtex/fix/type_as.fix --fields ppn,type < $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp > $HOME/rilm/pica2bibtex/data/type_as.csv &&
# CSV_Datei der HAs ihrer PPN und ihrer zugehörigen Materialart erstellen. Wird für die Bestimmung des types der Rezensionen benötigt.
catmandu convert PICA --type plain to CSV --fix $HOME/rilm/pica2bibtex/fix/type_re.fix --fields ppn,type < $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp > $HOME/rilm/pica2bibtex/data/type_re.csv &&
# Ländercodes der HAs für die Übergabe an die Aufsätze einsammeln
catmandu convert PICA --type plain to CSV --fix $HOME/rilm/pica2bibtex/fix/countrycode.fix < $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp > $HOME/rilm/pica2bibtex/data/countrycodelist.csv &&

# Transformation ausführen.
catmandu -I $HOME/lib convert PICA --type plain to BibTeX --fix $HOME/rilm/pica2bibtex/fix/pica2bibtex.fix --fix $HOME/rilm/pica2bibtex/fix/replace.fix < $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp 1> $HOME/rilm/pica2bibtex/dmpbms_${Date}.btx 2>/dev/null &&

# BTX-Datei auf mögliche Fehler prüfen
catmandu convert BibTeX to CSV --fields Type,Country,Note,Pages,Number,Volume,Year,Abstract,Abstractor,Series,Crossref,Ausschluss,PPN --fix $HOME/rilm/pica2bibtex/fix/fehlermeldung_bms.fix < $HOME/rilm/pica2bibtex/dmpbms_${Date}.btx > $HOME/rilm/pica2bibtex/fehlermeldung_bms_${Date}.csv &&

if [ -f $HOME/rilm/pica2bibtex/fehlermeldung_bms_${Date}.csv ]; then
   echo "
Der BMS-Abzug im Format Bibtex für RILM befindet sich in der Datei ${green}dmpbms_${Date}.btx${sgr0}.
   
			${cyan}Bitte die Datei ${green}fehlermeldung_bms_${Date}.csv${sgr0} ${cyan}prüfen und bei Bedarf die Daten in dmpbms_${Date}.btx anpassen!!!${sgr0}
   "
   read -p "${cyan}			Mit \"${green}y${cyan}\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: ${sgr0}" Bestaetigung
   while [[ ! "$Bestaetigung" == y ]]; do
     echo "${red}			Warte auf Bestätigung${sgr0}"
     read -p "			Mit \"${green}y${cyan}\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: " Bestaetigung
   done 
   echo "
   ------------------------------------------------------"
   echo "Transformation der BMS-Daten erfolgreich abgeschlossen.
   "
   echo "Statistik der transformierten BMS-Daten:
   "
   sleep 3s
   # Erstelle Export-Statistik
   catmandu convert BibTeX to Stat --fix $HOME/rilm/pica2bibtex/fix/stat.fix --fields Aufsätze_Monografien,Rezensionen,Abstracts < $HOME/rilm/pica2bibtex/dmpbms_${Date}.btx 2>/dev/null | tee $HOME/rilm/pica2bibtex/statistics/rilm_export_statistik_${Date}.csv
   mv $HOME/rilm/pica2bibtex/fehlermeldung_bms_${Date}.csv $HOME/rilm/pica2bibtex/fehlermeldungen/
   rm $HOME/rilm/pica2bibtex/dmpbms_${Date}.pp
fi
