# LazyVim — Agent Guide

## Project

Neovim distribution (not a standalone plugin). Requires Neovim >= 0.11.2. Source in `lua/lazyvim/`.

## Commands

| Purpose | Command |
|---|---|
| Run all tests | `nvim -l tests/minit.lua tests/` or `scripts/test` |
| Format Lua | `stylua .` (2-space, 120 col, `sort_requires`) |
| Lint | `selene .` or `luacheck .` |
| Lint markdown | `markdownlint-cli2` |

CI is delegated to `folke/github/.github/workflows/ci.yml@main`.

## Architecture

- **Root `init.lua` is a decoy** — it prints an error telling users not to clone directly. The real entrypoint is `lua/lazyvim/init.lua`, which exports `M.setup(opts)`.
- **`lua/lazyvim/config/`** — defaults for options, keymaps, autocmds. User overrides are loaded on top by module name.
- **`lua/lazyvim/plugins/`** — core plugin specs (`init.lua` bootstraps lazy.nvim + LazyVim + snacks.nvim).
- **`lua/lazyvim/plugins/extras/`** — opt-in bundles (ai/, coding/, lang/, editor/, ui/, dap/, test/, util/, formatting/, linting/).
- **`lua/lazyvim/util/`** — lazy-loaded submodules via metatable `__index`.
- **`lua/lazyvim/util/plugin.lua`** — handles renamed/deprecated extras migration.

## Extras & Defaults

- Extras are loaded by `lua/lazyvim/plugins/xtras.lua` with a priority system (core = 1/2, defaults = 20, rest = 50).
- Defaults for picker/cmp/explorer are managed by `M.register_defaults()` in `config/init.lua`. Controlled via `vim.g.lazyvim_picker`, `vim.g.lazyvim_cmp`, `vim.g.lazyvim_explorer`. Migrates based on `lazyvim.json` install version.
- `:LazyExtras` opens the extras manager UI.
- **Most complex extra**: `lua/lazyvim/plugins/extras/coding/coc.lua` (463 lines) — fully replaces LSP, completion, formatting. Has its own migration doc at `COC-MIGRATION.md` (Chinese, slightly outdated vs actual implementation).

## Gotchas

- **Import order matters**: `lazyvim.plugins` → `lazyvim.plugins.extras.*` → user `plugins`. Violations trigger a warning. Disable with `vim.g.lazyvim_check_order = false`.
- **Safe keymap set**: Core keymaps use `LazyVim.safe_keymap_set` (avoids conflicts with lazy keys handlers). Sets `silent=true` by default.
- **LSP keymaps**: Use the server's `keys` field, not `on_attach` (see `lua/lazyvim/plugins/lsp/keymaps.lua`). Use `<localleader>` for language-specific mappings.
- **Notifications** are deferred until `vim.notify` is replaced (or 500ms timeout).
- **Check health**: `:LazyHealth` loads all plugins then runs `:checkhealth`.

## Style

- Formatting: StyLua, 2-space indent, 120 char width, `sort_requires` enabled.
- Use `-- stylua: ignore` to exempt specific blocks.
- All plugin specs should be `optional=true` and properly lazy-loaded when the user doesn't have them.
- For Lua deps, use a separate `lazy=true` spec, not the `dependencies` field.
- Every language extra needs a `recommended` section.
- Use `LazyVim` (not `lazyvim.util`) as the global reference.

## Tests

- Framework: `lazy.minit` (busted-compatible `describe`/`it` blocks).
- `tests/dd_spec.lua` ensures no `dd()` debug calls remain in `lua/`.
- `tests/extras/extra_spec.lua` validates all extras load cleanly (no mason auto-install, no default parser overrides, etc.).
- `tests/util/util_spec.lua` tests `LazyVim.memoize`.

## Contributing

See `CONTRIBUTING.md` for extra/lang submission rules. Key constraints: avoid Vim plugins unless justified, ensure all config is user-overridable via Lazy specs, and implement proper lazy-loading.
