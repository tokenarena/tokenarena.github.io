import React from "react";
import ReactDOM from "react-dom";

import { Provider } from 'react-redux';
import { HashRouter, Route, Switch } from "react-router-dom";
import { createStore, applyMiddleware, compose, combineReducers } from 'redux';

import indexRoutes from "routes/index.jsx";

import "bootstrap/dist/css/bootstrap.min.css";
import "./assets/css/animate.min.css";
import "./assets/sass/light-bootstrap-dashboard.css?v=1.2.0";
import "./assets/css/demo.css";
import "./assets/css/pe-icon-7-stroke.css";

import bondedTokenReducer from './store/reducer/bondedToken';


const store = createStore(bondedTokenReducer, window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__())

ReactDOM.render(
  <Provider store={store}>
  <HashRouter>
    <Switch>
      {indexRoutes.map((prop, key) => {
        return <Route to={prop.path} component={prop.component} key={key} />;
      })}
    </Switch>
  </HashRouter>
  </Provider>,
  document.getElementById("root")
);
