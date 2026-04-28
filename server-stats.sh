#!/bin/bash
# This script (server-stats.sh) collects and displays basic server performance statistics.  
# It shows the total CPU usage, memory usage (used vs. free with percentage), disk usage (used vs. free with percentage),  
# and lists the top 5 processes consuming the most CPU and memory.  
# It is designed to run on any Linux server for quick health and performance monitoring.  

echo "====================================="
echo " Server Performance Statistics"
echo "====================================="

echo ""
echo "CPU Usage:"
mpstat 1 1 | awk '/Average/ {printf "Total CPU Usage: %.2f%%\n", 100-$12}'

echo ""
echo "Memory Usage:"
free -h | awk '/Mem:/ {printf "Used: %s / Total: %s (%.2f%%)\n", $3, $2, ($3/$2)*100}'

echo ""
echo "Disk Usage:"
df -h --total | awk '/total/ {printf "Used: %s / Total: %s (%.2f%%)\n", $3, $2, ($3/$2)*100}'

echo ""
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

echo ""
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6

echo ""
echo "Report generated on: $(date)"
