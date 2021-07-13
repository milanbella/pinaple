let cFILE = "User.res"

let apiCreateUser = (payload: Js.Json.t): Js.Promise.t<T.tReply<unit>> => {
  let cFUN = "apiCreateUser()";

  let createNewUser = (user: LibWeb.Rest.User.t): Js.Promise.t<T.tReply<unit>>  => {
    ResPg.Pool.query("insert into users(id, user_name, user_email, password) values($1, $2, $3, $4)", [ResPg.Pg.Query.string(ResUuid.Uuid.id()), ResPg.Pg.Query.string(user.userName), ResPg.Pg.Query.string(user.userEmail), ResPg.Pg.Query.string(ResCrypto.Crypto.sha256(user.password))])  
    -> Js.Promise.then_((_) => {
      Js.Promise.resolve(Belt.Result.Ok(()))
    },_) 
    -> Js.Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUN, "createNewUser() error", e)
      Js.Promise.resolve(Belt.Result.Error({T.Error.err: "error", message: "error"}))
    },_)
  } 

  module CountResult = {
    type t = {
      count: int,
    }
  }

  let verifyUserName = (user: LibWeb.Rest.User.t): Js.Promise.t<T.tReply<unit>> => {

    ResPg.Pool.query("select count(*) from users where user_name = $1", [ResPg.Pg.Query.string(user.userName)])  
    -> Js.Promise.then_((result: ResPg.Pg.Query.result<CountResult.t>) => {
      if result.rows[0].count > 0 {
          Js.Promise.resolve(Belt.Result.Error({T.Error.err: "user_already_exists", message: "user already exists"}))
      } else {
        Js.Promise.resolve(Belt.Result.Ok(()))
      }
    },_) 
    -> Js.Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUN, "verifyUserName() error", e)
      Js.Promise.resolve(Belt.Result.Error({T.Error.err: "error", message: "error"}))
    },_)
  }

  let verifyEmail = (user: LibWeb.Rest.User.t): Js.Promise.t<T.tReply<unit>> => {
    ResPg.Pool.query("select count(*) from users where user_email = $1", [ResPg.Pg.Query.string(user.userEmail)])  
    -> Js.Promise.then_((result: ResPg.Pg.Query.result<CountResult.t>) => {
        if (result.rows[0].count > 0) {
          Js.Promise.resolve(Belt.Result.Error({T.Error.err: "email_already_exists", message: "email already exists"}))
        } else {
          Js.Promise.resolve(Belt.Result.Ok(()))
        }
      },_) 
    -> Js.Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUN, "verifyEmail() error", e)
      Js.Promise.resolve(Belt.Result.Error({T.Error.err: "error", message: "error"}))
    },_)
  }

  switch LibWeb.Rest.Request.decodeUser(payload) {
  | Some(user) =>
    verifyEmail(user)
    -> Js.Promise.then_((result) => {
        switch result {
        | Ok(_) => verifyUserName(user)
          -> Js.Promise.then_((result) => {
            switch result {
            | Ok(_) => createNewUser(user)
            | Error(_) => Js.Promise.resolve(result) 
            }
          }, _)
        | Error(_) => Js.Promise.resolve(result)
        }
      }, _)
  | None =>
    Js.Promise.resolve(Belt.Result.Error({T.Error.err: "could_not_parse_user", message: "could not parse user"}))
  }
}
