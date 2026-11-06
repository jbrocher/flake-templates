# Base template

A Node development shell with direnv, nix-direnv manual reload, local environment variables, and project-scoped Codex setup.

## Start a project

```sh
nix flake init -t path:/path/to/flake-templates#base
git init # only if this is a new repository
nix flake lock
direnv allow
```

Install and hook `direnv` and `nix-direnv` in your **host shell** first. See the [nix-direnv installation guide](https://github.com/nix-community/nix-direnv#installation) for NixOS, Home Manager, and profile setup. The flake also makes both commands available inside `nix develop`, but the host integration is needed before `.envrc` can load the shell. With nix-direnv manual mode, run `nix-direnv-reload` when you want to rebuild the environment after changing `flake.nix` or `flake.lock`. Edit `.env` for local values after initializing Git; it is ignored by Git in the generated project.

On another host, clone the project with its committed `flake.lock`, then run `direnv allow`. The private `.env` will not be in the clone; `.envrc` works without it. Copy `.env.example` to `.env` only if that host needs local values.

## Skills

Create a starter skill with:

```sh
bash scripts/new-skill my-workflow "Use when doing my workflow in this project."
```

Then replace the placeholder instructions in `.agents/skills/my-workflow/SKILL.md`. Codex discovers project skills there. You can also ask Codex to use `$skill-creator` for a more developed workflow. If a skill needs an MCP server, optionally add `agents/openai.yaml` inside that skill to declare the dependency. The MCP connection itself belongs in `.codex/config.toml`.

## Codex MCP and command rules

The template carries the public OpenAI Docs, Context7, and Notion MCP endpoints in `.codex/config.toml`. On each host, trust the project in Codex, then run `codex mcp login notion` and authorize your Notion workspace in the browser. Run `codex mcp list` to inspect the connections. Context7's public endpoint needs no key; its optional API key gives higher rate limits. Keep any key in the host's user environment or secret manager, never in a committed TOML file, `.env`, or skill metadata. Notion's OAuth credentials stay outside the project. If the host has an OS keyring, you can set `mcp_oauth_credentials_store = "keyring"` in its user-level `~/.codex/config.toml`.

The repo carries connection addresses and rules; each host supplies its own Nix, direnv hook, project trust, and account authorization. A skill's `agents/openai.yaml` can declare a tool dependency, but it is not the general MCP connection or credential store.

`.codex/rules/base.rules` contains narrow example allow rules for read-only commands outside the sandbox. Add only command prefixes you are comfortable running without approval. Rules also require a trusted project and a Codex restart. Check a rule before relying on it:

```sh
codex execpolicy check --pretty --rules .codex/rules/base.rules -- git status --short
```

For a shared skill plus its MCP server, package them as a plugin. For ordinary project MCP connections, `.codex/config.toml` is simpler.
