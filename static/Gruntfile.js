module.exports = function(grunt) {
  var compiler = require('superstartup-closure-compiler');
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    sass: {
      options: {
        includePaths: ['bower_components/foundation/scss']
      },
      dist: {
        options: {
          outputStyle: 'compressed'
        },
        files: {
          'css/app.css': 'scss/app.scss'
        }        
      }
    },

    watch: {
      grunt: { files: ['Gruntfile.js'] },

      sass: {
        files: 'scss/**/*.scss',
        tasks: ['sass']
      }
    },

    closureCompiler:  {
      options: {
        compilerFile: compiler.getPath(),
        checkModified: true,
    
        compilerOpts: {
           compilation_level: 'ADVANCED_OPTIMIZATIONS',
           externs: ['bower_components/requirejs/require.js'],
           //define: ["'goog.DEBUG=false'"],
           warning_level: 'verbose',
           jscomp_off: ['checkTypes', 'fileoverviewTags'],
           summary_detail_level: 3,
           output_wrapper: '"(function(){%output%}).call(this);"'
        },
        execOpts: {
           /**
            * Set maxBuffer if you got message "Error: maxBuffer exceeded."
            * Node default: 200*1024
            */
           maxBuffer: 999999 * 1024
        },
        // [OPTIONAL] Java VM optimization options
        // see https://code.google.com/p/closure-compiler/wiki/FAQ#What_are_the_recommended_Java_VM_command-line_options?
        // Setting one of these to 'true' is strongly recommended,
        // and can reduce compile times by 50-80% depending on compilation size
        // and hardware.
        // On server-class hardware, such as with Github's Travis hook,
        // TieredCompilation should be used; on standard developer hardware,
        // d32 may be better. Set as appropriate for your environment.
        // Default for both is 'false'; do not set both to 'true'.
        TieredCompilation: true // will use 'java -server -XX:+TieredCompilation -jar compiler.jar'
      },
    
      targetName: {
        src:  'dist/app-concat.js',
        dest: 'dist/app.js'
      }
    },

    react: {
      dynamic_mappings: {
        files: [
          {
            expand: true,
            cwd: 'src/components',
            src: ['*.jsx'],
            dest: 'src/components',
            ext: '.js'
          }
        ]
      }
    }
  });

  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-closure-tools');
  grunt.loadNpmTasks('grunt-react');

  grunt.registerTask('build', ['sass']);
  grunt.registerTask('default', ['sass', 'watch']);
};
