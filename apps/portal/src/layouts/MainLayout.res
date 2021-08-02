module Link = Next.Link

module Navigation = {
  @react.component
  let make = () =>
    <nav className="p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm">
      <div className="flex w-2/3 justify-end">
        <Link href="/"> <a className="px-3"> {React.string("Home")} </a> </Link>
        <Link href="/examples"> <a className="px-3"> {React.string("Examples")} </a> </Link>
        <Link href="/register_user"> <a className="px-3"> {React.string("Register")} </a> </Link>
        <a
          className="px-3 font-bold"
          target="_blank"
          href="https://github.com/ryyppy/nextjs-default">
          {React.string("Github")}
        </a>
      </div>
    </nav>
}

@react.component
let make = (~children) => {
  let minWidth = ReactDOM.Style.make(~minWidth="20rem", ())
  <div style=minWidth className="flex lg:justify-center">
    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation /> <main className="mt-4 mx-4"> children </main>
    </div>
  </div>
}
