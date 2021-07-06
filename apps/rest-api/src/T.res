module Error = {
  type t = {
    err: string,
    message: string,
  }
}
type tReply<'a> = Belt.Result.t<'a, Error.t> 

