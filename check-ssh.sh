#!/bin/sh

# Define colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 1. Determine the correct service name
SERVICE_NAME="none"
for s in sshd ssh; do
    if systemctl list-unit-files | grep -q "^$s.service"; then
        SERVICE_NAME=$s
        break
    fi
done

# 2. SSH Service Status
echo "1. Service Status:"
if [ "$SERVICE_NAME" != "none" ] && systemctl is-active --quiet "$SERVICE_NAME"; then
    echo -e "   ${RED}✗ SSH service ($SERVICE_NAME) is RUNNING${NC}"
else
    echo -e "   ${GREEN}✓ SSH service is NOT running${NC}"
fi

# 3. Port Listening Check (Port 22 or others)
echo -e "\n2. Network Listening Status:"
SSH_LISTENING=$(ss -tlnp 2>/dev/null | grep -E "sshd|:22")
if [ -n "$SSH_LISTENING" ]; then
    echo -e "   ${RED}✗ SSH is LISTENING${NC}"
    echo "$SSH_LISTENING" | awk '{print "     -> " $4}'
else
    echo -e "   ${GREEN}✓ No SSH listener detected${NC}"
fi

# 4. Active SSH Connections
SSH_PIDS=$(pgrep sshd)
if [ -n "$SSH_PIDS" ]; then
    # Look for users attached to those specific sshd PIDs
    ps -fp $SSH_PIDS
fi

# 5. Firewall Deep-Dive
echo -e "\n4. Firewall Rules:"
if command -v ufw >/dev/null && ufw status | grep -q "Active"; then
    echo "   [UFW Detected]"
    ufw status | grep "22" || echo "   Port 22 not found in UFW rules."
elif command -v firewall-cmd >/dev/null && systemctl is-active --quiet firewalld; then
    echo "   [Firewalld Detected]"
    firewall-cmd --list-ports | grep -q "22" && echo "   Port 22 is OPEN" || echo "   Port 22 is CLOSED"
else
    echo "   Checking raw iptables..."
    iptables -L -n | grep -E ":22|ssh" || echo "   No explicit SSH rules found in iptables."
fi
