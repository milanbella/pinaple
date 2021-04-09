type t

let cFILE = "Cb_request.res"

//@bs.get external body: t => string = "body"
@bs.get external body: t => Js.Json.t = "body"

let getJsonBody = (req): Belt.Result.t<Js.Json.t, Js.Json.t> => {
  Belt.Result.Ok(body(req))
}

