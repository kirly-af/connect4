gulp = require 'gulp'
plug = (require 'gulp-load-plugins')()
conf = require './gulp/gulp.config.json'
env  = require './gulp/gulp.env.json'
path = require 'path'
args = require 'yargs'
  .default('dev', env.dev)
  .default('prod', not env.dev)
  .argv

gulp.task 'default', [
  if args.dev is true
  then 'dev'
  else 'build'
]

gulp.task 'build', [
  'templates'
  'styles'
  'vendorStyles'
  'scripts'
  'vendorScripts'
  'images'
]

gulp.task 'dev', ['build'], ->
  gulp.watch conf.templates, ['templates']
  gulp.watch conf.scripts, ['scripts']
  gulp.watch conf.styles, ['styles']
  gulp.watch conf.images, ['images']

gulp.task 'clean', ->
  gulp.src '#{conf.dest}/*', read: false
    .pipe plug.rimraf()

gulp.task 're', ->
  runSequence = require 'run-sequence'
  runSequence 'clean', 'build'

gulp.task 'help', plug.taskListing

gulp.task 'templates', ->
  return

gulp.task 'scripts', ->
  return

gulp.task 'vendorScripts', ->
  return

gulp.task 'styles', ->
  return

gulp.task 'vendorStyles', ->
  return

gulp.task 'images', ->
  return
