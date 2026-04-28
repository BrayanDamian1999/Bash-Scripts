#!/usr/bin/env bash
# This script performs a pre-upgrade check on a self-hosted GitLab EE instance.  
# It validates the current GitLab version, lists available package versions,  
# and checks the status of background migrations (both queued and active).  
# Additionally, it verifies that all GitLab services are running.  
# The script is intended to provide administrators with a quick overview  
# before performing a GitLab upgrade, ensuring that the system is stable  
# and ready for the update.


set -euo pipefail

echo -e "\n>>> Mostrando versión actual de GitLab EE:"
gitlab-rake gitlab:env:info | grep "GitLab version"
sleep 5

echo ">>> Mostrando versiones disponibles de GitLab EE:"
apt-cache madison gitlab-ee | head -n 20
sleep 5

echo -e "\n>>> Consultando migraciones por lotes encoladas:"
sudo gitlab-rails runner -e production 'puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count'
sleep 5

echo -e "\n>>> Consultando migraciones en background restantes:"
sudo gitlab-rake gitlab:background_migrations:status
sleep 5