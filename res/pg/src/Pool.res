let cFILE = "Pool.res"

exception PoolConnectError
exception QueryError

let pool = Pg.Pool.new(~options=Pg.Pool.makeConnectionOptions(~host="localhost", ~user="auth", ~password="auth", ()),())

Pg.Pool.on(pool, "error", (err) => {
  let cFUN = "Pg.Pool.on()"
  LibWeb.Logger.errorE(cFILE, cFUN, "on error", err)
})

/*
let query = (queryStr: string, params: array<Pg.Query.param>): Js.Promise.t<Pg.Query.result<'a>> => {
  let cFUNC = "query()"
  Js.Promise.make((~resolve, ~reject) => {
    Pg.Pool.query(pool, queryStr, params, (err, result) => {
      switch err {
      | Some(e) => 
        LibWeb.Logger.errorE(cFILE, cFUNC, `error, query: ${queryStr}`, e)
        reject(. QueryError)
      | None => resolve(. result) 
      }
    })
  })
} 
*/

let client = (): Promise.t<Belt.Result.t<(Pg.Client.t, Pg.Pool.done), Js.Exn.t>> => {
  let cFUNC = "client()"
  Promise.make((resolve, _reject) => {
    Pg.Pool.connect(pool, (err, client, done) => {
      switch Js.Nullable.toOption(err) {
      | None => resolve(. Ok((client, done)))
      | Some(err) =>
        LibWeb.Logger.errorE(cFILE, cFUNC, `error, Pg.Pool.connect() failed`, err)
        done()
        resolve(. Error(err))
      }
    })
  })
} 

let query = (queryStr: string, params: array<Pg.Query.param>): Promise.t<Belt.Result.t<Pg.Query.result<'a>, Js.Exn.t>> => {
  let cFUNC = "query()"
  Promise.make((resolve, _reject) => {
    Pg.Pool.connect(pool, (err, client, done) => {
      switch Js.Nullable.toOption(err) {
      | Some(err) =>
        LibWeb.Logger.errorE(cFILE, cFUNC, `error, Pg.Pool.connect() failed, failed query: ${queryStr}`, err)
        Pg.Client.end(client)
        done()
        resolve(. Error(err))
      | None =>
        Pg.Client.query(client, queryStr, params, (err, result) => {
          switch Js.Nullable.toOption(err) {
          | Some(err) =>
            LibWeb.Logger.errorE(cFILE, cFUNC, `error, Pg.Client.query() failed, failed query: ${queryStr}`, err)
            Pg.Client.end(client)
            done()
            resolve(. Error(err))
          | None =>
            Pg.Client.end(client)
            done()
            resolve(. Ok(result)) 
          }
        })
      }
    })
  })
} 


let connect = (cb: (Js.Nullable.t<Js.Exn.t>, Pg.Client.t, Pg.Pool.done) => unit): unit =>  {
  Pg.Pool.connect(pool, cb)
}

