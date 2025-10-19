#!/bin/bash
# netreset.sh — completely reset network configuration in a Slackware container

echo "[*] Resetting container network configuration..."

# --- 1. Stop routing daemons if present ---
echo "[*] Stopping any routing daemons..."
for daemon in zebra ospfd ripd bgpd isisd; do
  if pgrep "$daemon" >/dev/null 2>&1; then
    echo " - Killing $daemon"
    killall "$daemon" 2>/dev/null
  fi
done

# --- 2. Flush and reset interfaces ---
echo "[*] Flushing interfaces..."
for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v lo); do
  echo " - Resetting $iface"
  ip addr flush dev "$iface"
  ip link set "$iface" down
  ip link set "$iface" up
done

# --- 3. Clear all routing tables ---
echo "[*] Clearing routing table..."
ip route flush table main

# --- 4. Reset hostname ---
echo "[*] Resetting hostname to default..."
hostname slackware
echo "slackware" > /etc/HOSTNAME 2>/dev/null

# --- 5. Reset DNS resolver ---
echo "[*] Resetting resolver configuration..."
cat <<EOF > /etc/resolv.conf
# Default resolver reset by netreset.sh
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF

# --- 6. Reset OSPF configuration (Quagga or FRRouting) ---
# These files depend on your setup — adjust paths if needed.
echo "[*] Resetting OSPF configuration..."
if [ -f /etc/quagga/ospfd.conf ]; then
  cat <<EOF > /etc/quagga/ospfd.conf
! Default OSPF configuration reset by netreset.sh
hostname ospfd
password zebra
log file /var/log/quagga/ospfd.log
EOF
  echo " - Quagga OSPF configuration reset."
elif [ -f /etc/frr/ospfd.conf ]; then
  cat <<EOF > /etc/frr/ospfd.conf
! Default OSPF configuration reset by netreset.sh
hostname ospfd
password zebra
log file /var/log/frr/ospfd.log
EOF
  echo " - FRRouting OSPF configuration reset."
else
  echo " - No OSPF configuration file found, skipping."
fi

# --- 7. Optional: clear Quagga/FRR state files ---
if [ -d /var/run/quagga ]; then
  rm -f /var/run/quagga/* 2>/dev/null
elif [ -d /var/run/frr ]; then
  rm -f /var/run/frr/* 2>/dev/null
fi

# --- 8. Done ---
echo "[*] Network configuration fully reset."
echo "[*] Interfaces are up but unconfigured. You can now reassign IPs manually."
