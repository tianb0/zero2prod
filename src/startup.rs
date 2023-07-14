use std::net::TcpListener;

use actix_web::{dev::Server, web, App, HttpServer, middleware::Logger};
use sqlx::{PgConnection, PgPool};

use crate::routes::{health_check, subscribe};

pub fn run(
    listener: TcpListener,
    // connection: PgConnection,
    db_pool: PgPool,
) -> Result<Server, std::io::Error> {
    // wrap the connection in a smart pointer
    let connection = web::Data::new(db_pool);

    let server = HttpServer::new(move || {
        App::new()
            // app-wide middlewares
            .wrap(Logger::default())
            .route("/health_check", web::get().to(health_check))
            .route("/subscriptions", web::post().to(subscribe))
            .app_data(connection.clone())
    })
    .listen(listener)?
    .run();
    Ok(server)
}
