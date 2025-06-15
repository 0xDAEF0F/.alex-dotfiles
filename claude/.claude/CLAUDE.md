# Coding Rules

## Comments

- skip comments if names are clear and behavior is intuitive
- comments should be in lowercase
- prefer self-documenting code over excessive comments
- when comments are necessary, keep them concise and focused on "why" not "what"

## Code Quality

- avoid linting errors in code output
- run linting tools before finalizing code
- follow project-specific lint configurations
- fix warnings, not just errors

## Development Practices

- use available tools and mcp servers to improve accuracy
- use type checking where applicable
- validate assumptions with appropriate tools
- use anyhow in rust whenever possible
- prefer exa mcp over you native web search
- if inside ts/js projects make sure to check which is the existing package manager and runtime
- do not use `cargo build --release`. doing `cargo check` is fine.

## Naming Conventions

- use descriptive, self-explanatory names
- avoid abbreviations unless widely understood
- be consistent with existing codebase patterns
- prefer clarity over brevity

## Error Handling

- provide clear and ergonomic error messages
- handle edge cases explicitly

## Code Structure

- keep functions focused and single-purpose
- group related functionality together
