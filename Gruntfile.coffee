module.exports = (grunt) ->
  version = ->
    grunt.file.readJSON("package.json").version
  version_tag = ->
    "v#{version()}"

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    comments: """
/*!
 * Option adding extension for Chosen
 * 
 * Version <%= pkg.version %>
 * Full source at https://github.com/koenpunt/chosen-option-adding
 * Copyright (c) 2013 Koen. http://koen.pt
 * 
 * MIT License, https://github.com/koenpunt/chosen-option-adding/blob/master/LICENSE.md
 * This file is generated by `grunt build`, do not edit it by hand.
 */
\n
"""
    minified_comments: "/* Chosen option adding #{version_tag()} | (c) 2013 by Koen. | MIT License, https://github.com/koenpunt/chosen-option-adding/blob/master/LICENSE.md */\n"

    concat:
      options:
        banner: "<%= comments %>"
      jquery:
        src: ["public/chosen-create-option.jquery.js"]
        dest: "public/chosen-create-option.jquery.js"
      # proto:
      #   src: ["public/chosen.proto.js"]
      #   dest: "public/chosen.proto.js"

    coffee:
      options:
        join: true
      compile:
        files:
          'public/chosen-create-option.jquery.js': ['coffee/chosen-create-option.jquery.coffee']

    uglify:
      options:
        mangle:
          except: ['jQuery', 'ChosenOptionAdding']
        banner: "<%= minified_comments %>"
      minified_chosen_js:
        files:
          'public/chosen-create-option.jquery.min.js': ['public/chosen-create-option.jquery.js']

    watch:
      scripts:
        files: ['coffee/**/*.coffee']
        tasks: ['build']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['build']
  grunt.registerTask 'build', ['coffee', 'concat', 'uglify']