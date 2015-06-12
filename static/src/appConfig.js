(function() {
    // :-(
    // make this file work in the mainConfigFile option as well as directly in the browser
    if (!window.require) {
        window.require = {
            config: function(config) {
                window.require = config;
            }
        };
    }

    require.config({
      baseUrl: '/static/',
      paths: {
        jquery:     'bower_components/jquery/dist/jquery.min',
        underscore: 'bower_components/underscore-amd/underscore-min',
        backbone:   'bower_components/backbone-amd/backbone-min',
        mustache:   'bower_components/mustache/mustache',
        text:       'bower_components/text/text',
        foundation: 'bower_components/foundation/js/foundation.min',
        modernizr:  'bower_components/modernizr/modernizr',
        react:      'bower_components/jsx-requirejs-plugin/js/react-with-addons-0.10.0',
        jsx:        'bower_components/jsx-requirejs-plugin/js/jsx',
        JSXTransformer: 'bower_components/jsx-requirejs-plugin/js/JSXTransformer-0.10.0',

        /* This let's us switch easily between the compiled version
           and the non-compiled version
        */

        //app:       './dist/app.min'
      },

      shim: {
        modernizr: {
          deps: ['jquery']
        },
        foundation: {
          deps: ['jquery', 'modernizr']
        },
      },

      jsx: {
        fileExtension: ".jsx"
      }
    });
    require(["src/app"]);
}());
