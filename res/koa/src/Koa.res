type t
type ctx

type next = unit => Promise.t<unit>
type middleware = (ctx, next) => Promise.t<unit> 


@module @new  external newKoa: unit => t = "Koa"
@send external use: (t, middleware) => unit = "use"
@send external listen: (t, int) => unit = "listen"

@get external ctxBodyasJson: ctx => Js.Json.t = "body"

