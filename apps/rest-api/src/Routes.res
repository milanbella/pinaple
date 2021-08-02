let router = ResKoa.Router.newRouter()

let cFILE = "Routes.res"

ResKoa.Router.post(router, "/create_user", (ctx, next) => {
  let cFUNC = "post(/create_user)"
  let req = ResKoa.Request.get(ctx);
  let rep = ResKoa.Response.get(ctx);
  User.apiCreateUser(ResKoa.Request.bodyAsJson(req))
  -> Promise.then((result) => {
    switch result {
    | Ok(_) => 
      Js.Console.log("@@@@@@@@@@@@@@@@@@@@@@@@ cp 100: ok")
      let data = Json.Encode.object_(list{
      })
      ResKoa.Response.bodyAsJson(rep, data)
      Promise.resolve()
    | Error(err) => 
      LibWeb.Logger.errorE(cFILE, cFUNC, `error`, err);
      let data = T.Error.encode(err)
      ResKoa.Response.bodyAsJson(rep, data)
      ResKoa.Response.status(rep, 500)
      Promise.resolve()
    }
  })
  -> Promise.catch((err) => {
    LibWeb.Logger.errorE(cFILE, cFUNC, `error`, err);
    let data = T.Error.encode({T.Error.err: "error", message: "internal error"});
    ResKoa.Response.bodyAsJson(rep, data)
    ResKoa.Response.status(rep, 500)
    Promise.resolve()
  })
})
