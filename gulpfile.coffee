gulp        = require 'gulp'
plug        = (require 'gulp-load-plugins')()
conf        = require './gulp/gulp.config.json'
env         = require './gulp/gulp.env.json'
path        = require 'path'
tasks       = require 'lazypipe'
browserSync = (require 'browser-sync').create()
reload      = browserSync.reload
runSequence = require 'run-sequence'
args        = require 'yargs'
  .default('dev', env.dev)
  .default('prod', not env.dev)
  .argv

gulp.task 'default', [
  if args.dev is true
  then 'serve'
  else 'build'
]

gulp.task 'build', [
  'templates'
  'styles'
  'vendorStyles'
  'scripts'
  'vendorScripts'
  'fonts'
  'images'
]

gulp.task 'serve', ['build', 'watch'], ->
  browserSync.init
    server:
      baseDir: conf.dest

gulp.task 'watch', ->
  gulp.watch conf.templates, ['templates']
  gulp.watch conf.scripts, ['scripts']
  gulp.watch conf.styles, ['styles']

gulp.task 'clean', ->
  gulp.src "#{conf.dest}/*", read: false
    .pipe plug.rimraf()

gulp.task 're', ->
  runSequence 'clean', 'build'

gulp.task 'help', plug.taskListing

gulp.task 'templates', ->
  gulp.src conf.templates
    .pipe plug.plumber()
    .pipe plug.jade()
    .pipe plug.if(env.prod, plug.minifyHtml())
    .pipe gulp.dest conf.dest
    # .pipe plug.if(env.dev, reload stream: true)

gulp.task 'scripts', ->
  commonTasks = tasks()
    .pipe plug.coffee
    .pipe -> plug.concat 'app.js'

  prodTasks = tasks()
    .pipe commonTasks
    .pipe plug.uglify

  devTasks = tasks()
    .pipe plug.coffeelint
    .pipe -> plug.coffeelint.reporter(require 'coffeelint-stylish')
    .pipe plug.sourcemaps.init
      .pipe commonTasks
    .pipe -> plug.sourcemaps.write '.'

  gulp.src conf.scripts
    .pipe plug.plumber()
    .pipe plug.if(env.dev, devTasks())
    .pipe plug.if(env.prod, prodTasks())
    .pipe gulp.dest "#{conf.dest}/scripts"
    # .pipe plug.if(env.dev, reload stream: true)

gulp.task 'styles', ->
  gulp.src conf.styles
    .pipe plug.plumber()
    .pipe plug.if(env.dev, plug.sourcemaps.init())
    .pipe plug.sass()
    .pipe plug.concat 'all.css'
    .pipe plug.if(env.dev, plug.sourcemaps.write '.')
    .pipe plug.if(env.prod, plug.minifyCss())
    .pipe gulp.dest "#{conf.dest}/styles"
    # .pipe plug.if(env.dev, browserSync.stream())

gulp.task 'vendorStyles', ->
  gulp.src conf.vendorStyles
    .pipe plug.concat 'vendor.css'
    .pipe gulp.dest "#{conf.dest}/styles"

gulp.task 'vendorScripts', ->
  gulp.src conf.vendorScripts
    .pipe plug.concat 'vendor.js'
    .pipe gulp.dest "#{conf.dest}/scripts"

gulp.task 'fonts', ->
  gulp.src conf.vendorFonts
    .pipe gulp.dest "#{conf.dest}/fonts"

gulp.task 'images', ->
  gulp.src conf.images
    .pipe plug.imagemin optimizationLevel: 3
    .pipe gulp.dest "#{conf.dest}/images"
