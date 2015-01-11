gulp        = require 'gulp'
stylus      = require 'gulp-stylus'
jade        = require 'gulp-jade'
coffee      = require 'gulp-coffee'
order       = require 'gulp-order'
imagemin    = require 'gulp-imagemin'
prefix      = require 'gulp-autoprefixer'
minifyCSS   = require 'gulp-minify-css'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
min         = require 'gulp-htmlmin'

find        = require 'find'
path        = require 'path'
ghpages     = require 'gh-pages'

dev_path =
  jade:   'developer/*.jade'
  images: 'developer/images/**'
  coffee: 'developer/coffee/**.coffee'
  js:     'developer/coffee/**.js'
  stylus: 'developer/stylus/**'
  list:   'developer/list.jade'

prod_path =
  html:   'production/'
  images: 'production/images/'
  js:     'production/js/'
  css:    'production/css/'


handleError = (err)->
  console.log([
      '',
      "----------ERROR MESSAGE START----------",
      ("[" + error.name + " in " + error.plugin + "]"),
      error.message,
      "----------ERROR MESSAGE END----------",
      ''
  ].join('\n'));
  this.emit 'end'

gulp.task('html', ()->
  return gulp.src(dev_path.jade)
    .pipe(jade())
    .pipe(min())
    .pipe(gulp.dest(prod_path.html))
    .on('error', handleError)
)

gulp.task('css', ()->
  return gulp.src(dev_path.stylus)
    .pipe(stylus({errors: true}))
    .pipe(order([
      'reset.css'
      ]))
    .pipe(concat('styles.css'))
    .pipe(prefix())
    .pipe(minifyCSS({removeEmpty:true}))
    .pipe(gulp.dest(prod_path.css))
    .on('error', handleError)
)

gulp.task('js', ()->
  return gulp.src(dev_path.coffee)
    .pipe(coffee({bare: true}))
    .pipe(uglify({outSourceMap: true}))
    .pipe(gulp.dest(prod_path.js))
    .on('error', handleError)
)

gulp.task('purejs', ()->
  return gulp.src(dev_path.js)
    .pipe(uglify({outSourceMap: true}))
    .pipe(gulp.dest(prod_path.js))
    .on('error', handleError)
)

gulp.task('images', ()->
  return gulp.src(dev_path.images)
    .pipe(imagemin())
    .pipe(gulp.dest(prod_path.images))
    .on('error', handleError)
)

gulp.task('deploy', ->
  ghpages.publish(path.join(__dirname, 'production'), {
      repo: 'git@github.com:SilentImp/carrousel.com.ua.git',
      branch: 'gh-pages'
    }, (err)->
      if err
        console.log 'Error: ', err
      else
        console.log 'Published!'
  )
)

gulp.task('list', ->

  find.file(/\.html$/, './production/', (files)->
    names = []
    for file in files
      if file.substr(file.lastIndexOf('production/')+'production/'.length).lastIndexOf('/') > -1
        continue
      names.push path.basename(file)

    gulp.src(dev_path.list)
      .pipe(jade({
        locals: {'pages': names}
        })).on('error', handleError)
      .pipe(gulp.dest('production/'))
  )
)

gulp.task('watch', ()->
  gulp.watch dev_path.jade,   ['html']
  gulp.watch dev_path.stylus, ['css']
  gulp.watch dev_path.coffee, ['js']
  gulp.watch dev_path.images, ['images']
)

gulp.task 'default', ['html', 'js', 'purejs', 'css', 'images']
gulp.task 'watcher', ['html', 'js', 'purejs', 'css', 'images', 'watch']