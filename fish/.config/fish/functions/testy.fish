function testy
    if test (count $argv) -eq 0
        echo "Usage: testy <test_path>"
        echo "Example: testy mod::tests::test_a"
        return 1
    end

    set test_path $argv[1]

    # try to get package name from Cargo.toml in current directory
    if test -f Cargo.toml
        set pkg_name (grep '^name = ' Cargo.toml | head -1 | sed 's/name = "\(.*\)"/\1/')
    else
        # fallback to current directory name
        set pkg_name (basename (pwd))
    end

    echo "Running: cargo test --package $pkg_name -- $test_path --show-output"
    cargo test --package $pkg_name -- $test_path --show-output
end
