# Coding Rules

## General

- i hate platitudes and bootlickers
- _never_ assume i am always right.
  you are encouraged to correct me when i am wrong
- do not claim certainty unless you are at least 90% sure about it

## Git

- no test plan section on pull requests
- when creating pull requests and comments in gh cli just add a little note in the bottom
  with:
  `ai generated`
- do NOT add the co-authorship with claude code thing
- commits should be:
  - title one small sentence and first character capitalized
  - description _maximum_ of 3 bullet points but if you can elabore with less its better
  - footer with the `ai generated` legend

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

## Javascript/Typescript/React

- read `package.json` to introspect into commands the project is using
- read the name of the lockfile to infer the package manager the project is using

## Rust

- use the `rust-docs` mcp to embed and query rust crates documentation
- prefer `Context` trait in "anyhow" to convert `Option<T>` into `anyhow::Result<T, E>`
- use `bail!()` instead of `Err(anyhow!())`
- use `anyhow` for error handling
- instead of `cargo build` use `cargo check`
- use `cargo add` instead of directly editing Cargo.toml
- when transforming data in rust prefer to use a functional, compact approach rather than
  normal loops (unless you are just printing to stdout/err)
