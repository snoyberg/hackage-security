#!/usr/bin/env bash

set -eux

rm -rf tmp

ghc --version
cabal --version

cabal sandbox init || true
cabal install ./hackage-security

cabal exec -- ghc \
  -hide-all-packages \
  -package hackage-security \
  -package base \
  -package directory \
  -Wall -Werror \
  issue-187.hs

./issue-187
./issue-187
