type t 
type handler = (Request.t, Response.t) => Js.Promise.t<unit>

@bs.module("express") external router: () => t = "Router" 

@bs.send external get: (t, string, handler) => unit = "get" 
@bs.send external post: (t, string, handler) => unit = "post" 

