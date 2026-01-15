#!/bin/bash

# On calcule les updates
updates_arch=$(checkupdates 2>/dev/null | wc -l)
updates_aur=$(yay -Qum 2>/dev/null | wc -l)
updates=$((updates_arch + updates_aur))

# On définit une classe CSS différente si c'est à jour ou non
if [ "$updates" -gt 0 ]; then
	class="pending"
else
	class="updated"
fi

# On affiche TOUJOURS le JSON
printf '{"text": "%s", "alt": "%s", "tooltip": "Mises à jour : %s", "class": "%s"}\n' "$updates" "$updates" "$updates" "$class"
