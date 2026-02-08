# Python Development Standards

These are the rules for writing Python code. Follow them strictly.

## Typing

- Always add `from __future__ import annotations` as the first import in every module.
- Use modern union syntax: `X | None`, never `Optional[X]`.
- Use lowercase generics: `list[str]`, `dict[str, Any]`, never `List`, `Dict`.
- Use `Protocol` for interfaces, not ABC. Prefer structural typing over inheritance.
- Use `TypedDict` for structured dictionaries.
- Use `TypeAlias` from `typing_extensions` for simple type aliases.
- Annotate return types on every function, including `-> None` on `__init__` methods.
- Use `typing_extensions` for backporting newer typing features (`Literal`, `Protocol`, `TypeAlias`, `TypedDict`).
- Mark packages as PEP 561 compliant with a `py.typed` marker file.

## Code Style

- Line length is **120 characters**.
- Minimal docstrings — type annotations carry the documentation load. Don't add docstrings to internal/private functions unless the logic is non-obvious.
- When docstrings are needed on public APIs, use Google-style (`Args:`, `Returns:`).
- Every `__init__.py` must have an explicit `__all__` and contain only imports + `__all__`.
- Use `__call__` to make primary classes callable.
- Use `enum.Enum` with `enum.auto()` for state machines.
- Use `@dataclass(frozen=True)` for immutable value objects; `@dataclass` with `field(default_factory=...)` for mutable config.
- Module-level constants use `UPPER_SNAKE_CASE`.
- No class inheritance hierarchies — use structural subtyping via `Protocol`.
- Custom exception classes have docstring-only bodies (no `__init__` overrides unless necessary).
- Small, focused modules: 50-150 lines. Split files that grow beyond this.
- Flat package structure preferred over deep nesting.
- Use `@property` for computed attributes.
- Use `@classmethod` for factory/inference methods.
- Use `logging.getLogger(__name__)` at module level, never `print()`.

## Import Ordering

Enforce via ruff with the `I` rule. Order:

1. `from __future__ import annotations`
2. Standard library (alphabetical)
3. Third-party libraries
4. Local/project imports

Use `combine-as-imports = true` in ruff isort config.

## Error Handling

- Define custom exception classes — simple, with docstrings as documentation.
- Validate inputs early in `__init__` and raise immediately.
- Use `ValueError` for unexpected internal states, `RuntimeError` for inference/detection failures.
- Include helpful, descriptive error messages.
- Minimal `try/except` — only where structurally necessary.

## Async

- Prefer `async def` over sync functions — understand the thread pool penalty in ASGI frameworks.
- Use `anyio` for structured concurrency, not raw `asyncio`, when the project uses Starlette/FastAPI.
- Use `anyio.to_thread.run_sync` for running sync callables in async context.
- Use `async for` over `while True` loops (e.g., WebSocket iteration).

## Testing

- Use **pytest** with `--strict-config --strict-markers`.
- Set `filterwarnings = ["error"]` — all warnings are errors. Explicitly ignore known deprecations.
- Use `xfail_strict = true`.
- Target **100% test coverage** with `fail_under = 100`.
- Coverage `source_pkgs` must include both the package and `tests` directory.
- Coverage exclusion lines: `pragma: no cover`, `if TYPE_CHECKING:`, `raise NotImplementedError`, `@overload`.
- Use `pytest.mark.anyio` instead of `pytest.mark.asyncio` (anyio is already a transitive dep via Starlette).
- Use `httpx.AsyncClient` with `ASGITransport` for testing async FastAPI/Starlette apps, not `TestClient`.

## Project Configuration

- Build system: **hatchling** (not setuptools, poetry, or flit).
- Linter & formatter: **ruff** only. No black, no isort, no flake8.
- Ruff lint rules: `E, F, I, FA, UP, RUF100`.
- Type checker: **mypy** with `strict = true`.
- Package manager: **uv**.
- Dev dependencies: Use PEP 735 `[dependency-groups]`.
- `requires-python >= "3.10"` minimum (or higher if appropriate).

## FastAPI / Starlette Specific

- Use Lifespan State (yield a dict from the lifespan context manager) instead of `app.state`. Type it with `TypedDict`.
- Implement pure ASGI middleware instead of `BaseHTTPMiddleware` — the latter has a performance penalty.
- Non-async dependencies run in threads — make dependency functions `async` when they don't need to block.
- Install `uvloop` and `httptools` for production performance.
- Set `PYTHONASYNCIODEBUG=1` during development to detect blocking calls.
