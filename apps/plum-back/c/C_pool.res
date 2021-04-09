let cFILE = "Pool.res"

exception QueryError

let pool = C_pg.Pool.new(~options=C_pg.Pool.makeConnectionOptions(~host="localhost", ~user="auth", ~password="auth", ()),())

C_pg.Pool.on(pool, "error", (err) => {
  let cFUN = "Pg.Pool.on()"
  LibWeb.Logger.errorE(cFILE, cFUN, "error", err)
})

let query = (queryStr: string, params: array<C_pg.Query.param>): Js.Promise.t<C_pg.Query.result<'a>> => {
  let cFUNC = "query()"
  Js.Promise.make((~resolve, ~reject) => {
    C_pg.Pool.query(pool, queryStr, params, (err, result) => {
      switch err {
      | Some(e) => 
        LibWeb.Logger.errorE(cFILE, cFUNC, `error, query: ${queryStr}`, e)
        reject(. QueryError)
      | None => resolve(. result) 
      }
    })
  })
} 

//@bs.send external connect: (t, (option<Js.Exn.t>, Client.t, done) => unit) => unit = "connect"

let connect = (cb: (option<Js.Exn.t>, C_pg.Client.t, C_pg.Pool.done) => unit): unit =>  {
  C_pg.Pool.connect(pool, cb)
}

