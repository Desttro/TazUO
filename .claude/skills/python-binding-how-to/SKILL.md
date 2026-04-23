---
name: python-binding-how-to
description: Template for adding a new Py* wrapper class exposing C# APIs to IronPython. Auto-loads when editing files under src/ClassicUO.Client/LegionScripting/.
paths:
  - "src/ClassicUO.Client/LegionScripting/**"
user-invocable: false
---

# Adding a Python Binding — Workflow

Rules for what Python can see (type constraints, error handling, threading) live in `.claude/rules/python.md` (auto-loads alongside this skill).

## 1. Create the Py* class

`src/ClassicUO.Client/LegionScripting/PyClasses/PyYourThing.cs`:

```csharp
public class PyYourThing
{
    private readonly YourCSharpType _inner;

    internal PyYourThing(YourCSharpType inner) => _inner = inner;

    /// <summary>One-line summary. Flows into Api*.md.</summary>
    /// <param name="arg">Description.</param>
    /// <returns>Description.</returns>
    public int YourMethod(int arg)
    {
        if (_inner == null) return 0;
        return _inner.DoThing(arg);
    }
}
```

## 2. Register it

Grep `PyPlayer` or `PyMobile` to find the registration site; add yours with the same pattern.

## 3. Regenerate docs

```bash
./tools/generate-docs.sh
```

Commit the regenerated `src/ClassicUO.Client/LegionScripting/docs/Api*.md` in the same PR.

## After changes

Dispatch the `python-api-auditor` agent. Test with a short `.py` script that exercises the new API.
