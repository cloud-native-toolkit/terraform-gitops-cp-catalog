#!/usr/bin/env bash

NAMESPACE="${1}"
NAME="${2:-ibm-entitlement-key}"
OUTPUT_DIR="${3:-.tmp/secrets}"
USERNAME="cp"
SERVER="cp.icr.io"

if [[ -z "${ENTITLEMENT_KEY}" ]]; then
  echo "ENTITLEMENT_KEY not set"
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"

echo "Creating pull secret with entitlement key: ${NAMESPACE}/${NAME}"
oc create secret docker-registry "${NAME}" \
  --docker-username="${USERNAME}" \
  --docker-password="${ENTITLEMENT_KEY}" \
  --docker-server="${SERVER}" \
  --namespace="${NAMESPACE}" \
  --dry-run=client \
  -o yaml > "${OUTPUT_DIR}/${NAME}.yaml"
