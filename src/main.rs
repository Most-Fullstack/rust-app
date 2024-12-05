use actix_web::{web, App, HttpServer, Responder};
use dotenv::dotenv;
use std::env;

async fn greet() -> impl Responder {
    "Hello, world 0.1.1!"
}

fn health_check() {
    println!("rust-app Started");
}

fn logging(port: &str, endpoint: &str, mode: &str) {
    println!("Server started at http://{}:{} in {} mode", endpoint, port, mode);
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    health_check();
    dotenv().ok();

    let mode = env::var("PRINT_ENV").unwrap_or_else(|_| "dev".to_string());
    let endpoint = env::var("ENDPOINT").unwrap_or_else(|_| "0.0.0.0".to_string());
    let port = env::var("PORT").unwrap_or_else(|_| "8080".to_string());

    logging(&port, &endpoint, &mode);

    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(greet))
    })

    .bind(format!("0.0.0.0:{}", port))?
    .run()
    .await
}