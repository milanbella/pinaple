type tRegisterOptions = {
  required: option<bool>,
  min: option<int>,
  max: option<int>,
  minLength: option<int>,
  maxLength: option<int>,
  pattern: option<Js.Re.t>,
}

let makeRegisterOptions = (
  ~required: option<bool> = ?, 
  ~min: option<int> = ?, 
  ~max: option<int> = ?, 
  ~minLength: option<int> = ?,  
  ~maxLength: option<int> = ?, 
  ~pattern: option<Js.Re.t> = ?, 
  ()): tRegisterOptions => {
  {
    required: required,
    min: min,
    max: max,
    minLength: minLength,
    maxLength: maxLength,
    pattern: pattern
  }
} 

type tRegisterResult = {
  ref: ReactDOM.Ref.callbackDomRef 
}

module Error = {
  type t = {
    "type": string 
  }
}

type tRegister = {
  onChange:  ReactEvent.Form.t => unit,
  onBlur: ReactEvent.Focus.t => unit,
  ref: ReactDOM.Ref.callbackDomRef,
  name: string,
}

type tOnSubmit = ReactEvent.Form.t => unit

type tUseForm = {
  register: (. string, tRegisterOptions) => tRegister,
  handleSubmit: (. ~dataHandler: (~data: Js.Json.t, ~event: ReactEvent.Form.t) => unit) => tOnSubmit, 
  watch: unit,
  errors: Js.null_undefined<Js.Dict.t<Error.t>>
}

@bs.module("react-hook-form") external useForm: unit => tUseForm = "useForm"

