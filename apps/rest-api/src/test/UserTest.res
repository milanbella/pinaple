exception ERROR_EXN

let apiCreateUser = (payload: Js.Json.t): Js.Promise.t<unit> => {
  User.apiCreateUser(payload)
  -> Js.Promise.then_((result: RestApi.T.tReply<unit>) => {
    switch result {
    | Belt.Result.Ok(v) => Js.Promise.resolve(v)
    | Belt.Result.Error(v) => 
      Js.Console.error2("error", v)
      Js.Promise.reject(ERROR_EXN)
    }
  }, _)
  /*
  -> Js.Promise.catch((v) => {
    Js.Promise.reject(v)
  })
  */

}
