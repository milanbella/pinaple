exception ERROR_EXN

let apiCreateUser = (payload: Js.Json.t): Js.Promise.t<unit> => {
  User.apiCreateUser(payload)
  -> Js.Promise.then_((result: RestApi.T.tReply<unit>) => {
    switch result {
    | Ok(v) => Js.Promise.resolve(v)
    | Error(v) => 
      Js.Console.error2("error", v)
      Js.Promise.reject(ERROR_EXN)
    }
  }, _)
}
