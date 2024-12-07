#!/bin/bash

export MINTER_ADDRESS=0000000000000000000000029371743dc633f87a
export ADMIN_ADDRESS=0000000000000000000000029371743dc633f87a
export ETH_FROM=0x01d0e3bdb84ae634d39a6fdD520B64FE9D85602c
forge script script/Deploy.s.sol:Deploy \
  --rpc-url https://testnet.evm.nodes.onflow.org \
  --slow \
  -vvv \
  --verify \
  --verifier blockscout \
  --verifier-url https://evm-testnet.flowscan.io/api \
  --legacy \
  --broadcast \
  --via-ir \
  -i 1
