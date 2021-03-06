module.exports = (grunt) ->

  require('time-grunt') grunt

  # Dynamically load npm tasks
  require('jit-grunt') grunt

  grunt.initConfig

    # Watching changes files *.js,
    watch:
      all:
        files: [
          "Gruntfile.coffee"
          "src/**/*.coffee"
          "test/**/*.coffee"
        ]
        tasks: [
          "coffee"
          "mochaTest"
        ]
        options:
          nospawn: true

    coffee:
      compile:
        expand: true
        flatten: true
        src: ['src/*.coffee']
        dest: 'lib/'
        ext: '.js'

    coffeelint:
      all:
        src: [
          'Gruntfile.coffee'
          'src/**/*.coffee'
          'test/**/*.coffee'
        ]

    coffeecov:
      compile:
        src: 'src'
        dest: 'lib'

    shell:
      coveralls:
        command: 'cat coverage/coverage.lcov |
            ./node_modules/coveralls/bin/coveralls.js src'

    mochaTest:
      test:
        options:
          reporter: 'mocha-phantom-coverage-reporter'
          require: 'coffee-script/register'
        src: ['test/**/*.coffee']


  grunt.registerTask 'uploadCoverage', ->
    return grunt.log.ok 'Bypass uploading' unless process.env['TRAVIS'] is 'true'

    grunt.task.run 'shell:coveralls'

  grunt.registerTask 'default', [
    'watch'
    'mochaTest'
  ]

  grunt.registerTask 'test', [
    'coffeelint'
    'coffeecov'
    'mochaTest'
    'uploadCoverage'
  ]

  return
