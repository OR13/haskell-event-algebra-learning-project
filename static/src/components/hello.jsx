define(['react'], function(React) {
  return React.createClass({

    getInitialState: function() {
      return {
        "accountid": 'ahmsa',
        "deviceid": 15
      };
    },
    handleChange: function(event) {
      var key = event.target.name;
      this.state[key] = event.target.value;

      this.setState(this.state);
    },
    handleSubmit: function(event) {
      var route = ["logs", this.state.accountid, this.state.deviceid];
      return this.props.router.navigate(route.join("/"), {trigger: true});
    },
    render: function() {
      return (
        <div className="row">
          <br />
          <div className="row">
            <div className="large-4 large-centered columns">
                <div className="row collapse">
                  <div className="small-9 columns">
                    <input type="text"
                           name="accountid"
                           placeholder="ahmsa"
                           value={this.state.accountid}
                           onChange={this.handleChange} />
                  </div>
                  <div className="small-3 columns">
                    <span className="postfix radius">AccountID</span>
                  </div>
                </div>
                <div className="row collapse">
                  <div className="small-9 columns">
                    <input type="text"
                           name="deviceid"
                           placeholder="15"
                           value={this.state.deviceid}
                           onChange={this.handleChange} />
                  </div>
                  <div className="small-3 columns">
                    <span className="postfix radius">DeviceID</span>
                  </div>
                </div>
                <div className="row collapse">
                  <div className="small-12 columns">
                    <button type="submit" onClick={this.handleSubmit}>Watch Logs</button>
                  </div>
                </div>
            </div>
          </div>
        </div>
      );
    }
  });
});
