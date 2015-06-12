define([
  'backbone',
  'react',
  'jsx!src/components/hello',
  'jsx!src/components/watchdevice',
  'jsx!src/components/watchall'
], function(Backbone, React, CompHello, WatchDevice, WatchAll) {
  var AppRouter = Backbone.Router.extend({
    routes: {
      '':               'defaultPath',
      'logs':           'watchAll',
      'logs/:aid':      'watchAccount',
      'logs/:aid/:did': 'watchDevice'
    }
  });
  
  return function() {
    
    var appR = new AppRouter();
    
    appR.on('route:defaultPath', function() {
      React.renderComponent(new CompHello({
        router: appR
      }), document.getElementById("content"));
    });

    appR.on('route:watchAll', function() {
      React.renderComponent(new WatchAll(), document.getElementById("content"));
    });

    appR.on('route:watchDevice', function(aid, did) {
      React.renderComponent(new WatchDevice({
        accountID: aid,
        deviceID: did
      }), document.getElementById("content"));
    });
    
    Backbone.history.start({
      pushState: false
    });
  };
});
