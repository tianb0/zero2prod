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

[user stories]
as ...
I want ...
So that ...

As the blog author,
I want to send an email to all my subscribers,
So that I can notify them when new content is published.

- instead of going deep on one journey, build enough to satisfy, to an extent, the requirement of the journey
- work in iterations, improving the experience, giving a slightly better version of the product
- the code produced in each iteration will be tested, properl documented, production-quality

------------------

[add libraries]

`cargo add actix-web@4`

`cargo add tokio@1 --features macros,rt-multi-thread`

the specific version and features may vary depending on what you need

[expand macros]
- `cargo install cargo-expand`
- see the macro output `cargo expand`
- if nightly toolchain is required: `rustup toolchain install nightly --allow-downgrade`
