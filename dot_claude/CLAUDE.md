# Communication Style

- **Be succinct.** PR replies, issue comments, and Slack messages should be short and to the point. No walls of text. Aim for 2-4 sentences max. State the conclusion first, then brief supporting evidence. No bullet-point dumps or repeated explanations.
- Use `-` (hyphen) for dashes, never `—` (em dash) or `–` (en dash).

# Git Workflow

- **Never rebase.** To update a branch with latest main, use `git merge main` (not `git rebase main`).
- Do not use `Co-Authored-By` with Claude's name in commits. Commit as the user.
- **Never start a commit title with "Fix".** Describe what the change does instead (e.g., "Include `bytes` unit in `Content-Range` header" not "Fix Content-Range header").
- **Commit and PR titles must be imperative sentences** that describe the change (e.g., "Instruct explore agent to prefer new cells" not "Explore agent: prefer new cells").

# Clipboard

- When the user needs to copy text (PR descriptions, messages, etc.), use `printf '%s' "..." | pbcopy` to put it directly in their clipboard instead of just printing it.

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
- Never use `getattr` to work around type checker errors. Use proper type annotations, `Protocol`, `TYPE_CHECKING`, or `cast()` instead.
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
- Use `logfire` for all logging (`logfire.info(...)`, `logfire.error(...)`, etc.), never `logging` or `print()`.
- Use `{key}` placeholders in log messages: `logfire.info("Created user {user_id}", user_id=uid)`.

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
- Minimal `try/except` - only where structurally necessary.
- Never use `except Exception` - always catch specific exception types. The only acceptable use is in job schedulers or plugin runners that must catch arbitrary user code failures.

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

## Formatting

- Always wrap code references in backticks (e.g., `request.body()`, `FileResponse`, `allow_credentials`).

# TypeScript Development Standards

These are the rules for writing TypeScript code. Follow them strictly.

- **Linter & formatter**: Biome only. No ESLint, no Prettier.
- **Strict mode**: `strict: true` in tsconfig.
- Line width **100 characters**, 2-space indent, double quotes, always semicolons.
- Named exports only - no default exports for components.
- Functional components with hooks (`useState`, `useRef`, `useEffect`, `useCallback`).
- Define prop types as `type Props = { ... }` above the component.
- PascalCase for component names, camelCase for functions/variables.
- Tailwind utility-first CSS - no custom CSS files.
- `@/*` path alias for `src/` imports.

# Go Development Standards

These are the rules for writing Go code. Follow them strictly.

- **Linter**: golangci-lint with errcheck, govet, staticcheck, unused, ineffassign, gocritic.
- Line width **120 characters**.
- Flat `internal/` packages by domain.
- Sentence-style doc comments on all exported types and functions.
- Explicit `if err != nil` error handling - no helper wrappers.
- Use `context.Context` as first parameter for cancellable operations.
- Table-driven tests with `testing.T` - no test framework.
- Use `t.Helper()` in test helpers.

# Kotlin Development Standards

These are the rules for writing Kotlin code. Follow them strictly.

- **Linter**: ktlint.
- Line width **120 characters**, 4-space indent.
- `@HiltViewModel` with `@Inject constructor` for all view models.
- `MutableStateFlow` / `StateFlow` for reactive state, `collectAsState()` in composables.
- `LaunchedEffect(Unit)` for initial data loading.
- PascalCase for classes and `@Composable` functions, camelCase for properties.
- Material 3 components throughout.

# Swift Development Standards

These are the rules for writing Swift code. Follow them strictly.

- Swift 6 with strict concurrency.
- `@Observable @MainActor` for view models and services.
- `actor` for thread-safe networking clients.
- `@preconcurrency import` for non-Sendable third-party types.
- `@Environment` injection for services through the view hierarchy.
- SwiftUI `Form` with `Section` containers for settings-style screens.
- `.task { await ... }` for async side effects in views.
- `.refreshable { await ... }` for pull-to-refresh.
