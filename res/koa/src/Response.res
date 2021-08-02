type t;
@get external get: Koa.ctx => t = "response"
@set external bodyAsJson: (t, Js.Json.t) => unit = "body"
@set external status: (t, int) => unit = "status"
