#!/usr/bin/env bash
# PreToolUse hook: hard-block `git push` when the Release build fails.
# Exit 0 to allow, exit 2 to block (before permission rules apply).

set -u

# mise manages dotnet (see mise.toml); shims aren't on PATH in non-interactive shells.
export PATH="$HOME/.local/share/mise/shims:$PATH"

input="$(cat)"

tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null || true)"
[[ "$tool_name" == "Bash" ]] || exit 0

command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"

# Strip leading whitespace and match `git push`.
trimmed="${command#"${command%%[![:space:]]*}"}"
case "$trimmed" in
  "git push"|"git push "*) ;;
  *) exit 0 ;;
esac

echo "[pre-push-build] running dotnet build -c Release before push..." >&2

log="${TMPDIR:-/tmp}/tazuo-prepush-build.log"

if dotnet build -c Release --no-restore --verbosity quiet >"$log" 2>&1; then
  echo "[pre-push-build] build OK — allowing push." >&2
  exit 0
fi

echo "[pre-push-build] BUILD FAILED — blocking push. Last 40 lines:" >&2
tail -n 40 "$log" >&2
echo "[pre-push-build] Full log: $log" >&2
exit 2
