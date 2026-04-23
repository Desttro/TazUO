---
paths:
  - "src/ClassicUO.Client/Network/**"
---

# Network / Packet Rules

## Wire format

- UO is **big-endian**. Use `ReadUInt16BE()`, `ReadUInt32BE()`, `ReadInt16BE()`, `ReadInt32BE()`. Never mix little-endian reads on wire data.
- Outgoing builders in `OutgoingPackets.cs` write in big-endian to match.

## Safety checklist (single source of truth for `packet-handler-reviewer`)

1. **Buffer bounds** — every `Read*` call is preceded by a `p.Length` or `p.Remaining` check. Variable-length fields validated against the declared length.
2. **Malformed-packet handling** — handler does not crash on zero-length or truncated payload. Return early; never throw into the dispatch loop.
3. **Endian-ness** — big-endian reads only (see above).
4. **State correctness** — check `World.InGame` / player state before mutating game state where required.
5. **Outgoing symmetry** — opcode and length in `OutgoingPackets.cs` match the server's expected framing. Fixed-length packets write exactly N bytes; variable-length packets update the length prefix.
6. **No allocations on the hot path** — dispatch runs per-message on the network thread. No `new byte[]`, LINQ, or string concat. Reuse `StackDataReader` / pooled buffers.
7. **Opcode uniqueness** — new opcodes do not collide with existing entries in the handler table.

## Threading

The network thread delivers packets asynchronously. If a handler must mutate game state (entities, world), marshal to the main thread using the existing mechanism (grep current code for how other handlers handle this). Never touch `UIManager` or call gump methods from the network thread.

## Encryption

Handled by the network stack before dispatch. Do not re-implement or bypass it in handlers.

## After changes

Dispatch the `packet-handler-reviewer` agent.
