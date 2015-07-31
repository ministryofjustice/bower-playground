/* jshint node: true */

'use strict';

var paths = {
  src: 'moj_django_test/assets-src/',
  dest: 'moj_django_test/assets/',
  styles: 'moj_django_test/assets-src/stylesheets/',
  js: 'moj_django_test/assets-src/javascripts/**/*.js'
};

var gulp = require('gulp');
var sass = require('gulp-ruby-sass');
var del = require('del');
var nconf = require('nconf');
var concat = require('gulp-concat');

gulp.task('sass', ['clean-css'], function() {
  nconf.use('file', { file: './.bowerrc' });
  nconf.load();
  var bowerDir = nconf.get('directory');

  nconf.use('file', { file: './' + bowerDir + '/govuk-template/paths.json' });
  nconf.load();

  var govUkImportPaths = nconf.get('import_paths');

  nconf.use('file', { file: './' + bowerDir + '/mojular/paths.json' });
  nconf.load();

  var mojImportPaths = nconf.get('import_paths');

  return sass(paths.styles, {
      lineNumbers: true,
      loadPath: govUkImportPaths.concat(mojImportPaths).map(function(i) {
        return bowerDir + '/' + i;
      })
    })
    .on('error', function (err) { console.log(err.message); })
    .pipe(gulp.dest(paths.dest + 'css/'));
});

gulp.task('js', ['clean-js'], function() {
  return gulp.src(paths.js)
    .pipe(concat('application.js'))
    .pipe(gulp.dest(paths.dest + 'javascripts'));
});

gulp.task('clean-css', function(cb) {
  del(paths.dest + 'css', cb);
});

gulp.task('clean-js', function(cb) {
  del(paths.dest + 'javascripts', cb);
});

gulp.task('build', [
    'js',
    'sass'
  ]
);

gulp.task('default', ['build']);
