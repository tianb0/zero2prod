[inner dev loop]
- make a change
- compile the app
- run tests
- run the app

[toolchain]
- rustc
- cargo watch: `cargo watch -x check -x test -x run`
- custom linker (skipped, zld deprecated)

[CI]
- cargo test (minimum step)
- code coverage: cargo-tarpaulin
  - `cargo install cargo-tarpaulin`
  - `cargo tarpaulin --ignore-tests`
  - Codecov, Coveralls
- linter: spot unidiomatic code
  - clippy: the official Rust linter
    - `rustup component add clippy`
    - `cargo clippy` [add `-- -D warning` to fail on warnings]
    - `#[allow(clippy::lin_name)]` to ignore
- formatting: rustfmt
  - `cargo fmt` [add `-- --check` to fail on unformatted code]
  - configuration file: rustfmt.toml 
- security
  - audit crates: cargo-audit
    - `cargo install cargo-audit`
  - cargo-deny
