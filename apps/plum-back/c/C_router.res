type t 
type handler = (C_request.t, C_response.t) => Js.Promise.t<unit>

@bs.module("express") external router: () => t = "Router" 

@bs.send external get: (t, string, handler) => unit = "get" 
@bs.send external post: (t, string, handler) => unit = "post" 

