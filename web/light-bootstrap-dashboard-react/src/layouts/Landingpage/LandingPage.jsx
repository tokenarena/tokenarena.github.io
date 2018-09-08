import React, { Component } from "react";
import { Route, Switch, Redirect } from "react-router-dom";
// import NotificationSystem from "react-notification-system";

// import Header from "components/Header/Header";
// import Footer from "components/Footer/Footer";
// import Sidebar from "components/Sidebar/Sidebar";

// import Dashboard from "views/Dashboard/Dashboard";
import dashboardRoutes from "routes/dashboard.jsx";

import { style } from "variables/Variables.jsx";


class LandingPage extends Component {
  
  render() {
    return (
      <div className="wrapper">                
        <div id="main-panel" className="main-panel" ref="mainPanel">
          This is the landing page.                    
        </div>
        <Switch>
          {dashboardRoutes.map((prop, key) => { 
            return <Route path={prop.path} component={prop.component} key={key} />          
          })}
        </Switch>
      </div>            
    );
  }
}

export default LandingPage;
