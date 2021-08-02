type t
type ctx
type request
type response

type next = unit => Promise.t<unit>
type middleware = (ctx, next) => Promise.t<unit> 


@module @new  external newKoa: unit => t = "koa"
@send external use: (t, middleware) => unit = "use"
@send external listen: (t, int) => unit = "listen"


