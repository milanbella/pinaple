let cFILE = "Cf_rest.res"

type t = {
  message: string,
  data: string
}

type e = {
  err: string,
  message: string
}

let otos = (o: option<string>): string => {
  switch(o) {
  | Some(s) => s
  | None => ""
  }
} 

let replyToData = (r: Rest.Reply.t): t => {
  {message: otos(r.message), data: otos(r.data)}
}

let replyToError = (r: Rest.Reply.t): e => {
  {err: otos(r.err), message: otos(r.message)}
}

let fetch = (url: string, init: Fetch.RequestInit.t): Js.Promise.t<Belt.Result.t<t, e>> => {
  let cFUNC = "fetch()"
  Fetch.fetchWithInit(url, init)
  -> Js.Promise.then_((response) => {
    if Fetch.Response.ok(response) {
      Fetch.Response.text(response) 
      -> Js.Promise.then_((txt) => {
          let reply = LibWeb.Rest.Reply.decode(~reply=txt, ());
          switch reply {
          | Some(r) =>
            if !r.ok {
              Js.Promise.resolve(Belt.Result.Error(replyToError(r)))
            } else {
              Js.Promise.resolve(Belt.Result.Ok(replyToData(r)))
            }
          | None => 
            LibWeb.Logger.error(cFILE, cFUNC, "LibWeb.Rest.Reply.decode() failed")
            Js.Promise.resolve(Belt.Result.Error({err: "error", message: "error"}))
          }
        }, _)
    } else {
      let status = Js.Int.toString(Fetch.Response.status(response));
      Fetch.Response.text(response) 
      -> Js.Promise.then_((txt) => {
        LibWeb.Logger.error(cFILE, cFUNC, `calling /api/create_user failed, http status: ${status}, body: ${txt}`)
        Js.Promise.resolve(Belt.Result.Error({err: "error", message: ""}))
      }, _)
    }
  }, _)
  -> Js.Promise.catch((err) => {
    LibWeb.Logger.errorE(cFILE, cFUNC, `calling ${url} failed`, err)
    Js.Promise.resolve(Belt.Result.Error(({err: "error", message: ""})))
  }, _)
}

/*
let post = (url: string, body: string): Js.Promise.t<Belt.Result.t<t, e>> => {
  let init = Fetch.RequestInit.make(
    ~method_=Post,
    ~body = Fetch.BodyInit.make(body),
    ()
  )
  fetch(url, init)
}
*/

let post = (url: string, body: Js.Json.t): Js.Promise.t<Belt.Result.t<t, e>> => {
  let init = Fetch.RequestInit.make(
    ~method_=Post,
    ~headers = Fetch.HeadersInit.makeWithArray([("Content-Type", "application/json; charset=utf-8")]), 
    ~body = Fetch.BodyInit.make(Js.Json.stringify(body)),
    ()
  )
  fetch(url, init)
}
