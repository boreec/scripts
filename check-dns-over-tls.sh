#!/bin/sh

set -eu

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BOLD}Checking DNS over TLS (DoT) Status...${NC}\n"

# 1. Check for the +DNSOverTLS flag in resolvectl
echo -e "${BOLD}1. Protocol Check:${NC}"
if resolvectl status | grep -q "+DNSOverTLS"; then
    echo -e "${GREEN}[OK]${NC} DNSOverTLS protocol is active (+)."
    DOT_ACTIVE=true
else
    echo -e "${RED}[FAIL]${NC} DNSOverTLS protocol is NOT active."
    DOT_ACTIVE=false
fi

# 2. Connection Test (The "Smoking Gun")
echo -e "\n${BOLD}2. Port 853 Traffic Check:${NC}"
# Trigger a DNS lookup to force a connection
resolvectl query mullvad.net > /dev/null 2>&1
if ss -ntp | grep -q ":853"; then
    echo -e "${GREEN}[PASS]${NC} Verified: Data is currently encrypted via Port 853."
    CONN_PASS=true
else
    echo -e "${RED}[FAIL]${NC} No encrypted traffic detected on Port 853."
    CONN_PASS=false
fi

# 3. Final Verdict
echo -e "\n${BOLD}--- Final Verdict ---${NC}"
if [ "$DOT_ACTIVE" = true ] && [ "$CONN_PASS" = true ]; then
    echo -e "${GREEN}SUCCESS:${NC} Arch Linux system is fully secured with DoT."
else
    echo -e "${RED}WARNING:${NC} Configuration mismatch detected. Check /etc/systemd/resolved.conf."
fi
