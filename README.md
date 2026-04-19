# homebrew-pitboss

Homebrew tap for [pitboss](https://github.com/SDS-Mode/pitboss), a Rust
dispatcher for running and observing parallel Claude Code sessions.

Formulae here are **auto-maintained** by the
[cargo-dist](https://github.com/astral-sh/cargo-dist) release
workflow in the upstream repo — do not edit them by hand; the next
release will overwrite any local changes.

## Install

```bash
brew tap SDS-Mode/pitboss
brew install pitboss-cli
brew install pitboss-tui
```

Or in one shot (Homebrew auto-taps from the fully-qualified name):

```bash
brew install SDS-Mode/pitboss/pitboss-cli
brew install SDS-Mode/pitboss/pitboss-tui
```

## Updating

```bash
brew update
brew upgrade pitboss-cli pitboss-tui
```

## Supported platforms

Mirrors the upstream cargo-dist target matrix:

- `aarch64-apple-darwin` (Apple Silicon)
- `x86_64-unknown-linux-gnu` (Intel/AMD Linux)
- `aarch64-unknown-linux-gnu` (ARM Linux)

Intel Macs and Windows are not supported — see the upstream repo for
source-build instructions.

## Reporting issues

File issues against the main pitboss repository:
<https://github.com/SDS-Mode/pitboss/issues>
