// see https://github.com/isaachinman/next-i18next

type tI18n

type tUseTranslation = {
  t: (. string) => string,
  i18n: tI18n 
 
}
//@module("next-i18next") external useTranslation: unit => (string => React.element, t)  = "useTranslation"
@module("next-i18next") external useTranslation: unit => tUseTranslation  = "useTranslation"

let {t, i18n} = useTranslation()
let a = t(. "foo")
let b = i18n

