let cFILE = "User.res"

let apiCreateUser = (payload: Js.Json.t): Promise.t<T.tReply<unit>> => {
  let cFUN = "apiCreateUser()";

  let createNewUser = (user: LibWeb.Rest.User.t): Js.Promise.t<T.tReply<unit>>  => {
    ResPg.Pool.query("insert into users(id, user_name, user_email, password) values($1, $2, $3, $4)", [ResPg.Pg.Query.string(ResUuid.Uuid.id()), ResPg.Pg.Query.string(user.userName), ResPg.Pg.Query.string(user.userEmail), ResPg.Pg.Query.string(ResCrypto.Crypto.sha256(user.password))])  
    -> Promise.then((_) => {
      Promise.resolve(Ok(()))
    }) 
    -> Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUN, "createNewUser() error", e)
      Promise.resolve(Error({T.Error.err: "error", message: "error"}))
    })
  } 

  module CountResult = {
    type t = {
      count: int,
    }
  }

  let verifyUserName = (user: LibWeb.Rest.User.t): Promise.t<T.tReply<unit>> => {

    ResPg.Pool.query("select count(*) from users where user_name = $1", [ResPg.Pg.Query.string(user.userName)])  
    -> Promise.then((_result: Belt.Result.t<ResPg.Pg.Query.result<CountResult.t>, Js.Exn.t>) => {
      switch _result {
      | Ok(result) => 
        if result.rows[0].count > 0 {
            Promise.resolve(Error({T.Error.err: "user_already_exists", message: "user already exists"}))
        } else {
          Promise.resolve(Ok(()))
        }
      | Error(e) =>
        LibWeb.Logger.errorE(cFILE, cFUN, "verifyUserName() error", e)
        Promise.resolve(Error({T.Error.err: "error", message: "error"}))
      }
    }) 
    -> Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUN, "verifyUserName() error", e)
      Promise.resolve(Error({T.Error.err: "error", message: "error"}))
    })
  }

  let verifyEmail = (user: LibWeb.Rest.User.t): Promise.t<T.tReply<unit>> => {
    ResPg.Pool.query("select count(*) from users where user_email = $1", [ResPg.Pg.Query.string(user.userEmail)])  
    -> Promise.then((_result: Belt.Result.t<ResPg.Pg.Query.result<CountResult.t>, Js.Exn.t>) => {
      switch _result {
      | Ok(result) =>
        if (result.rows[0].count > 0) {
          Promise.resolve(Error({T.Error.err: "email_already_exists", message: "email already exists"}))
        } else {
          Promise.resolve(Ok(()))
        }
      | Error(e) =>
        LibWeb.Logger.errorE(cFILE, cFUN, "verifyEmail() error", e)
        Promise.resolve(Error({T.Error.err: "error", message: "error"}))
      }
    }) 
    -> Promise.catch((e) => {
      LibWeb.Logger.errorE(cFILE, cFUN, "verifyEmail() error", e)
      Promise.resolve(Error({T.Error.err: "error", message: "error"}))
    })
  }

  switch LibWeb.Rest.Request.decodeUser(payload) {
  | Some(user) =>
    verifyEmail(user)
    -> Promise.then((result) => {
        switch result {
        | Ok(_) => verifyUserName(user)
          -> Promise.then((result) => {
            switch result {
            | Ok(_) => createNewUser(user)
            | Error(_) => Promise.resolve(result) 
            }
          })
        | Error(_) => Promise.resolve(result)
        }
      })
  | None =>
    Promise.resolve(Error({T.Error.err: "could_not_parse_user", message: "could_not_parse_user"}))
  }
}
