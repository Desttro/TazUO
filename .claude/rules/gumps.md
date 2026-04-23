---
paths:
  - "src/ClassicUO.Client/Game/UI/Gumps/**"
  - "src/ClassicUO.Client/Game/UI/**"
---

# UI Gump Rules

## Disposal

Every gump that subscribes to events **must** unsubscribe in `OnDispose`. Missing unsubscriptions are the #1 source of memory leaks and phantom callbacks in this codebase.

```csharp
protected override void OnDispose()
{
    someControl.MouseOver -= OnMouseOver;   // every += must have a matching -=
    _customTexture?.Dispose();
    base.OnDispose();
}
```

Do not use lambda event handlers unless the gump is guaranteed to be short-lived — lambdas cannot be unsubscribed by reference.

## Lifecycle

- Add gumps via `UIManager.Add()`, not by constructing and calling `Dispose()` yourself.
- Do not hold static references to gump instances — they prevent GC after close.
- Check `IsDisposed` before accessing state in deferred callbacks or timers.

## Drawing

- Avoid allocations in `Draw` — no `new T`, no LINQ, no string concat per frame.
- Set `WantUpdateLayout = true` to request a layout pass; do not call layout logic inside `Draw`.
- Use `IsVisible` to skip drawing invisible controls rather than adding conditional branches in `Draw`.

## Custom TazUO gumps

TazUO extends many ClassicUO gumps. When overriding:
- Call `base.OnInitialize()` and `base.OnDispose()` unless you have an explicit reason not to.
- Coordinate drag/resize behavior with the existing `GumpDragable` and saved-position logic.

## After changes

Use the `gump-lifecycle` skill checklist and dispatch `code-reviewer` agent.
