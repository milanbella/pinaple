// This is useTranslation() hook isnspired by https://react.i18next.com/latest/usetranslation-hook 
let cFILE = "C_translate.res"

let modulesRootPath = "locales"

let fetchModule = (lang: string, moduleName: string): Js.Promise.t<string> => {
  let cFUNC = "fetchModule()"

  let path = `${modulesRootPath}/${lang}/${moduleName}.json`
  try {
    let txt = ResNode.Node.Fs.readFileSync(path, "utf8")
    Js.Promise.resolve(txt)
  } catch {
  | Js.Exn.Error(obj) =>
    switch Js.Exn.message(obj) {
    | Some(m) => 
      LibWeb.Logger.errorE(cFILE, cFUNC, `error while reading form file: ${m}`, obj)
      Js.Promise.reject(C_exception.BAD_FILE)
    | None =>
      LibWeb.Logger.error(cFILE, cFUNC, "error while reading form file")
      Js.Promise.reject(C_exception.BAD_FILE)
    }
  | _ =>
    LibWeb.Logger.error(cFILE, cFUNC, "error while reading form file")
    Js.Promise.reject(C_exception.BAD_FILE)
  }
}

let translateKey = LibWeb.Translation.makeTranslation(fetchModule)
