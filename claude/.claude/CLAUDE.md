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

## Naming Conventions

- use descriptive, self-explanatory names
- avoid abbreviations unless widely understood
- be consistent with existing codebase patterns
- prefer clarity over brevity

## Error Handling

- provide clear error messages
- handle edge cases explicitly
- use appropriate error types
- include context in error messages

## Code Structure

- keep functions focused and single-purpose
- minimize cognitive complexity
- group related functionality together