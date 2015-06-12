define(['react', 'jsx!src/components/loglist'], function(React, LogList) {


  var guid = (function() {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
                 .toString(16)
                 .substring(1);
    }
    return function() {
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
             s4() + '-' + s4() + s4() + s4();
    };
  })();

  return React.createClass({

    connectWebsocket: function() {
      if(document.wsconn) {
        document.wsconn.close();
        console.log('[-] Connection closed');
      }

      var rct = this,
          conn = new WebSocket('ws://localhost:8000/logs');

      document.wsconn = conn;
      conn.onopen = function() {
        console.log('[*] Connected to localhost:8000/logs');
      };

      conn.onerror = function(e) {
        console.log('[-] Error: ' + e);
      };

      conn.onclose = function() {
        console.log('[-] Connection closed');
      };

      return conn;
    },

    getInitialState: function() {
      return {data: []};
    },
    componentDidMount: function() {
      var conn = this.connectWebsocket();
      var r = this;

      conn.onmessage = function(msg) {
        var data = msg.data;

        if(data == "Invalid or no input") { 
          console.log(data);
        } else {
          var oldState    = r.state.data;
          var newStateArr = [];
          var data
          try {
            data = $.parseJSON(msg.data);
            var newState    = newStateArr.concat(data).concat(oldState);
            if(newState.length > 100) {
              newState.slice(0, 100);
            }
            r.setState({data: newState});
          } catch (e) { return; }
        }
      };
    },
    render: function() {
      return (
        <div>
          <div className="row">
            <div className="large-12 large-centered columns">
              <h1>Watching All Logs</h1>
            </div>
          </div>
          <hr />
          <LogList data={this.state.data} />
        </div>
      );
    }
  });
});
