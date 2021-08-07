// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Http$LibWeb = require("lib-web/src/Http.bs.js");
var Json_decode = require("@glennsl/bs-json/src/Json_decode.bs.js");
var Json_encode = require("@glennsl/bs-json/src/Json_encode.bs.js");
var ErrorMessage = require("./ErrorMessage.bs.js");
var NextI18next = require("next-i18next");
var Logger$LibWeb = require("lib-web/src/Logger.bs.js");
var ReactHookForm = require("react-hook-form");
var Caml_js_exceptions = require("rescript/lib/js/caml_js_exceptions.js");
var HookForm$ResHookForm = require("res-hookForm/src/hookForm.bs.js");

var cFILE = "Login_userNamePasswordForm.res";

var componentName = "Login_userNamePasswordForm";

function registerUser(user) {
  var encodeUser = function (param) {
    return Json_encode.object_({
                hd: [
                  "userName",
                  user.userName
                ],
                tl: {
                  hd: [
                    "userEmail",
                    user.userEmail
                  ],
                  tl: {
                    hd: [
                      "password",
                      user.password
                    ],
                    tl: /* [] */0
                  }
                }
              });
  };
  return Http$LibWeb.post("/api/create_user", encodeUser(undefined));
}

function Login_userNamePasswordForm(Props) {
  var cFUNC = "make()";
  var decode = function (j) {
    try {
      return {
              userName: Json_decode.field("userName", Json_decode.string, j),
              userEmail: Json_decode.field("userEmail", Json_decode.string, j),
              password: Json_decode.field("password", Json_decode.string, j),
              passwordVerify: Json_decode.field("passwordVerify", Json_decode.string, j)
            };
    }
    catch (raw_msg){
      var msg = Caml_js_exceptions.internalToOCamlException(raw_msg);
      if (msg.RE_EXN_ID === Json_decode.DecodeError) {
        Logger$LibWeb.error(cFILE, cFUNC, "decode error: " + msg._1);
        return ;
      }
      throw msg;
    }
  };
  var match = NextI18next.useTranslation();
  var t = match.t;
  var match$1 = ReactHookForm.useForm();
  var errors = match$1.errors;
  var register = match$1.register;
  var match$2 = React.useState(function () {
        return "";
      });
  var setErrorMsg = match$2[1];
  var handleSubmitData = function (data, e) {
    e.preventDefault();
    console.log("@@@@@@@@@@@@@@@@@@@@@ cp 500: handleSubmitData()");
    console.log(data);
    var formData = decode(data);
    if (formData !== undefined) {
      if (formData.password !== formData.passwordVerify) {
        return Curry._1(setErrorMsg, (function (param) {
                      return "passwords do not match";
                    }));
      }
      var user_userName = formData.userName;
      var user_userEmail = formData.userEmail;
      var user_password = formData.password;
      var user = {
        userName: user_userName,
        userEmail: user_userEmail,
        password: user_password
      };
      var __x = registerUser(user);
      var __x$1 = __x.then(function (res) {
            if (res.TAG === /* Ok */0) {
              return Promise.resolve(undefined);
            }
            var match = res._0;
            var message = match.message;
            var err = match.err;
            Curry._1(setErrorMsg, (function (param) {
                    return err + ": " + message;
                  }));
            return Promise.resolve(undefined);
          });
      __x$1.catch(function (err) {
            Logger$LibWeb.errorE(cFILE, cFUNC, "registerUser() failed", err);
            return Promise.resolve(undefined);
          });
      return ;
    } else {
      Logger$LibWeb.error(cFILE, "handleSubmitData()", "FormData.decode() failed");
      return Curry._1(setErrorMsg, (function (param) {
                    return "error";
                  }));
    }
  };
  var showError = function (field, vtype, msg, className) {
    if (errors == null) {
      return "";
    }
    var err = Js_dict.get(errors, field);
    if (err !== undefined && Caml_option.valFromOption(err).type === vtype) {
      console.log("error: " + field);
      return React.createElement("span", {
                  className: className
                }, t(msg));
    } else {
      return "";
    }
  };
  var hfUserName = register("userName", HookForm$ResHookForm.makeRegisterOptions(true, undefined, undefined, undefined, undefined, undefined, undefined));
  var hfUserEmail = register("userEmail", HookForm$ResHookForm.makeRegisterOptions(true, undefined, undefined, undefined, undefined, Caml_option.some(/\w+@\w+/), undefined));
  var hfPassword = register("password", HookForm$ResHookForm.makeRegisterOptions(true, undefined, undefined, undefined, undefined, undefined, undefined));
  var hfPasswordVerify = register("passwordVerify", HookForm$ResHookForm.makeRegisterOptions(true, undefined, undefined, undefined, undefined, undefined, undefined));
  return React.createElement("div", {
              className: "w-full flex justify-center"
            }, React.createElement("form", {
                  className: "md:shadow-lg md:rounded md:bg-gray-100 px-8 pt-8 pb-8 mb-4 md:mt-8 flex-grow md:flex-grow-0",
                  onSubmit: match$1.handleSubmit(handleSubmitData)
                }, React.createElement("div", {
                      className: "font-bold text-2xl flex pb-4"
                    }, t(componentName + ".New user registration")), React.createElement("div", {
                      className: "mb-8 mt-4"
                    }, React.createElement("label", {
                          className: "block text-gray-500 text-sm font-bold mb-2"
                        }, t(componentName + ".user name"), React.createElement("span", {
                              className: "text-red-500"
                            }, "*")), React.createElement("input", {
                          ref: hfUserName.ref,
                          className: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline",
                          name: hfUserName.name,
                          type: "text",
                          onBlur: hfUserName.onBlur,
                          onChange: hfUserName.onChange
                        }), showError("userName", "required", "user name is required", "text-red-500")), React.createElement("div", {
                      className: "mb-8"
                    }, React.createElement("label", {
                          className: "block text-gray-500 text-sm font-bold mb-2"
                        }, t(componentName + ".email")), React.createElement("input", {
                          ref: hfUserEmail.ref,
                          className: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline",
                          name: hfUserEmail.name,
                          type: "text",
                          onBlur: hfUserEmail.onBlur,
                          onChange: hfUserEmail.onChange
                        }), showError("userEmail", "required", "user email is required", "text-red-500"), showError("userEmail", "pattern", "wrong format", "text-red-500")), React.createElement("div", {
                      className: "mb-8"
                    }, React.createElement("label", {
                          className: "block text-gray-500 text-sm font-bold mb-2"
                        }, t(componentName + ".password")), React.createElement("input", {
                          ref: hfPassword.ref,
                          className: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline",
                          name: hfPassword.name,
                          type: "password",
                          onBlur: hfPassword.onBlur,
                          onChange: hfPassword.onChange
                        }), showError("password", "required", "password is required", "text-red-500")), React.createElement("div", {
                      className: "mb-8"
                    }, React.createElement("label", {
                          className: "block text-gray-500 text-sm font-bold mb-2"
                        }, t(componentName + ".passwordVerify")), React.createElement("input", {
                          ref: hfPasswordVerify.ref,
                          className: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline",
                          name: hfPasswordVerify.name,
                          type: "passwordVerify",
                          onBlur: hfPasswordVerify.onBlur,
                          onChange: hfPasswordVerify.onChange
                        }), showError("passwordVerify", "required", "please retype password", "text-red-500")), React.createElement(ErrorMessage.make, {
                      msgKey: "passwords do not match",
                      className: ""
                    }), React.createElement("div", {
                      className: "flex justify-center pt-4 mt-6"
                    }, React.createElement("button", {
                          className: "bg-blue-500 hover:bg-blue-700 text-white font-bol px-4 py-2 rounded focus:outline-none focus:ring-1 focus:ring-blue-700"
                        }, t(componentName + ".submit")))));
}

var make = Login_userNamePasswordForm;

exports.cFILE = cFILE;
exports.componentName = componentName;
exports.registerUser = registerUser;
exports.make = make;
/* react Not a pure module */
