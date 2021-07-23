type t

@module @new  external newRouter: unit => t = "@Koa/router"

@send external routes: t => Koa.middleware = "routes" 
@send external allowedMethods: t => Koa.middleware = "allowedMethods" 

@send external get: (t, string, Koa.middleware) => unit = "get" 
@send external put: (t, string, Koa.middleware) => unit = "put" 
@send external post: (t, string, Koa.middleware) => unit = "post" 
@send external del: (t, string, Koa.middleware) => unit = "del" 
