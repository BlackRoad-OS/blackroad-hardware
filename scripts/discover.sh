#!/bin/bash
# discover.sh — Ping all registered BlackRoad devices and report status
# Usage: ./scripts/discover.sh

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  BlackRoad Hardware Fleet — Network Discovery${NC}"
echo -e "${CYAN}  $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

ONLINE=0
OFFLINE=0
TOTAL=0

check_host() {
    local name="$1"
    local ip="$2"
    local role="$3"
    TOTAL=$((TOTAL + 1))

    if ping -c 1 -W 2 "$ip" > /dev/null 2>&1; then
        echo -e "  ${GREEN}●${NC} %-14s %-18s %s" "$name" "$ip" "$role"
        ONLINE=$((ONLINE + 1))
    else
        echo -e "  ${RED}○${NC} %-14s %-18s %s" "$name" "$ip" "$role"
        OFFLINE=$((OFFLINE + 1))
    fi
}

echo -e "${CYAN}LAN Devices (192.168.4.0/24)${NC}"
echo ""
check_host "meridian"    "192.168.4.1"   "Router"
check_host "ember"       "192.168.4.22"  "IoT"
check_host "pandora"     "192.168.4.26"  "TV"
check_host "athena"      "192.168.4.27"  "Mobile"
check_host "alexandria"  "192.168.4.28"  "Command Center"
check_host "calliope"    "192.168.4.33"  "Streaming"
check_host "octavia"     "192.168.4.38"  "Primary Compute"
check_host "wraith"      "192.168.4.44"  "Unknown"
check_host "vesper"      "192.168.4.45"  "Unknown"
check_host "alice"       "192.168.4.49"  "Worker"
check_host "lucidia"     "192.168.4.81"  "AI Inference"
check_host "aria"        "192.168.4.82"  "Harmony"
check_host "phantom"     "192.168.4.88"  "Mobile"
check_host "cecilia"     "192.168.4.89"  "Primary AI Agent"
check_host "cortana"     "192.168.4.90"  "Console"
check_host "specter"     "192.168.4.92"  "Mobile"

echo ""
echo -e "${CYAN}Cloud Nodes${NC}"
echo ""
check_host "anastasia"   "174.138.44.45" "Edge Compute (DO)"
check_host "gematria"    "159.65.43.12"  "Cloud Oracle (DO)"

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Total: ${TOTAL}  ${GREEN}Online: ${ONLINE}${NC}  ${RED}Offline: ${OFFLINE}${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
