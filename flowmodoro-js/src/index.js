import React from "react";
import ReactDOM from "react-dom";

import "./reset.css";
import App from "./components/App";
import * as serviceWorker from "./models/serviceWorker";

import "./assets/fonts/square_sans_serif.ttf";

ReactDOM.render(
  <React.StrictMode>
    <App></App>
  </React.StrictMode>,
  document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
