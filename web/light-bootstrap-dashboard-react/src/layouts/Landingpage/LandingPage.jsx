import React, { Component } from "react";
import { Route, Switch, Redirect } from "react-router-dom";
// import NotificationSystem from "react-notification-system";

import Header from "components/Header/Header";
// import Footer from "components/Footer/Footer";
// import Sidebar from "components/Sidebar/Sidebar";

// import Dashboard from "views/Dashboard/Dashboard";
import dashboardRoutes from "routes/dashboard.jsx";

import { Grid, Row, Col } from "react-bootstrap";
import { style } from "variables/Variables.jsx";
import { Card } from "components/Card/Card.jsx";
import Button from 'components/CustomButton/CustomButton';
import { NavItem, Navbar, Nav, NavDropdown, MenuItem } from "react-bootstrap";

class LandingPage extends Component {
  constructor(props) {
    super(props);       
  }
  render() {
    return (      
      <div className="wrapper">                        
        <div className="content">
          <Grid fluid>
            <Navbar fluid>
              <Navbar.Header>
                <Navbar.Brand>
                  <a href="#">Tokenarena</a>
                </Navbar.Brand>
                <Navbar.Toggle onClick={this.mobileSidebarToggle} />
              </Navbar.Header>
              <Navbar.Collapse>
                <div>
                  <Nav>
                    <NavItem eventKey={3} href="#">
                      <i className="fa fa-search" />
                      <p className="hidden-lg hidden-md">Search</p>
                    </NavItem>
                  </Nav>
                  <Nav pullRight>
                    <NavItem eventKey={1} href="#">
                      About
                    </NavItem>
                    <NavItem eventKey={1} href="#">
                      Team
                    </NavItem>
                  </Nav>
                </div>    
              </Navbar.Collapse>
            </Navbar>
            <Row>
              <Col md={2}></Col>
              <Col md={6}>
                <h1>Decide what your favorite influencers should do next</h1>
                <h4>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut 
                labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi 
                ut aliquip ex ea commodo consequat. </h4>              
               <Button bsStyle="primary">Influencer? Create an Event</Button>
              </Col>
            </Row>
            <Row>
              <Col md={2}></Col>
              <Col md={6}>
                <Card
                  id="chartActivity"
                  title="What should my next video be about?"
                  category="User1"
                  stats="Voting period open"
                  statsIcon="fa fa-check"
                  content={
                    <div className="activity-card">
                      <a href="#">0xbe1c42bed6b0d9b8811c744e831f1bf14abc7d66</a>
                    </div>
                  }                  
                />
                <Card
                  id="chartActivity"
                  title="What should my next video be about?"
                  category="User1"
                  stats="Voting period open"
                  statsIcon="fa fa-check"
                  content={
                    <div className="activity-card">
                      <a href="#">0xbe1c42bed6b0d9b8811c744e831f1bf14abc7d66</a>
                    </div>
                  }                  
                />
                <Card
                  id="chartActivity"
                  title="What should my next video be about?"
                  category="User1"
                  stats="Voting period open"
                  statsIcon="fa fa-check"
                  content={
                    <div className="activity-card">
                      <a href="#">0xbe1c42bed6b0d9b8811c744e831f1bf14abc7d66</a>
                    </div>
                  }                  
                />                
              </Col>
            </Row>  
          </Grid>
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
