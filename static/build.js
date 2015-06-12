({
  baseUrl:        "./",
  name:           "src/app",
  out:            "dist/app.min.js",
  //out:            "dist/app-concat.js",
  mainConfigFile: "src/appConfig.js",
  //optimize:       "none",
  optimizeCss:    "none",

  onBuildWrite: function (moduleName, path, singleContents) {
    return singleContents.replace(/jsx!/g, '');
  }
})
