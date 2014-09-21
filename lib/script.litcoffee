Dependencies
============

    _      = require "underscore"
    colors = require "cli-color"

Script
======

    script = {}

    script['install'] = () ->
      await @vosco.install defer(error)

    script['uninstall'] = () ->
      await @vosco.uninstall defer(error)

    script['get-status'] = () ->
      await @vosco.getStatus defer(error)

    script['get-history'] = () ->
      await @vosco.getHistory defer(error)

    script['get-content-history'] = (path) ->
      await @vosco.getContentHistory path, defer(error)

    script['preview-snapshot'] = (hash) ->
      await @vosco.previewSnapshot hash, defer(error)

    script['create-snapshot'] = (message) ->
      await @vosco.createSnapshot message, defer(error)

    script['rollback-to-snapshot'] = (hash) ->
      await @vosco.rollbackToSnapshot hash, defer(error)

    script['get-branches'] = () ->
      await @vosco.getBranches defer(error)

    script['create-branch'] = (branch) ->
      await @vosco.createBranch branch, defer(error)

    script['select-branch'] = (branch) ->
      await @vosco.selectBranch branch, defer(error)

    script['delete-branch'] = (branch) ->
      await @vosco.deleteBranch branch, defer(error)

Export Module
-------------

    module.exports = (vosco) ->
      script.vosco = require("./vosco-cli")(vosco)
      return script
