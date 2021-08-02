type t;
@get external get: Koa.ctx => t = "request"

// This requires middleware https://github.com/koajs/bodyparser 
@get external bodyAsJson: t => Js.Json.t = "body"
