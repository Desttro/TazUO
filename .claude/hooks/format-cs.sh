#!/usr/bin/env bash
# PostToolUse hook: auto-format C# files after Edit/Write/MultiEdit.
# Input: Claude Code tool-event JSON on stdin.
# Exit 0 always — formatting failures must not block the tool call.

set -u

# mise manages dotnet (see mise.toml); shims aren't on PATH in non-interactive shells.
export PATH="$HOME/.local/share/mise/shims:$PATH"

input="$(cat)"

tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null || true)"
file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"

# Only act on file-editing tools.
case "$tool_name" in
  Edit|Write|MultiEdit) ;;
  *) exit 0 ;;
esac

# Only format .cs files that exist.
case "$file_path" in
  *.cs) ;;
  *) exit 0 ;;
esac

[[ -f "$file_path" ]] || exit 0

# Skip vendored / generated code.
case "$file_path" in
  */external/*|*/bin/*|*/obj/*) exit 0 ;;
esac

# Walk up to find the owning .csproj.
dir="$(dirname "$file_path")"
proj=""
while [[ "$dir" != "/" && "$dir" != "." ]]; do
  candidate="$(find "$dir" -maxdepth 1 -name '*.csproj' -print -quit 2>/dev/null)"
  if [[ -n "$candidate" ]]; then
    proj="$candidate"
    break
  fi
  dir="$(dirname "$dir")"
done

[[ -n "$proj" ]] || exit 0

dotnet format style "$proj" --include "$file_path" --verbosity quiet >/dev/null 2>&1 || true

exit 0
