function rustyconf
    cp ~/.alex-dotfiles/rust-toolchain .
    cp ~/.alex-dotfiles/rustfmt.toml .

    ln -s ~/.alex-dotfiles/.cursor .
    ln -s ~/.alex-dotfiles/.claude .

    echo "" >>.gitignore
    echo ".cursor" >>.gitignore
    echo ".claude" >>.gitignore
    echo ".env" >>.gitignore

    echo "" >>.env
    echo "RUST_LOG=info" >>.env

    # todo: add the crates commented out to cargo.toml
end
