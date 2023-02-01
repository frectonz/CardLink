use lambda_http::{
    request::RequestContext, run, service_fn, Body, Error, Request, RequestExt, Response,
};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
struct Link {
    name: String,
    url: String,
}

async fn function_handler(event: Request) -> Result<Response<Body>, Error> {
    let RequestContext::ApiGatewayV1(ctx) = event.request_context();

    let link = event.payload::<Link>()?;
    let body = serde_json::to_string_pretty(&link).unwrap();
    let identity = serde_json::to_string_pretty(&ctx.identity).unwrap();

    Ok(Response::builder()
        .status(200)
        .header("Content-Type", "text/html")
        .body(Body::Text(format!(
            "Identity = {}\n\nBody = {}",
            identity, body
        )))?)
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::INFO)
        // disable printing the name of the module in every log line.
        .with_target(false)
        // disabling time is handy because CloudWatch will add the ingestion time.
        .without_time()
        .init();

    run(service_fn(function_handler)).await
}
