require(
[ 'jquery',
  'underscore',
  'foundation',
  'src/router'
], function($, _, Foundation, Router) {
  $(document).foundation();
  Router();
});
