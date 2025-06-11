function rusty
    if test (count $argv) -eq 0
        echo "No directory provided"
        return 1
    end
    set project_name $argv[1]

    cargo new --bin $project_name

    cd $argv[1]

    cp ~/.alex-dotfiles/rust-toolchain .
    cp ~/.alex-dotfiles/rustfmt.toml .

    # symlink agent stuff
    ln -s ~/.alex-dotfiles/.cursor .
    ln -s ~/.alex-dotfiles/.claude .

    # add ignore files
    echo "" >>.gitignore
    echo ".cursor" >>.gitignore
    echo ".claude" >>.gitignore
    echo ".env" >>.gitignore

    # add env variables
    echo "" >>.env
    echo "RUST_LOG=info" >>.env

    # essentials
    cargo add tokio --features full # async runtime
    cargo add anyhow # error handling
    cargo add dotenvy # environment variables
    cargo add serde --features derive # serialization
    cargo add serde_json # json serialization
    cargo add chrono # time utils
    cargo add thin-logger # logging (re-exports log, env_logger, and colored)
    cargo add tap # tapping into values (useful for debugging)

    # experimental

    echo "
#![allow(unused, clippy::all)]
#![feature(let_chains, try_blocks)]

/*
    other useful crates:
    cargo add derive_more --features full # derive macros for more traits
    cargo add variantly # introspection for enum variants
    cargo add validator # validation library
    cargo add bon # builder pattern
    cargo add strum strum_macros # set of macros and traits for working with enums and strings
    cargo add nestruct # nested structs
    cargo add reqwest # http client
    cargo add itertools # iterators
*/

use anyhow::Result;
use thin_logger::log;

#[tokio::main]
async fn main() -> Result<()> {
    dotenvy::dotenv().ok(); // load .env file
    thin_logger::build(None).init(); // init logging

    log::info!(\"Hello, world!\");

    Ok(())  
}
" >src/main.rs

    # format
    cargo fmt

    git add .
    git commit -m "(feat): initialize project"

end
