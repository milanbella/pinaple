module Link = Next.Link

module Navigation = {
  @react.component
  let make = () =>
    <nav className="flex ext-sm text-black flex-col items-center md:flex-row md:justify-around lg:justify-end bg-gray-100">
      <div className="hover:bg-gray-400 md:hover:bg-transparent md:border-b-4 border-transparent md:hover:border-gray-700 h-14 flex items-center justify-center w-full md:w-auto"><Link href="/"> <a className="mx-3"> {React.string("Home")} </a> </Link></div>
      <div className="hover:bg-gray-400 md:hover:bg-transparent md:border-b-4 border-transparent md:hover:border-gray-700 h-14 flex items-center justify-center w-full md:w-auto"><Link href="/examples"> <a className="mx-3">  {React.string("Examples")}  </a> </Link> </div>
      <div className="hover:bg-gray-400 md:hover:bg-transparent md:border-b-4 border-transparent md:hover:border-gray-700 h-14 flex items-center justify-center w-full md:w-auto"><Link href="/register_user"> <a className="mx-3">  {React.string("Register")}  </a> </Link></div>
    </nav>
}

@react.component
let make = (~children) => {
  <div className="flex lg:justify-center">
    <div className="w-full text-gray-900 font-base">
      <Navigation /> <main className="md:mt-4 md:mx-4"> children </main>
    </div>
  </div>
}
