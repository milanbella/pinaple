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

let client = (): Js.Promise.t<(Pg.Client.t, Pg.Pool.done)> => {
  let cFUNC = "client()"
  Js.Promise.make((~resolve, ~reject) => {
    Pg.Pool.connect(pool, (err, client, done) => {
      switch err {
      | Some(e) =>
        LibWeb.Logger.errorE(cFILE, cFUNC, `error, Pg.Pool.connect() failed`, e)
        done()
        reject(. PoolConnectError)
      | None => 
        resolve(. (client, done))
      }
    })
  })
} 

let query = (queryStr: string, params: array<Pg.Query.param>): Js.Promise.t<Pg.Query.result<'a>> => {
  let cFUNC = "query()"
  Js.Promise.make((~resolve, ~reject) => {
    Pg.Pool.connect(pool, (err, client, done) => {
      switch err {
      | Some(e) =>
        LibWeb.Logger.errorE(cFILE, cFUNC, `error, Pg.Pool.connect() failed, failed query: ${queryStr}`, e)
        done()
        reject(. PoolConnectError)
      | None => 
        Pg.Client.query(client, queryStr, params, (err, result) => {
          switch err {
          | Some(e) => 
            LibWeb.Logger.errorE(cFILE, cFUNC, `error, Pg.Client.query() failed, failed query: ${queryStr}`, e)
            done()
            reject(. QueryError)
          | None => 
            done()
            resolve(. result) 
          }
        })
      }
    })
  })
} 


let connect = (cb: (option<Js.Exn.t>, Pg.Client.t, Pg.Pool.done) => unit): unit =>  {
  Pg.Pool.connect(pool, cb)
}

