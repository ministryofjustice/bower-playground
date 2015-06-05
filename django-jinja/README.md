# Installation

1. In moj_django_test run npm install to install Node.js dependencies (Gulp)
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
	abspath(root(project_root, bower_dir, 'govuk-template', 'assets')),
	abspath(root(project_root, bower_dir, 'mojular', 'assets')),
	```

	in `TEMPLATE_DIRS` add the following line:

	```py
	abspath(root(project_root, bower_dir, 'mojular', 'templates'))
	```

6. Add `{% extends 'layouts/jinja/base.html' %}` to the top of your template files.

	Two template types are supported: `django/base.html` and `jinja/base.html`

7. Assets are managed with Gulp (or Grunt). An example of Gulp configuration:

	```js
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

	gulp.task('clean-css', function() {
	  del(paths.dest + 'css');
	});

	gulp.task('clean-js', function() {
	  del(paths.dest + 'javascripts');
	});

	gulp.task('build', [
		'js',
		'sass'
	  ]
	);

	gulp.task('default', ['build']);
	```
