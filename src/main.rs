use actix_web::{web, App, HttpServer, Responder};

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
    let Ok(mode) = env::var("PRINT_ENV")
    let Ok(endpoint) = env::var("ENDPOINT")
    let Ok(port) = env::var("PORT")

    logging(&port, &endpoint, &mode);

    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(greet))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}