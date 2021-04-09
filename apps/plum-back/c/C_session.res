type t

type cookieOptions = {
  maxAge: option<int>,
  secure: option<bool>,
  sameSite: option<bool>,
}

@bs.get external cookies: C_request.t => Js.Json.t = "cookies"
@bs.send external cookie: (C_response.t, string,  string, cookieOptions) => unit = "cookie"
