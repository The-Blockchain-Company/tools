#!/bin/sh
BASE="https://hydra.quantumone.network/job/Bcc/bcc-node/bcc-deployment/latest-finished/download/1"
for net in mainnet testnet; do
    for file in config cole-genesis sophie-genesis aurum-genesis topology db-sync-config; do
        curl -LO "${BASE}/${net}-${file}.json"
    done
done
curl -LO "${BASE}/rest-config.json"
curl -LO "https://raw.githubusercontent.com/the-blockchain-company/bcc-node/master/bcc-submit-api/config/tx-submit-mainnet-config.yaml"
