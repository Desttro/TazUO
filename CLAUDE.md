# TazUO — Claude Code Guide

TazUO is a feature-rich fork of ClassicUO, an open-source Ultima Online client. C# targeting **.NET 10**. Cross-platform: Windows (primary), macOS, Linux. Uses FNA for rendering and IronPython for scripting.

## Build / Test / Run

Run these exactly:

```bash
dotnet restore
dotnet build -c Release
dotnet test tests/ClassicUO.UnitTests --verbosity normal
./format.sh                          # format all tracked src/ projects
./tools/generate-docs.sh             # regenerate Python API markdown
```

The canonical build command matches CI (`.github/workflows/build-test.yml`). Test framework is xUnit + FluentAssertions.

## Project Layout

```
src/
  ClassicUO.Client/             main executable (entry point)
    Game/                       game systems, managers, UI gumps
    Network/                    packet handlers and outgoing packets
    LegionScripting/            IronPython integration + PyClasses
      PyClasses/                C# wrappers exposed to Python
      docs/                     auto-generated API markdown
  ClassicUO.Assets/             UO file-format loaders
  ClassicUO.Renderer/           FNA-based rendering
  ClassicUO.IO/                 I/O for UO formats
  ClassicUO.Utility/            shared utilities
  ClassicUO.SourceGenerators/   Roslyn source generators
tests/ClassicUO.UnitTests/      xUnit tests
tools/                          build helpers (generate-docs, increment-version)
external/                       vendored dependencies — do not edit
```

## Coding Rules

Enforced by `.editorconfig` (severity: error) — obey these when writing C#:

- Use expression-bodied members for methods and properties where applicable.
- Prefer pattern matching over `is` / `as` checks.
- Prefer object/collection initializers.
- **Do not** use `var` for built-in types (write `int`, `string`, etc. explicitly).
- Use `var` **only** when the type is apparent from the right-hand side.
- Interfaces are `IName`. Types and non-field members are `PascalCase`.
- LF line endings. 4-space indent for C#. 2-space for XML/JSON/YAML.
- UTF-8 encoding for files under `src/`.

## Hot-Path Rules

Code in the game loop, renderer, packet dispatch, and Python bridge runs thousands of times per second. In those paths:

- Do not allocate in `Update`/`Draw` loops — pool objects.
- Do not use LINQ in per-frame code — use `for` / `foreach` over concrete collections.
- Do not concatenate strings in loops — use `StringBuilder` or `Span<char>`.
- Watch for boxing: generic constraints, `object` params, `Enum` without `HasFlag` alternatives.
- Dispose `IDisposable` (textures, streams, native handles). Unsubscribe events in `OnDispose`.
- Validate packet buffer bounds before reading.

## Python Subsystem

The IronPython runtime exposes C# wrapper classes (`Py*`) in `src/ClassicUO.Client/LegionScripting/PyClasses/`. When you add or change a `Py*` class, regenerate docs with `./tools/generate-docs.sh`. Auto-generated docs are in `src/ClassicUO.Client/LegionScripting/docs/`.

## JSON Context Generation

All JSON serialize/deserialize **must** have a JsonSerializerContext generated (`[JsonSerializable]`). The project uses source-generated context for AOT compatibility. Do not use reflection-based JSON serialization.

## What Not to Touch

- `external/**` — vendored third-party code (FNA, iplib, Myra, MP3Sharp). Submit upstream instead.
- `bin/**`, `obj/**` — build artifacts.
- `ClassicUO.sln.DotSettings` — Rider/ReSharper settings.
- `*.csproj`, `ClassicUO.sln`, `Directory.Build.props` — require user approval (permissions `ask` list).

## License Headers

Do not add a license header to files you create. The project applies `ClassicUO.licenseheader` via tooling.

## Tooling Available to You

- **csharp-lsp** plugin is enabled — use LSP go-to-definition and find-references instead of grep when tracking types through the 500k-LOC codebase.
- Custom agents live in `.claude/agents/` — `code-reviewer`, `debug-investigator`, `packet-handler-reviewer`, `python-api-auditor`, `test-runner`, `performance-profiler`.
- Custom commands: `/build`, `/test`, `/format`, `/gen-docs`, `/changelog`.
- Path-scoped rules in `.claude/rules/` load automatically when you work in the matching subsystem.
