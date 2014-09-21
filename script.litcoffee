Dependencies
============

    _      = require "underscore"
    fs     = require "fs"
    path   = require "path"
    colors = require "cli-color"

VOSCO
=====

    script =

Setup
-----

      'install': () ->
        await @vosco.isInstalled defer(error, isInstalled)
        if isInstalled then process.exit 1
        await @vosco.install defer(error)

      'uninstall': () ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        await @vosco.uninstall defer(error)

Repository
----------

      'get-status': () ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        await @vosco.getStatus defer(error, status)
        getType = (file) -> file.type
        getPath = (file) -> colors.xterm(240)("  #{file.path}")
        groups  = _.groupBy status, getType
        for group, paths of groups
          console.log """
          #{group}
          #{paths.map(getPath).join("\n")}
          """

      'get-history': () ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        await @vosco.getHistory defer(error, history)
        for commit in history
          hash = commit.hash.substr(0, 7)
          date = new Date(commit.date).toDateString()
          msg  = commit.message
          console.log colors.xterm(240)("  #{hash}  #{date}  #{msg}")

      'get-content-history': (path) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        # show warning if file doesn"t exist
        console.log "content history"

Snapshots
---------

      'preview-snapshot': (hash) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        hash = hash or 'HEAD'
        await @vosco.previewSnapshot hash, defer(error, diff)
        console.log diff

      'create-snapshot': (message) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        message = message or 'Untitled Snapshot'
        await @vosco.createSnapshot message, defer(error)

      'rollback-to-snapshot': (hash) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        console.log "rollback to snapshot"

Branches
--------

      'list-branches': () ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        console.log "branches list"

      'select-branch': (branch) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        console.log "select branch"

      'create-branch': (branch) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        console.log "create new branch"

      'delete-branch': (branch) ->
        await @vosco.isInstalled defer(error, isInstalled)
        unless isInstalled then process.exit 1
        console.log "delete branch"

Export Module
-------------

    module.exports = (vosco) ->
      script.vosco = vosco
      return script
