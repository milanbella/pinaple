module Error = {
  type t = {
    err: string,
    message: string,
  }

  let encode = (t): Js.Json.t => {
    open Json.Encode
    object_(list{
      ("err", string(t.err)),
      ("message",string(t.message)),
    })
  }
}
type tReply<'a> = Belt.Result.t<'a, Error.t> 
