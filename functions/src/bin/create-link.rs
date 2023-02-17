use lambda_http::{
    request::RequestContext, run, service_fn, Body, Error, Request, RequestExt, Response,
};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
struct Link {
    name: String,
    url: String,
}

// new type pattern wrap `Body` to parse the body as a `Link` type.
struct LinkBody<'a>(&'a Body);

impl<'a> LinkBody<'a> {
    fn json(&self) -> Option<Link> {
        match &self.0 {
            Body::Empty => None,
            Body::Binary(_) => None,
            Body::Text(text) => serde_json::from_str::<Link>(text).ok(),
        }
    }
}

async fn function_handler(event: Request) -> Result<Response<Body>, Error> {
    let link = LinkBody(event.body()).json().unwrap_or(Link {
        name: "unknown".to_string(),
        url: "unknown".to_string(),
    });

    let RequestContext::ApiGatewayV1(ctx) = event.request_context();

    let username = ctx
        .authorizer
        .get("claims")
        .and_then(|c| c.get("username"))
        .and_then(|u| u.as_str())
        .unwrap_or("anonymous");

    Ok(Response::builder()
        .status(200)
        .header("Content-Type", "text/html")
        .body(Body::Text(format!(
            "Hello, {username}! You are creating a link called {} with URL {}",
            link.name, link.url,
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
