---
paths:
  - "src/ClassicUO.Renderer/**"
---

# Renderer Rules

Code in this directory runs inside every `Draw` call at 60+ FPS. The constraints are strict.

## Must-do

- **No heap allocations per frame.** No `new T[]`, `new List<>`, `new Dictionary<>`, or closures that capture locals inside `Draw` or any method it calls. Use pooled buffers (`ArrayPool<T>`, `StackDataWriter` on the stack) or pre-allocated fields.
- **No LINQ.** Replace `.Where`, `.Select`, `.ToList`, `.Any`, `.First` with `for`/`foreach` over concrete types.
- **No string operations per frame.** No `string.Format`, interpolation, or `ToString()` in hot paths — cache strings computed at load time.
- **Dispose textures, RenderTarget2D, and effects** — all implement `IDisposable`. Missing disposal leads to GPU memory growth and eventually device resets.
- **Sprite batching must be respected.** Do not break batch unnecessarily (switching texture, shader, or blend state). Group draw calls by texture atlas where possible.
- **SetData/GetData on textures is extremely slow** — never call inside Draw; defer to load time or a precompute step.
- **Unsafe code** (`stackalloc`, `fixed`, pointers) is allowed here but must be audited for buffer overruns and correct `sizeof` usage.

## FNA specifics

- FNA is the rendering backend (OpenGL/Vulkan/Metal underneath). Do not call XNA-only APIs that FNA stubs out.
- `GraphicsDevice.Textures[n]` slots should be explicitly cleared after use to avoid stale state in subsequent draw calls.
- `SpriteBatch.Begin`/`End` pairs must be balanced. Nested `Begin` calls are not supported.

## After changes

Dispatch `performance-profiler` agent to verify the diff introduces no per-frame allocations.
