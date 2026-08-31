#!/bin/bash
# Parse gate for Round M3 (four files) plus the M1/M2 prior-work files still dirty in the tree.
# Run after ANY edit — the orchestrator's own edits landed after Grok's own check.
cd /mnt/c/stardust-3-space-port/server/MMOCoreORB/bin/scripts || exit 1
fail=0
for f in $(cd /mnt/c/stardust-3-space-port/server && git status --porcelain | awk '{print $NF}' | grep '\.lua$' | sed 's#^MMOCoreORB/bin/scripts/##'); do
  if /usr/bin/luac5.3 -p "$f" 2>/tmp/luaerr; then
    echo "OK   $f"
  else
    echo "FAIL $f"
    cat /tmp/luaerr
    fail=1
  fi
done
echo "---"
echo "exit=$fail"
