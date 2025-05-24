function rustyconf
    cp ~/.alex-dotfiles/rust-toolchain .
    cp ~/.alex-dotfiles/rustfmt.toml .
    ln -s ~/.alex-dotfiles/.cursor .

    echo ".cursor" >>.gitignore
    echo ".env" >>.gitignore
    echo "RUST_LOG=info" >>.env

    # todo: add the crates commented out to cargo.toml
end
