gulp        = require 'gulp'
plug        = (require 'gulp-load-plugins')()
conf        = require './.gulp/config'
env         = require './.gulp/env'
path        = require 'path'
tasks       = require 'lazypipe'
browserSync = (require 'browser-sync').create()
reload      = browserSync.reload
args        = require 'yargs'
  .default('dev', env.dev)
  .default('prod', not env.dev)
  .argv

gulp.task 'default', [if args.dev is true then 'serve' else 'build']

gulp.task 'serve', ['watch'], ->
  browserSync.init
    server:
      baseDir: conf.dest

gulp.task 'watch', ['build'], ->
  gulp.watch conf.views, ['views']
  gulp.watch conf.scripts, ['scripts']
  gulp.watch conf.styles, ['styles']

gulp.task 'build', [
  'views'
  'styles'
  'vendorStyles'
  'scripts'
  'vendorScripts'
  'fonts'
  'images'
]

gulp.task 'clean', ->
  gulp.src "#{conf.dest}/*", read: false
    .pipe plug.rimraf()

gulp.task 're', ->
  (require 'run-sequence') 'clean', 'build'

gulp.task 'help', plug.taskListing

gulp.task 'views', ->
  gulp.src [].concat(conf.views, conf.viewsIgnore)
    .pipe plug.plumber()
    .pipe plug.jade
      locals:
        dev: args.dev
    .pipe plug.if(env.prod, plug.minifyHtml())
    .pipe gulp.dest conf.dest
    .pipe plug.if(args.dev, reload stream: true)

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
    # .pipe plug.sourcemaps.init
      .pipe commonTasks
    # .pipe -> plug.sourcemaps.write '.'

  gulp.src conf.scripts
    .pipe plug.plumber()
    .pipe plug.if(args.dev, devTasks())
    .pipe plug.if(env.prod, prodTasks())
    .pipe gulp.dest "#{conf.dest}/scripts"
    .pipe plug.if(args.dev, reload stream: true)

gulp.task 'styles', ->
  gulp.src conf.styles
    .pipe plug.plumber()
    .pipe plug.if(args.dev, plug.sourcemaps.init())
    .pipe plug.sass()
    .pipe plug.concat 'all.css'
    .pipe plug.if(args.dev, plug.sourcemaps.write '.')
    .pipe plug.if(env.prod, plug.minifyCss())
    .pipe gulp.dest "#{conf.dest}/styles"
    .pipe plug.if(args.dev, browserSync.stream())

gulp.task 'vendorScripts', ->
  gulp.src conf.vendorScripts
    .pipe plug.concat 'vendor.js'
    .pipe gulp.dest "#{conf.dest}/scripts"

gulp.task 'vendorStyles', ->
  gulp.src conf.vendorStyles
    .pipe plug.concat 'vendor.css'
    .pipe gulp.dest "#{conf.dest}/styles"

gulp.task 'fonts', ->
  gulp.src conf.vendorFonts
    .pipe gulp.dest "#{conf.dest}/assets/fonts"

gulp.task 'images', ->
  gulp.src conf.images
    .pipe plug.imagemin optimizationLevel: 3
    .pipe gulp.dest "#{conf.dest}/assets/images"
