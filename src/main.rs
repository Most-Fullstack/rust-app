use actix_web::{web, App, HttpServer, Responder};

async fn greet() -> impl Responder {
    "Hello, world 0.1.1!"
}

fn health_check() {
    println!("rust-app Started");
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    health_check();
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(greet))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}