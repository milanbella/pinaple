import '../styles/main.css'
//import 'tailwindcss/tailwind.css'

import { appWithTranslation } from 'next-i18next';

// Note:
// Just renaming $$default to ResApp alone
// doesn't help FastRefresh to detect the
// React component, since an alias isn't attached
// to the original React component function name.
import ResApp from "../src/App.bs.js"

// Note:
// We need to wrap the make call with
// a Fast-Refresh conform function name,
// (in this case, uppercased first letter)
//
// If you don't do this, your Fast-Refresh will
// not work!
export default appWithTranslation(function App(props) {
  return <ResApp {...props}/>;
})
