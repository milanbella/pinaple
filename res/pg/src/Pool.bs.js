// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Pg = require("pg");
var Curry = require("rescript/lib/js/curry.js");
var Pg$ResPg = require("./Pg.bs.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Logger$LibWeb = require("lib-web/src/Logger.bs.js");
var Caml_exceptions = require("rescript/lib/js/caml_exceptions.js");

var cFILE = "Pool.res";

var PoolConnectError = /* @__PURE__ */Caml_exceptions.create("Pool-ResPg.PoolConnectError");

var QueryError = /* @__PURE__ */Caml_exceptions.create("Pool-ResPg.QueryError");

var pool = new Pg.Pool(Pg$ResPg.Pool.makeConnectionOptions("localhost", undefined, undefined, "auth", "auth", undefined));

pool.on("error", (function (err) {
        return Logger$LibWeb.errorE(cFILE, "Pg.Pool.on()", "on error", err);
      }));

function query(queryStr, params) {
  return new Promise((function (resolve, reject) {
                pool.query(queryStr, params, (function (err, result) {
                        if (err !== undefined) {
                          Logger$LibWeb.errorE(cFILE, "query()", "error, query: " + queryStr, Caml_option.valFromOption(err));
                          return reject({
                                      RE_EXN_ID: QueryError
                                    });
                        } else {
                          return resolve(result);
                        }
                      }));
                
              }));
}

function client(param) {
  return new Promise((function (resolve, reject) {
                pool.connect(function (err, client, done) {
                      if (err === undefined) {
                        return resolve([
                                    client,
                                    done
                                  ]);
                      }
                      var e = Caml_option.valFromOption(err);
                      var es = Logger$LibWeb.errToStr(e);
                      Logger$LibWeb.errorE(cFILE, "client()", "error, Pg.Pool.connect() failed: " + es, e);
                      Curry._1(done, undefined);
                      return reject({
                                  RE_EXN_ID: PoolConnectError
                                });
                    });
                
              }));
}

function query1(queryStr, params) {
  var cFUNC = "query()";
  return new Promise((function (resolve, reject) {
                pool.connect(function (err, client, done) {
                      if (err !== undefined) {
                        var e = Caml_option.valFromOption(err);
                        var es = Logger$LibWeb.errToStr(e);
                        Logger$LibWeb.errorE(cFILE, cFUNC, "error, Pg.Pool.connect() failed: " + es + ", failed query: " + queryStr, e);
                        Curry._1(done, undefined);
                        return reject({
                                    RE_EXN_ID: PoolConnectError
                                  });
                      }
                      client.query(queryStr, params, (function (err, result) {
                              if (err !== undefined) {
                                var e = Caml_option.valFromOption(err);
                                var es = Logger$LibWeb.errToStr(e);
                                Logger$LibWeb.errorE(cFILE, cFUNC, "error, Pg.Client.query() failed " + es + ", failed query: " + queryStr, e);
                                Curry._1(done, undefined);
                                return reject({
                                            RE_EXN_ID: QueryError
                                          });
                              }
                              Curry._1(done, undefined);
                              return resolve(result);
                            }));
                      
                    });
                
              }));
}

function connect(cb) {
  pool.connect(cb);
  
}

exports.cFILE = cFILE;
exports.PoolConnectError = PoolConnectError;
exports.QueryError = QueryError;
exports.pool = pool;
exports.query = query;
exports.client = client;
exports.query1 = query1;
exports.connect = connect;
/* pool Not a pure module */