let cFILE = "Login_userNamePasswordForm.res"
let componentName = "Login_userNamePasswordForm"

let registerUser = (user: LibWeb.Rest.User.t): Js.Promise.t<Belt.Result.t<LibWeb.Http.t, LibWeb.Http.e>> => {
  let encodeUser = () => {
    open Json.Encode
    object_(list{
      ("userName", string(user.userName)),
      ("userEmail", string(user.userEmail)),
      ("password", string(user.password))
    })
  }
  LibWeb.Http.post("/api/create_user", encodeUser()) 
}


@react.component
let make = () => {
  let cFUNC = "make()"
  /*
  let t = ResI18next.M.useTranslation()
  <div> {React.string("registration Hello hello hello!")} </div>
  */
  module FormData = {
    type t = {
      userName: string,
      userEmail: string,
      password: string,
      passwordVerify: string
    }

    let decode = (j: Js.Json.t): option<t> => {
      try {
        open Json.Decode
        Some({
          userName: field("userName", string, j),
          userEmail: field("userEmail", string, j),
          password: field("password", string, j),
          passwordVerify: field("passwordVerify", string, j)
        })
      } catch {
      | Json.Decode.DecodeError(msg) =>
        LibWeb.Logger.error(cFILE, cFUNC,`decode error: ${msg}`)
        None
      }
    }
  }

  let {t, _} = ResI18next.M.useTranslation()
  let {ResHookForm.HookForm.register, handleSubmit, errors} = ResHookForm.HookForm.useForm();
  

  let (_, setErrorMsg) = React.useState(() => "")

  let handleFormData = (data: FormData.t) => {
    if data.password != data.passwordVerify {
      setErrorMsg(_ => "passwords do not match");
    } else {
      let user: LibWeb.Rest.User.t = {
        userEmail: data.userEmail,
        userName: data.userName,
        password: data.password
      }
      ignore(registerUser(user)
      -> Js.Promise.then_(res => {
        switch res {
        | Belt.Result.Ok(_) => Js.Promise.resolve(())
        | Belt.Result.Error({LibWeb.Http.err, message}) => 
          setErrorMsg(_ => `${err}: ${message}`)
          Js.Promise.resolve(())
        }
      }, _)
      -> Js.Promise.catch(err => {
        LibWeb.Logger.errorE(cFILE, cFUNC, "registerUser() failed", err)
        Js.Promise.resolve(())
      }, _))
    }
  }

  let handleSubmitData = (~data: Js.Json.t, ~event as e) => {
    let cFUNC = "handleSubmitData()"
    ReactEvent.Form.preventDefault(e)
    Js.Console.log("@@@@@@@@@@@@@@@@@@@@@ cp 500: handleSubmitData()")
    Js.Console.log(data)

    let formData = FormData.decode(data); 
    switch(formData) {
    | Some(fd) => handleFormData(fd) 
    | None =>
        LibWeb.Logger.error(cFILE, cFUNC, "FormData.decode() failed")
        setErrorMsg(_ => "error");
    }
  }

  let showError = (field: string, vtype: string, msg: string) => {
    switch Js.Null_undefined.toOption(errors) {
    | Some(_errors) =>
      switch Js.Dict.get(_errors, field) {
      | Some(err) =>
          if err["type"] == vtype {
            Js.Console.log("error: " ++ field)
            <FormFieldError msg={msg} />
          } else {
            React.string("")
          }
      | None => React.string("")
      }
    | None =>  React.string("")
    }
  }

  let me = {
    "age": 5,
    "name": "Big ReScript"
  }

  let hfUserName = register(. "userName", ResHookForm.HookForm.makeRegisterOptions(~required=true, ())) 
  let hfUserEmail = register(. "userEmail", ResHookForm.HookForm.makeRegisterOptions(~required=true, ~pattern=%re("/\w+@\w+/"), ())) 
  let hfPassword = register(. "password", ResHookForm.HookForm.makeRegisterOptions(~required=true, ()))
  let hfPasswordVerify = register(. "passwordVerify", ResHookForm.HookForm.makeRegisterOptions(~required=true, ()))

  //<div className=""> <input type_="text" onChange={hfUserName.onChange} onBlur={hfUserName.onBlur} ref={ReactDOM.Ref.callbackDomRef(hfUserName.ref)} name={hfUserName.name} /> </div>

  <div className="w-full flex justify-center">
    <form className="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 w-full md:w-auto" onSubmit={handleSubmit(. ~dataHandler=handleSubmitData)}>
      <div className="font-bold flex justify-center pb-4 border-b border-color-gray-500">{React.string(t(. `${componentName}.New user registration`))}</div>
      <div className="mb-4 mt-4">
        <label className="block text-gray-500 text-sm font-bold mb-2" > {React.string(t(. `${componentName}.user name`))}</label>
        <input className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type_="text" onChange={hfUserName.onChange} onBlur={hfUserName.onBlur} ref={ReactDOM.Ref.callbackDomRef(hfUserName.ref)} name={hfUserName.name} /> 
        {showError("userName", "required", "user name is required")}
      </div>
      <div className="mb-4">
        <label className="block text-gray-500 text-sm font-bold mb-2"> {React.string(t(. `${componentName}.email`))}</label>
        <input className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type_="text" onChange={hfUserEmail.onChange} onBlur={hfUserEmail.onBlur} ref={ReactDOM.Ref.callbackDomRef(hfUserEmail.ref)} name={hfUserEmail.name} /> 
        {showError("userEmail", "required", "user email is required")}
        {showError("userEmail", "pattern", "wrong format")}
      </div>
      <div className="mb-4">
        <label className="block text-gray-500 text-sm font-bold mb-2"> {React.string(t(. `${componentName}.password`))} </label>
        <input className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type_="password" onChange={hfPassword.onChange} onBlur={hfPassword.onBlur} ref={ReactDOM.Ref.callbackDomRef(hfPassword.ref)} name={hfPassword.name} />
        {showError("password", "required", "password is required")}
      </div>
      <div className="mb-4">
        <label className="block text-gray-500 text-sm font-bold mb-2"> {React.string(t(. `${componentName}.passwordVerify`))} </label>
        <input className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type_="passwordVerify"onChange={hfPasswordVerify.onChange} onBlur={hfPasswordVerify.onBlur} ref={ReactDOM.Ref.callbackDomRef(hfPasswordVerify.ref)} name={hfPasswordVerify.name} /> 
        {showError("passwordVerify", "required", "please reatype password")}
      </div>
      <ErrorMessage msgKey={"passwords do not match"} />

      <div className="flex justify-center border-t border-color-gray-500 pt-4 mt-6">
          //<button className="bg-blue-500 hover:bg-blue-700 text-white font-bol px-4 py-2 rounded focus:outline-none focus:ring-4 focus:ring-green-500" type_="submit"> {React.string(t(. `${componentName}.submit`))} </button>
          <button className="bg-blue-500 hover:bg-blue-700 text-white font-bol px-4 py-2 rounded focus:outline-none focus:ring-1 focus:ring-blue-700" > {React.string(t(. `${componentName}.submit`))} </button>
      </div>
    </form>
  </div>
}
