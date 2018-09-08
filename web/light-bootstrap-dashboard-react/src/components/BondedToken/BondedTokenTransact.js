import Switch  from 'react-flexible-switch';
import BigNumber from 'bignumber.js'
var React = require('react');

class BondedTokenTransact extends React.Component {

  render() {
    return (
      <div >

        <div className="--bondedToken-flex --bondedTokenTransact">
          <Switch
          switchStyles={{width: 80}}
          value={this.props.isBuy}
          circleStyles={{diameter: 16, onColor: 'grey', offColor: 'grey'}} 
          labels={{on: 'Buy', off: 'Sell'}}
          onChange={event => this.props.toggleBuy()}
          />
          <label className={"--bondedToken-token"}>
            <input
              type="number"
              max={this.props.isBuy ? (this.props.address ? this.props.calculateMaxPurchaseReturn() : this.props.bigMax) : (this.props.address ? this.props.tokenBalance : this.props.totalSupply)}
              value={this.props.amount}
              onChange={event => {
                if (event.target.value && new BigNumber(event.target.value).gte(event.target.max)) {
                  event.target.value = event.target.max
                } else if (!event.target.value || new BigNumber(event.target.value).lte('0')) {
                  event.target.value = 0
                }
                this.props.onChange(event, 'amount')
              }} />
          </label>
        </div>
        <div className="--bondedToken-flex --bondedTokenTransact">
          <div>For</div>
          <label className={"--bondedToken-eth"}>
            <div>
              {this.props.isBuy ? this.props.calculateBuyPrice() : this.props.calculateBuyPrice()}
            </div>
          </label>
        </div>
        {this.props.address && (
        <div className="--bondedToken-submit-container">
            <button
              value="submit"
              className="--bondedToken-submit"
              onClick={event => this.props.submit()} >
              submit
            </button>     
          </div>
        )}
      </div>
    );
  }

};

export default BondedTokenTransact;