#!/bin/bash

# Récupère la liste des paquets
list=$(checkupdates)
# Compte le nombre de lignes
count=$(echo "$list" | wc -l)

if [ "$count" -gt 0 ]; then
  # On nettoie la liste pour le JSON (enlève les retours à la ligne)
  tooltip=$(echo "$list" | sed ':a;N;$!ba;s/\n/\\n/g')
  # On envoie le JSON à Waybar
  echo "{\"text\":\"$count\", \"tooltip\":\"$tooltip\"}"
else
  echo "{\"text\":\"0\", \"tooltip\":\"Système à jour\"}"
fi
