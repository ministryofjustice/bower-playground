# Installation

1. In `moj_django_test` run `npm install` to install Node.js dependencies (Gulp)
2. Edit `.bowerrc` to desired directory
3. `bower install`
4. `npm install`
5. Add the following to app settings:
	```py
	project_root = abspath(root('..'))
	bower_dir = json.load(open(join(project_root, '.bowerrc')))['directory']
	```

	in `STATICFILES_DIRS` add the following line:

	```py
	abspath(root(project_root, bower_dir)),
	abspath(root(project_root, bower_dir, 'mojular', 'assets')),
	abspath(root(project_root, bower_dir, 'govuk-template', 'assets')),
	```

	in `TEMPLATE_DIRS` add the following line:

	```py
	abspath(root(project_root, bower_dir, 'mojular', 'templates'))
	```

6. Add `{% extends 'layouts/django/base.html' %}` to the top of your template files

	Two template types are supported: `django/base.html` and `jinja/base.html`

7. Assets are managed with Gulp (or Grunt). An example of Gulp configuration:

	```js
  var gulp = require('gulp');
  var sass = require('gulp-sass');
  var sourcemaps = require('gulp-sourcemaps');
  var readJson = require('read-json-sync');
  var concat = require('gulp-concat');
  var util = require('util');
  var merge = require('merge-stream');

  var bowerDir = 'bower_components';

  try {
    bowerDir = readJson('.bowerrc').directory;
  } catch(e) {}

  var paths = {
    src: 'moj_django_test/assets-src/',
    dest: 'moj_django_test/assets/',
    styles: 'moj_django_test/assets-src/stylesheets/**/*.scss',
    js: 'moj_django_test/assets-src/javascripts/**/*.js',
    mojular_js: [
      util.format('%s/mojular/assets/scripts/moj.js', bowerDir),
      util.format('%s/mojular/assets/scripts/modules/**/*.js', bowerDir),
      util.format('%s/mojular/assets/scripts/moj-init.js', bowerDir)
    ]
  };

  gulp.task('sass', function() {
    var importPaths = [];

    importPaths = importPaths.concat(readJson(util.format('%s/govuk-template/paths.json', bowerDir)).import_paths);
    importPaths = importPaths.concat(readJson(util.format('%s/mojular/paths.json', bowerDir)).import_paths);

    gulp.src(paths.styles)
      .pipe(sourcemaps.init())
      .pipe(sass({
        includePaths: importPaths.map(function(path) {
          return util.format('%s/%s', bowerDir, path);
        })
      }).on('error', sass.logError))
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
