# Coding Rules

## Comments

- skip comments if names are clear and behavior is intuitive
- do not output md docs unless i ask explicitly for them
- comments should be in lowercase
- prefer self-documenting code over excessive comments
- when comments are necessary, keep them concise and focused on "why" not "what"

## Code Quality

- avoid linting errors in code output
- make sure the project compiles/builds before passing the turn to the user
- follow project-specific lint configurations
- fix warnings, not just errors

## Development Practices

- use available tools and mcp servers to improve accuracy
- use type checking where applicable
- validate assumptions with appropriate tools
- prefer exa mcp over your native web search
- if inside ts/js projects make sure to check which is the existing package manager and runtime

## Rust

- use the `rust-docs` mcp to embed and query rust crates documentation
- use the `rust-lsp` to access language server protocol tools and symbol information from the project
- use `anyhow` for error handling
- do not run `cargo build --release`. doing `cargo check` is fine
- run `cargo fmt` after completing the user request
- use cargo add instead of directly editing the toml file when adding dependencies in rust
- when transforming data in rust prefer to use a functional, compact approach rather than normal loops (unless you are just printing to stdout/err)

## Code Structure

- keep functions focused and single-purpose
