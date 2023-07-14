use sqlx::{Connection, PgConnection, PgPool};
use std::net::TcpListener;
use zero2prod::{configuration::get_configuration, startup::run};
use env_logger::Env;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    // `init` calls `set_logger` internally
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    // panic if we wan't read configuration
    let configuration = get_configuration().expect("Failed to read configuration.");
    // let connection = PgConnection::connect(
    //     &configuration.database.connection_string()
    // )
    //     .await
    //     .expect("Failed to connect to Postgres.");
    let connection_pool = PgPool::connect(&configuration.database.connection_string())
        .await
        .expect("Failed to connect to Postgres.");

    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = TcpListener::bind(address)?;
    run(listener, connection_pool)?.await
}
