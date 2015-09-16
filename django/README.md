# Installation

1. In `moj_django_test` run `npm install` to install Node.js dependencies (Gulp)
2. Edit `.bowerrc` to desired directory
3. `bower install`
4. `npm install`
5. Add the following to app settings:
	```py
	project_root = abspath(root('..'))
	```

	in `STATICFILES_DIRS` add the following line:

	```py
	abspath(root(project_root, 'node_modules')),
  abspath(root(project_root, 'node_modules', 'mojular', 'assets')),
  abspath(root(project_root, 'node_modules', 'mojular', 'bower_components', 'govuk-template', 'assets')),
	```

	in `TEMPLATE_DIRS` add the following line:

	```py
	abspath(root(project_root, 'node_modules', 'mojular', 'templates'))
	```

6. Add `{% extends 'layouts/django/base.html' %}` to the top of your template files

	Two template types are supported: `django/base.html` and `jinja/base.html`

7. Assets are managed with Gulp (or Grunt). An example of Gulp configuration:

	```js
  var gulp = require('gulp');
  var sass = require('gulp-sass');
  var sourcemaps = require('gulp-sourcemaps');
  var concat = require('gulp-concat');
  var merge = require('merge-stream');
  // Get Sass import paths from Mojular
  var importPaths = require('mojular').getImportPaths();

  var paths = {
    src: 'moj_django_test/assets-src/',
    dest: 'moj_django_test/assets/',
    styles: 'moj_django_test/assets-src/stylesheets/**/*.scss',
    js: 'moj_django_test/assets-src/javascripts/**/*.js',
    mojular_js: require('mojular').getScriptPaths() // Get Mojular scripts paths
  };

  gulp.task('sass', function() {
    gulp.src(paths.styles)
      .pipe(sourcemaps.init())
      .pipe(sass({ includePaths: importPaths }).on('error', sass.logError))
      .pipe(sourcemaps.write('.'))
      .pipe(gulp.dest(paths.dest + 'css/'));
  });

  gulp.task('js', function() {
    var local_js = gulp.src(paths.mojular_js).pipe(concat('moj.js')).pipe(gulp.dest(paths.dest + 'scripts/'));
    var mojular_js = gulp.src(paths.js).pipe(concat('application.js')).pipe(gulp.dest(paths.dest + 'scripts/'));

    return merge(local_js, mojular_js);
  });

  gulp.task('default', ['js', 'sass']);
	```
