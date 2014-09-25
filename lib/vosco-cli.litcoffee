Dependencies
============

    _      = require "underscore"
    colors = require "cli-color"

VOSCO
=====

    voscoCLI = {}

Setup
-----

    voscoCLI.install = (callback) ->
      await @original.isInstalled defer(error, isInstalled)
      if isInstalled then process.exit 1
      await @original.install defer(error)
      callback null

    voscoCLI.uninstall = (callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.uninstall defer(error)
      callback null

    voscoCLI.isInstalled = (callback) ->
      await @original.isInstalled defer(error, isInstalled)
      callback null, isInstalled

Repository
----------

    voscoCLI.getStatus = (callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.getStatus defer(error, status)
      getType = (file) -> file.type
      getPath = (file) -> colors.xterm(240)("  #{file.path}")
      groups  = _.groupBy status, getType
      for group, paths of groups
        console.log """
        #{group}
        #{paths.map(getPath).join("\n")}
        """
      callback null

    voscoCLI.getHistory = (callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.getHistory defer(error, history)
      for commit in history
        hash = commit.hash.substr(0, 7)
        date = new Date(commit.date).toDateString()
        msg  = commit.message
        console.log colors.xterm(240)("  #{hash}  #{date}  #{msg}")
      callback null

    voscoCLI.getContentHistory = (path, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.getContentHistory path, defer(error, history)
      console.log history
      callback null

Snapshots
---------

    voscoCLI.previewSnapshot = (hash, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      hash = hash or 'HEAD'
      await @original.previewSnapshot hash, defer(error, diff)
      console.log diff
      callback null

    voscoCLI.createSnapshot = (message, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      message = message or 'Untitled Snapshot'
      await @original.createSnapshot message, defer(error)
      callback null

    voscoCLI.rollbackToSnapshot = (hash, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.rollbackToSnapshot hash, defer(error)
      callback null

Branches
--------

    voscoCLI.getBranches = (callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.getBranches defer(error, branches, current)
      for branch in branches
        branch = if branch is current then "* #{branch}" else
          colors.xterm(240)("  #{branch}")
        console.log "#{branch}"
      callback null

    voscoCLI.createBranch = (branch, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.createBranch branch, defer(error)
      callback null

    voscoCLI.selectBranch = (branch, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.selectBranch branch, defer(error)
      callback null

    voscoCLI.deleteBranch = (branch, callback) ->
      await @original.isInstalled defer(error, isInstalled)
      unless isInstalled then process.exit 1
      await @original.deleteBranch branch, defer(error)
      callback null

Export Module
-------------

    module.exports = (vosco) ->
      voscoCLI.original = vosco
      return voscoCLI
