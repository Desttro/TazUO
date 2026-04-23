---
name: packet-handler-pattern
description: Step-by-step template for adding or modifying a UO packet handler in TazUO. Auto-loads when editing files under src/ClassicUO.Client/Network/.
paths:
  - "src/ClassicUO.Client/Network/**"
user-invocable: false
---

# Adding a Packet Handler

Safety rules and protocol invariants live in `.claude/rules/network.md` (auto-loads alongside this skill). This file is the **how**, not the **why**.

## Files

- `src/ClassicUO.Client/Network/PacketHandlers.cs` — incoming dispatch table
- `src/ClassicUO.Client/Network/OutgoingPackets.cs` — outgoing builders
- `src/ClassicUO.Client/Network/StackDataReader.cs` — `ref struct` buffer reader

## Incoming handler template

```csharp
_handlers[0xXX] = YourHandlerName;

private static void YourHandlerName(ref StackDataReader p)
{
    if (p.Length < MINIMUM_LENGTH) return;
    uint serial = p.ReadUInt32BE();
    // remaining fields in wire order
}
```

## Outgoing builder template

```csharp
public static void SendYourPacket(NetClient socket, uint arg1)
{
    Span<byte> buf = stackalloc byte[FIXED_LENGTH];
    var writer = new StackDataWriter(buf);
    writer.WriteUInt8(0xXX);
    writer.WriteUInt16BE(FIXED_LENGTH);
    writer.WriteUInt32BE(arg1);
    socket.Send(buf);
}
```

## After changes

Dispatch the `packet-handler-reviewer` agent, then run `dotnet test tests/ClassicUO.UnitTests`.
