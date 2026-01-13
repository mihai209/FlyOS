#!/bin/bash

set +e

echo "FlyOS toolchain check"
echo "----------------------"
echo

check() {
  local name="$1"
  local cmd="$2"
  local ver="$3"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $name"
    "$cmd" $ver 2>/dev/null | head -n 1
  else
    echo "[MISSING] $name"
  fi
  echo
}

# --- checks ---
check "C compiler (gcc)" gcc "--version"
check "Make" make "--version"
check "NASM" nasm "-v"
check "QEMU" qemu-system-x86_64 "--version"
check "Pascal (FreePascal)" fpc "-iV"
check "Figlet" figlet "-v"

echo "Check complete."
