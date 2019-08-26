// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import LiveSocket from "phoenix_live_view"

// Thx Chris https://elixir-lang.slack.com/archives/CD594E0UU/p1566845452216100
let Hooks = {}
Hooks.UsernameCookie = {
  setUsernameCookie(val){
    document.cookie = `pokershirt_username=${encodeURIComponent(val)};path=/;max-age=31536000`
  },
  mounted(){ this.setUsernameCookie(this.el.value) },
  updated(){ this.setUsernameCookie(this.el.value) }
}

let liveSocket = new LiveSocket("/live", {hooks: Hooks})
liveSocket.connect()
