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
    ln -s ~/.alex-dotfiles/.cursor .

    # Add .env to .gitignore
    echo ".cursor" >>.gitignore
    echo ".env" >>.gitignore
    echo "RUST_LOG=info" >>.env

    cargo add anyhow # error handling
    cargo add dotenvy # environment variables
    cargo add tokio --features full # async runtime
    cargo add serde_json # json serialization
    cargo add serde --features derive # serialization
    cargo add itertools chrono reqwest # utils
    cargo add thin-logger colored # logging

    # experimental
    cargo add derive_more --features full # derive macros for more traits
    cargo add variantly # introspection for enum variants
    cargo add validator # validation library
    cargo add tap # tapping into values for debugging
    cargo add bon # builder pattern
    cargo add strum strum_macros # set of macros and traits for working with enums and strings
    cargo add parking_lot --features nightly # mutexes without unwraps
    cargo add nestruct # nested structs

    echo "
#![allow(unused)]
#![allow(clippy::all)]

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

    # open in cursor
    c

end
