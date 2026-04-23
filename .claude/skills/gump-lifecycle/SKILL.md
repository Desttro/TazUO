---
name: gump-lifecycle
description: Disposal and event-handling template for UI gumps in TazUO. Auto-loads when editing files under src/ClassicUO.Client/Game/UI/.
paths:
  - "src/ClassicUO.Client/Game/UI/Gumps/**"
  - "src/ClassicUO.Client/Game/UI/**"
user-invocable: false
---

# Gump Lifecycle — Pattern

Rules and rationale live in `.claude/rules/gumps.md` (auto-loads alongside this skill).

## OnDispose template

```csharp
protected override void OnDispose()
{
    someControl.MouseOver -= OnMouseOver;    // every += needs a matching -=
    anotherControl.ValueChanged -= OnChanged;
    _customTexture?.Dispose();
    base.OnDispose();
}
```

## Pre-commit checklist

- [ ] Every `+=` has a matching `-=` in `OnDispose`.
- [ ] No lambdas used as event handlers (can't be unsubscribed by reference).
- [ ] Textures / `RenderTarget2D` / streams disposed.
- [ ] No static references keeping the gump alive after close.
- [ ] Gump added via `UIManager.Add`, removed via the close path — not `Dispose()` directly.
- [ ] `IsDisposed` guard before accessing state in deferred callbacks or timers.
- [ ] `WantUpdateLayout = true` instead of forcing layout in `Draw`.

## After changes

Open and close the gump several times in a debug build, watch managed-memory growth, then dispatch `code-reviewer`.
