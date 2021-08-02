@react.component
let make = (~msgKey: string) => {

  let (isDisplayed, setIsDisplayed) = React.useState(() => false)
  let {t, _} = ResI18next.M.useTranslation()

  
  let show = () => {
    if (isDisplayed) {
      <article className="">
        <div className="">
           <button className="" ariaLabel="" onClick={_ => setIsDisplayed(_ => false)}></button>
        </div>
        <div className="">
          {React.string(t(. msgKey))}
        </div>
      </article>
    } else {
      React.string("")
    }
  }

  <div>
    {show()}
  </div>
}
