exception ERROR_EXN

let apiCallToPromise = (call: Js.Json.t => Promise.t<RestApi.T.tReply<'a>>): (Js.Json.t => Promise.t<RestApi.T.tReply<'a>>)   => {
  // Return rejectd promise in case of error result 
  (payload: Js.Json.t) => {
    call(payload)
    -> Promise.then((result: RestApi.T.tReply<'a>) => {
      switch result {
      | Ok(_) => Promise.resolve(result)
      | Error(v) => 
        Js.Console.error2("error", v)
        Promise.reject(ERROR_EXN)
      }
    })
  }
}

let apiCreateUser = apiCallToPromise(User.apiCreateUser)
