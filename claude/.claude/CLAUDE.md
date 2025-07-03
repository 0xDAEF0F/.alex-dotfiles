# Coding Rules

## Comments

- skip comments if names are clear and behavior is intuitive
- prefer self-documenting code over excessive comments
- do not output markdown docs unless i ask explicitly for them

## Code Quality

- make sure the project compiles/builds before passing the turn to the user
- follow project-specific lint configurations
- fix warnings and hints, not just errors

## Development Practices

- use available tools and mcp servers to improve accuracy
- prefer exa mcp over your native web search

## Javascript/Typescript/React

- read `package.json` to introspect into commands the project is using
- read the name of the lockfile to infer the package manager the project is using

## Rust

- use the `rust-docs` mcp to embed and query rust crates documentation
- use `bail!()` instead of `Err(anyhow!())`
- use `anyhow` for error handling
- instead of `cargo build` use `cargo clippy`
- use `cargo add` instead of directly editing Cargo.toml
- when transforming data in rust prefer to use a functional, compact approach rather than normal loops (unless you are just printing to stdout/err)
