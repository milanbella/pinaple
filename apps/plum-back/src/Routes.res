let router = ResExpress.Router.router()

let cFILE = "Routes.res"

let createUser = ResExpress.Router.post(router, "/create_user", (req, res) => {
  let cFUNC = "createUser()"

  let createNewUser = (user: LibWeb.Rest.User.t): Js.Promise.t<Belt.Result.t<Js.Json.t, Js.Json.t>>  => {
    Js.Console.log("@@@@@@@@@@@@@@@@@@@@@@@@@ cp 100") //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Js.Console.log(user) //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ResPg.Pool.query("insert into users(id, user_name, user_email, passowrd) values($1, $2, $3, $4)", [ResPg.Pg.Query.string(ResUuid.Uuid.id()), ResPg.Pg.Query.string(user.userName), ResPg.Pg.Query.string(user.userEmail), ResPg.Pg.Query.string(ResCrypto.Crypto.sha256(user.password))])  
    -> Js.Promise.then_((_) => {
      Js.Promise.resolve(Belt.Result.Ok(LibWeb.Rest.Reply.encode(~ok=true, ())))
    },_) 
    -> Js.Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUNC, "createNewUser() error", e)
      Js.Promise.reject(C.Exception.Error("createNewUser() error"))
    },_)
  } 

  module CountResult = {
    type t = {
      count: int,
    }
  }

  let verifyUserName = (user: LibWeb.Rest.User.t): Js.Promise.t<Belt.Result.t<Js.Json.t, Js.Json.t>> => {

    ResPg.Pool.query("select count(*) from users where user_name = $1", [ResPg.Pg.Query.string(user.userName)])  
    -> Js.Promise.then_((result: ResPg.Pg.Query.result<CountResult.t>) => {
      if result.rows[0].count > 0 {
        C.Translation.translateKey(~key="rest_create_user.user_already_exists", ())
        -> Js.Promise.then_(message => {
          Js.Promise.resolve(Belt.Result.Error(LibWeb.Rest.Reply.encode(~ok=false, ~err="user_already_exists", ~message=message, ())))
        }, _)
      } else {
        createNewUser(user)
      }
    },_) 
    -> Js.Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUNC, "verifyUserName() error", e)
      Js.Promise.reject(C.Exception.Error("verifyUserName() error"))
    },_)
  }


  let verifyEmail = (user: LibWeb.Rest.User.t): Js.Promise.t<Belt.Result.t<Js.Json.t, Js.Json.t>> => {
    ResPg.Pool.query("select count(*) from users where email = $1", [ResPg.Pg.Query.string(user.userEmail)])  
    -> Js.Promise.then_((result: ResPg.Pg.Query.result<CountResult.t>) => {
      if (result.rows[0].count > 0) {
        C.Translation.translateKey(~key="rest_create_user.email_already_exists", ())
         -> Js.Promise.then_((message) => {
          Js.Promise.resolve(Belt.Result.Error(LibWeb.Rest.Reply.encode(~ok=false, ~err="email_already_exists", ~message=message, ())))
        }, _)
          } else {
            verifyUserName(user)
          }
        },_) 
    -> Js.Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUNC, "verifyEmail() error", e)
      Js.Promise.reject(C.Exception.Error("verifyEmail() error"))
    },_)
  }

  switch ResExpress.Request.getJsonBody(req) {
  | Ok(body) => 
    switch LibWeb.Rest.Request.decodeUser(body) {
    | Some(user) =>
      verifyEmail(user) 
      -> Js.Promise.then_((result) => {
        switch result {
        | Belt.Result.Ok(reply) => Js.Promise.resolve(ResExpress.Response.sendJson(res, reply))
        | Belt.Result.Error(reply) => Js.Promise.resolve(ResExpress.Response.sendJson(res, reply))
        } 
      }, _)
      -> Js.Promise.catch((e) => {
        LibWeb.Logger.errorE(cFILE, cFUNC, "verifyEmail() error", e)
        ResExpress.Response.status(res, 500) 
        Js.Promise.resolve(ResExpress.Response.sendJson(res, LibWeb.Rest.Reply.encode(~ok=false, ~err="error", ())))
      },_)
    | None =>
        ResExpress.Response.status(res, 400) 
        Js.Promise.resolve(ResExpress.Response.sendJson(res, LibWeb.Rest.Reply.encode(~ok=false, ~err="could not json decode payload", ())))
    }
  | Error(reply) => 
      ResExpress.Response.status(res, 400) 
      Js.Promise.resolve(ResExpress.Response.sendJson(res, reply))
  }

})
