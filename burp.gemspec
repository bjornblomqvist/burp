# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "burp"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Darwin"]
  s.date = "2012-10-03"
  s.description = " A CMS that tryes hard to not get in your way! "
  s.email = "darwin@bits2life.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    "Rakefile",
    "app/assets/images/burp/img/glyphicons-halflings-white.png",
    "app/assets/images/burp/img/glyphicons-halflings.png",
    "app/assets/javascripts/burp/application.js",
    "app/assets/javascripts/burp/burp.js",
    "app/assets/javascripts/burp/cms_helper.js",
    "app/assets/javascripts/burp/edit-page.js",
    "app/assets/javascripts/burp/lib/bootstrap.min.js",
    "app/assets/javascripts/burp/lib/debug.js",
    "app/assets/javascripts/burp/lib/fileupload.js",
    "app/assets/javascripts/burp/lib/missing-restful-verbs.js",
    "app/assets/javascripts/burp/menu-functions.js",
    "app/assets/javascripts/burp/pages-drag-and-drop.js",
    "app/assets/packages/burp/editing.js",
    "app/assets/packages/burp/editing.less",
    "app/assets/packages/burp/editing/css/dropzone.css",
    "app/assets/packages/burp/editing/css/edit-content.less",
    "app/assets/packages/burp/editing/css/gallery.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/README.md",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/activeline.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/changemode.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/closetag.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/complete.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/emacs.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/folding.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/formatting.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/fullscreen.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/loadmode.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/marker.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/matchhighlighter.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/multiplex.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/mustache.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/preview.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/resize.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/runmode.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/search.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/theme.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/vim.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/demo/visibletabs.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/baboon.png",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/baboon_vector.svg",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/compress.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/docs.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/internals.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/manual.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/oldrelease.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/reporting.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/doc/upgrade_v2.2.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/keymap/emacs.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/keymap/vim.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/codemirror.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/codemirror.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/closetag.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/dialog.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/dialog.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/foldcode.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/formatting.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/javascript-hint.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/loadmode.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/match-highlighter.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/multiplex.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/overlay.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/pig-hint.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/runmode.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/search.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/searchcursor.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/simple-hint.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/lib/util/simple-hint.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/clike/clike.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/clike/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/clike/scala.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/clojure/clojure.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/clojure/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/coffeescript/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/coffeescript/coffeescript.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/coffeescript/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/css/css.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/css/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/diff/diff.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/diff/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ecl/ecl.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ecl/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/erlang/erlang.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/erlang/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/gfm/gfm.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/gfm/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/go/go.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/go/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/groovy/groovy.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/groovy/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/haskell/haskell.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/haskell/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/htmlembedded/htmlembedded.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/htmlembedded/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/htmlmixed/htmlmixed.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/htmlmixed/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/javascript/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/javascript/javascript.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/jinja2/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/jinja2/jinja2.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/less/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/less/less.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/lua/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/lua/lua.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/markdown/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/markdown/markdown.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/mysql/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/mysql/mysql.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ntriples/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ntriples/ntriples.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/pascal/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/pascal/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/pascal/pascal.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/perl/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/perl/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/perl/perl.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/php/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/php/php.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/pig/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/pig/pig.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/plsql/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/plsql/plsql.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/properties/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/properties/properties.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/python/LICENSE.txt",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/python/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/python/python.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/r/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/r/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/r/r.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rpm/changes/changes.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rpm/changes/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rpm/spec/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rpm/spec/spec.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rpm/spec/spec.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rst/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rst/rst.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ruby/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ruby/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/ruby/ruby.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rust/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/rust/rust.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/scheme/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/scheme/scheme.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/shell/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/shell/shell.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/smalltalk/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/smalltalk/smalltalk.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/smarty/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/smarty/smarty.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/sparql/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/sparql/sparql.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/stex/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/stex/stex.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/stex/test.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/tiddlywiki/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/tiddlywiki/tiddlywiki.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/tiddlywiki/tiddlywiki.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/tiki/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/tiki/tiki.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/tiki/tiki.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/vbscript/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/vbscript/vbscript.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/velocity/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/velocity/velocity.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/verilog/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/verilog/verilog.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xml/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xml/xml.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/LICENSE",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/testBase.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/testEmptySequenceKeyword.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/testMultiAttr.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/testNamespaces.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/testProcessingInstructions.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/test/testQuotes.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/xquery/xquery.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/yaml/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/mode/yaml/yaml.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/package.json",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/test/index.html",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/test/mode_test.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/test/mode_test.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/test/test.js",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/ambiance.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/blackboard.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/cobalt.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/eclipse.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/elegant.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/erlang-dark.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/lesser-dark.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/monokai.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/neat.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/night.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/rubyblue.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/vibrant-ink.css",
    "app/assets/packages/burp/editing/dep/CodeMirror-2.3/theme/xq-dark.css",
    "app/assets/packages/burp/editing/dep/FontAwesome/FontAwesome-Vectors.pdf",
    "app/assets/packages/burp/editing/dep/FontAwesome/FontAwesome.ttf",
    "app/assets/packages/burp/editing/dep/FontAwesome/README.md",
    "app/assets/packages/burp/editing/dep/FontAwesome/css/font-awesome-ie7.css",
    "app/assets/packages/burp/editing/dep/FontAwesome/css/font-awesome.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/css/font-awesome-ie7.css",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/css/font-awesome.css",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/css/prettify.css",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/css/site.css",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/fontawesome-webfont.eot",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/fontawesome-webfont.svg",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/fontawesome-webfont.ttf",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/fontawesome-webfont.woff",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/museo_slab_300-webfont.eot",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/museo_slab_300-webfont.ttf",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/museo_slab_500-webfont.eot",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/museo_slab_500-webfont.ttf",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/proximanova-webfont.eot",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/font/proximanova-webfont.ttf",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/ico/favicon.ico",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/backbone.min.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/index/index.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/jquery-1.7.1.min.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/prettify.min.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-alert.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-button.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-carousel.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-collapse.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-dropdown.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-modal.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-popover.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-scrollspy.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-tab.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-tooltip.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-transition.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/tw-bs-201/bootstrap-typeahead.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/js/underscore.min.js",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/font-awesome-ie7.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/font-awesome.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/font-site.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/mixins.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/site.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/accordion.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/alerts.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/bootstrap.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/breadcrumbs.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/button-groups.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/buttons.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/carousel.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/close.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/code.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/component-animations.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/dropdowns.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/forms.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/grid.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/hero-unit.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/labels-badges.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/layouts.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/mixins.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/modals.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/navbar.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/navs.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/pager.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/pagination.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/popovers.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/progress-bars.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/reset.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/responsive-1200px-min.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/responsive-767px-max.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/responsive-768px-979px.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/responsive-navbar.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/responsive-utilities.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/responsive.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/scaffolding.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/sprites.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/tables.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/thumbnails.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/tooltip.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/type.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/utilities.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/variables.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/twbs-203/wells.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/assets/less/variables.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/docs/index.html",
    "app/assets/packages/burp/editing/dep/FontAwesome/font/fontawesome-webfont.eot",
    "app/assets/packages/burp/editing/dep/FontAwesome/font/fontawesome-webfont.svg",
    "app/assets/packages/burp/editing/dep/FontAwesome/font/fontawesome-webfont.ttf",
    "app/assets/packages/burp/editing/dep/FontAwesome/font/fontawesome-webfont.woff",
    "app/assets/packages/burp/editing/dep/FontAwesome/less/font-awesome-ie7.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/less/font-awesome.less",
    "app/assets/packages/burp/editing/dep/FontAwesome/sass/font-awesome.sass",
    "app/assets/packages/burp/editing/dep/FontAwesome/sass/font-awesome.scss",
    "app/assets/packages/burp/editing/js/admin-dock.js",
    "app/assets/packages/burp/editing/js/content-decorator.js",
    "app/assets/packages/burp/editing/js/main.js",
    "app/assets/packages/burp/editing/js/md5.js",
    "app/assets/packages/burp/editing/js/showdown.js",
    "app/assets/packages/burp/editing/js/stay.js",
    "app/assets/stylesheets/burp/application.less",
    "app/assets/stylesheets/burp/bootstrap.css",
    "app/assets/stylesheets/burp/fileupload.less",
    "app/assets/stylesheets/burp/views/page-index.less",
    "app/controllers/burp/application_controller.rb",
    "app/controllers/burp/catch_all_controller.rb",
    "app/controllers/burp/error_controller.rb",
    "app/controllers/burp/file_controller.rb",
    "app/controllers/burp/menu_controller.rb",
    "app/controllers/burp/page_controller.rb",
    "app/controllers/burp/static_controller.rb",
    "app/helpers/burp/application_helper.rb",
    "app/lib/burp/access.rb",
    "app/lib/burp/group.rb",
    "app/lib/burp/link.rb",
    "app/lib/burp/page.rb",
    "app/lib/burp/site.rb",
    "app/lib/burp/test_cms.rb",
    "app/lib/burp/util/upload_handler.rb",
    "app/models/burp/menu.rb",
    "app/models/burp/page_model.rb",
    "app/views/burp/file/index.html.erb",
    "app/views/burp/page/edit.html.erb",
    "app/views/burp/page/index.html.erb",
    "app/views/burp/static/index.html.erb",
    "app/views/layouts/burp/application.html.erb",
    "config/initializers/bootstrap_form.rb",
    "config/routes.rb",
    "lib/burp.rb",
    "lib/burp/capistrano.rb",
    "lib/burp/engine.rb",
    "lib/burp/version.rb",
    "lib/tasks/burp_tasks.rake"
  ]
  s.licenses = ["LGPL3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A CMS that tryes hard to not get in your way!"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<burp>, [">= 0"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
      s.add_runtime_dependency(%q<jquery-ui-rails>, [">= 0"])
      s.add_runtime_dependency(%q<less-rails>, [">= 0"])
      s.add_runtime_dependency(%q<mayi>, [">= 0"])
      s.add_runtime_dependency(%q<therubyracer>, [">= 0"])
      s.add_runtime_dependency(%q<twitter_bootstrap_form_for>, ["~> 2.0.1.0.rc1"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<burp>, [">= 0"])
      s.add_dependency(%q<jquery-rails>, [">= 0"])
      s.add_dependency(%q<jquery-ui-rails>, [">= 0"])
      s.add_dependency(%q<less-rails>, [">= 0"])
      s.add_dependency(%q<mayi>, [">= 0"])
      s.add_dependency(%q<therubyracer>, [">= 0"])
      s.add_dependency(%q<twitter_bootstrap_form_for>, ["~> 2.0.1.0.rc1"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<burp>, [">= 0"])
    s.add_dependency(%q<jquery-rails>, [">= 0"])
    s.add_dependency(%q<jquery-ui-rails>, [">= 0"])
    s.add_dependency(%q<less-rails>, [">= 0"])
    s.add_dependency(%q<mayi>, [">= 0"])
    s.add_dependency(%q<therubyracer>, [">= 0"])
    s.add_dependency(%q<twitter_bootstrap_form_for>, ["~> 2.0.1.0.rc1"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

