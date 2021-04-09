let router = C.Router.router()

let cFILE = "Routes.res"

let createUser = C.Router.post(router, "/create_user", (req, res) => {
  let cFUNC = "createUser()"

  let createNewUser = (user: LibWeb.Rest.User.t): Js.Promise.t<Belt.Result.t<Js.Json.t, Js.Json.t>>  => {
    Js.Console.log("@@@@@@@@@@@@@@@@@@@@@@@@@ cp 100") //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Js.Console.log(user) //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    C.Pool.query("insert ino users(id, user_name, user_email, passowrd) values(?, ?, ?, ?)", [C.Pg.Query.string(C.Uuid.id()), C.Pg.Query.string(user.userName), C.Pg.Query.string(user.userEmail), C.Pg.Query.string(C.Crypto.sha256(user.userEmail))])  
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
    Js.Console.log("@@@@@@@@@@@@@@@@@@@@@@@@@ cp 90") //@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    C.Pool.query("select count(*) from users where user_name = ?", [C.Pg.Query.string(user.userName)])  
    -> Js.Promise.then_((result: C.Pg.Query.result<CountResult.t>) => {
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
    C.Pool.query("select count(*) from users where email = ?", [C.Pg.Query.string(user.userEmail)])  
    -> Js.Promise.then_((result: C.Pg.Query.result<CountResult.t>) => {
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

  switch C.Request.getJsonBody(req) {
  | Ok(body) => 
    switch LibWeb.Rest.Request.decodeUser(body) {
    | Some(user) =>
      verifyEmail(user) 
      -> Js.Promise.then_((result) => {
        switch result {
        | Belt.Result.Ok(reply) => Js.Promise.resolve(C.Response.sendJson(res, reply))
        | Belt.Result.Error(reply) => Js.Promise.resolve(C.Response.sendJson(res, reply))
        } 
      }, _)
      -> Js.Promise.catch((e) => {
        LibWeb.Logger.errorE(cFILE, cFUNC, "verifyEmail() error", e)
        C.Response.status(res, 500) 
        Js.Promise.resolve(C.Response.sendJson(res, LibWeb.Rest.Reply.encode(~ok=false, ~err="error", ())))
      },_)
    | None =>
        C.Response.status(res, 400) 
        Js.Promise.resolve(C.Response.sendJson(res, LibWeb.Rest.Reply.encode(~ok=false, ~err="could not json decode payload", ())))
    }
  | Error(reply) => 
      C.Response.status(res, 400) 
      Js.Promise.resolve(C.Response.sendJson(res, reply))
  }

})
