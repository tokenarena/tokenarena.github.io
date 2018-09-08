import React, { Component } from "react";
import ChartistGraph from "react-chartist";
import { Grid, Row, Col } from "react-bootstrap";
import BondedToken from "components/BondedToken/BondedToken";

import { Card } from "components/Card/Card.jsx";
import { StatsCard } from "components/StatsCard/StatsCard.jsx";
import { Tasks } from "components/Tasks/Tasks.jsx";
import {
  dataPie,
  legendPie,
  dataSales,
  optionsSales,
  responsiveSales,
  legendSales,
  dataBar,
  optionsBar,
  responsiveBar,
  legendBar
} from "variables/Variables.jsx";

import { UserCard } from "components/UserCard/UserCard.jsx";
import Button from "components/CustomButton/CustomButton.jsx";

import avatar from "assets/img/faces/face-3.jpg";

class Dashboard extends Component {
  createLegend(json) {
    var legend = [];
    for (var i = 0; i < json["names"].length; i++) {
      var type = "fa fa-circle text-" + json["types"][i];
      legend.push(<i className={type} key={i} />);
      legend.push(" ");
      legend.push(json["names"][i]);
    }
    return legend;
  }
  render() {
    let contractAddress = '0xN07AR34LC0N7R4C74DDR355D0N0TU5E7H15H3110M0M'

    return (
      <div className="content">
        <Grid fluid>
          <Row>
            <Col md={4}>

              <UserCard
                bgImage="https://ununsplash.imgix.net/photo-1431578500526-4d9613015464?fit=crop&fm=jpg&h=300&q=75&w=400"
                avatar={avatar}
                name="Mike Andrew"
                userName="michael24"
                description={
                  <span>
                    "Lamborghini Mercy
                    <br />
                    Your chick she so thirsty
                    <br />
                    I'm in that two seat Lambo"
                  </span>
                }
                socials={
                  <div>
                    <Button simple>
                      <i className="fa fa-facebook-square" />
                    </Button>
                    <Button simple>
                      <i className="fa fa-twitter" />
                    </Button>
                    <Button simple>
                      <i className="fa fa-google-plus-square" />
                    </Button>
                  </div>
                }
              />
            </Col>
            <Col md={8}>

              <Card
                title="Voting"
                category="Tell me what I should do during my next podcast"
                stats="Updated 3 minutes ago"
                statsIcon="fa fa-history"
                content={
                  <div className="table-full-width">
                    <table className="table">
                      <Tasks />
                    </table>
                  </div>
                }
              />


            </Col>
          </Row>
          <Row>
            <Col md={3}>
              <StatsCard
                bigIcon={<i className="pe-7s-wallet text-success" />}
                statsText="Pool Balance"
                statsValue="345 ETH"
                statsIcon={<i className="fa fa-calendar-o" />}
                statsIconText="Last day"
              />
            </Col>
            <Col md={3}>

              <StatsCard
                bigIcon={<i className="pe-7s-server text-warning" />}
                statsText="Total Supply"
                statsValue="256.42"
                statsIcon={<i className="fa fa-refresh" />}
                statsIconText="Updated now"
              />
            </Col>

            <Col md={3}>

              <StatsCard
                bigIcon={<i className="pe-7s-wallet text-success" />}
                statsText="Next show"
                statsValue="$1,345"
                statsIcon={<i className="fa fa-calendar-o" />}
                statsIconText="Last day"
              />
            </Col>

            <Col md={3}>

              <StatsCard
                bigIcon={<i className="pe-7s-wallet text-success" />}
                statsText="Average committed"
                statsValue="$1,345"
                statsIcon={<i className="fa fa-calendar-o" />}
                statsIconText="Last day"
              />
            </Col>

          </Row>
          <Row h={100}>

            <Card
              statsIcon="fa fa-history"
              id="chartHours"
              title="Token Bonding Curve"
              category="24 Hours performance"
              stats="Updated 3 minutes ago"
              content={
                <div className="ct-chart">
                  <BondedToken address={contractAddress} relevant={true} />

                </div>
              }

            />
          </Row>

        </Grid>
      </div>
    );
  }
}

export default Dashboard;
