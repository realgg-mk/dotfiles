#!/bin/bash

# IP publique (timeout pour ne pas bloquer Waybar)
RAW_IP="$(curl -s --max-time 2 https://api.ipify.org || true)"
[ -n "$RAW_IP" ] || RAW_IP="N/A"

# IP masquée (garde 2 premiers blocs)
MASKED_IP="$(echo "$RAW_IP" | awk -F. '{print $1"."$2".*.*"}')"

# Statut ExpressVPN
STATUS="$(expressvpnctl status 2>/dev/null || true)"

# IMPORTANT: tester "not connected" avant "connected"
if echo "$STATUS" | grep -Eqi "not[[:space:]]+connected|disconnected"; then
  ICON="" # cadenas ouvert
  CLASS="disconnected"
  TEXT="$ICON $MASKED_IP"
  TOOLTIP="ExpressVPN: Déconnecté\nIP: $RAW_IP"
else
  ICON="" # cadenas fermé
  CLASS="connected"
  TEXT="$ICON $MASKED_IP"
  TOOLTIP="ExpressVPN: Connecté\nIP: $RAW_IP"
fi
DETAILS="$(echo "$STATUS" | grep -E 'Protocol in use:|Network Lock:|Split Tunnel:' | tr '\n' '|')"
DETAILS="${DETAILS//|/$'\n'}"
TOOLTIP="$TOOLTIP\n\n$DETAILS"

# Sortie JSON propre (recommandé)
jq -nc --arg text "$TEXT" --arg tooltip "$TOOLTIP" --arg class "$CLASS" \
  '{text:$text, tooltip:$tooltip, class:$class}'
