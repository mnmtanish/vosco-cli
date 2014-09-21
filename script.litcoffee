Dependencies
============

    _      = require "underscore"
    fs     = require "fs"
    path   = require "path"
    colors = require "cli-color"

VOSCO
=====

    script = {}

Setup
-----

    script.install = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then await @vosco.install defer(error)

    script.uninstall = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @vosco.uninstall defer(error)

Repository
----------

    script.status = (args) ->
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

    script.history = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @vosco.getHistory defer(error, history)
      for commit in history
        hash = commit.hash.substr(0, 7)
        date = new Date(commit.date).toDateString()
        msg  = commit.message
        console.log colors.xterm(240)("  #{hash}  #{date}  #{msg}")

    script['content-history'] = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      # show warning if file doesn"t exist
      console.log "content history"

Snapshots
---------

    script.preview = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "preview snapshot"

    script.snapshot = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "creating snapshot"

    script.rollback = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "rollback to snapshot"

Branches
--------

    script['list-branches'] = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "branches list"

    script['select-branch'] = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "select branch"

    script['create-branch'] = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "create new branch"

    script['delete-branch'] = (args) ->
      await @vosco.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      console.log "delete branch"

Export Module
-------------

    module.exports = (vosco) ->
      script.vosco = vosco
      return script
