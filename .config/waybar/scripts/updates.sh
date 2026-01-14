#!/usr/bin/env bash
set -euo pipefail

repo_count="$(checkupdates 2>/dev/null | wc -l || true)"
aur_count="$(yay -Qua 2>/dev/null | wc -l || true)"
total=$((repo_count + aur_count))

repo_list="$(checkupdates 2>/dev/null | head -n 15 | sed 's/\t/  /g' || true)"
aur_list="$(yay -Qua 2>/dev/null | head -n 15 || true)"

tooltip="<b>Repo:</b> ${repo_count}\n${repo_list}\n\n<b>AUR:</b> ${aur_count}\n${aur_list}"
# Si pas d'updates, évite un tooltip vide
[ "$total" -eq 0 ] && tooltip="Aucune mise à jour."

if [ "$total" -eq 0 ]; then
	echo "{\"text\":\" 0\",\"tooltip\":\"$tooltip\",\"class\":\"updated\"}"
else
	echo "{\"text\":\" $total\",\"tooltip\":\"$tooltip\",\"class\":\"pending\"}"
fi
