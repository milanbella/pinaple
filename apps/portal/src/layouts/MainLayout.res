module Link = Next.Link

module Navigation = {
  @react.component
  let make = () =>
    <nav className="bg-indigo-600 flex ext-sm text-white flex-col items-center md:flex-row md:justify-around lg:justify-end">
      <div className="hover:bg-blue-600 h-14 flex items-center justify-center w-full md:w-auto"><Link href="/"> <a className="mx-3"> {React.string("Home")} </a> </Link></div>
      <div className="hover:bg-blue-600 h-14 flex items-center justify-center w-full md:w-auto"><Link href="/examples"> <a className="mx-3">  {React.string("Examples")}  </a> </Link> </div>
      <div className="hover:bg-blue-600 h-14 flex items-center justify-center w-full md:w-auto"><Link href="/register_user"> <a className="mx-3">  {React.string("Register")}  </a> </Link></div>
	  <div className="hover:bg-blue-600 h-14 flex items-center justify-center w-full md:w-auto"><a className="font-bold mx-3" target="_blank" href="https://github.com/ryyppy/nextjs-default"> {React.string("Github")} </a></div>
    </nav>
}

@react.component
let make = (~children) => {
  let minWidth = ReactDOM.Style.make(~minWidth="20rem", ())
  <div style=minWidth className="flex lg:justify-center bg-gray-100">
    <div className="w-full text-gray-900 font-base">
      <Navigation /> <main className="mt-4 mx-4"> children </main>
    </div>
  </div>
}
