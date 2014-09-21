Dependencies
============

    fs   = require "fs"
    path = require "path"

VOSCO
=====

    script = {}

Setup
-----

    script.install = (args) ->
      # check whether a previous installation exists
      # show warning message and exit if it does
      # "-f" flag can be used to force installation
      console.log "installing VOSCO"

    script.uninstall = (args) ->
      console.log "removing VOSCO"

Repository
----------

    script.status = (args) ->
      console.log "status"

    script.history = (args) ->
      console.log "history"

    script["content-history"] = (args) ->
      # show warning if file doesn"t exist
      console.log "content history"

Snapshots
---------

    script.preview = (args) ->
      console.log "preview snapshot"

    script.snapshot = (args) ->
      console.log "creating snapshot"

    script.rollback = (args) ->
      console.log "rollback to snapshot"

Branches
--------

    script["list-branches"] = (args) ->
      console.log "branches list"

    script["select-branch"] = (args) ->
      console.log "select branch"

    script["create-branch"] = (args) ->
      console.log "create new branch"

    script["delete-branch"] = (args) ->
      console.log "delete branch"

Export Module
-------------

    module.exports = (vosco) ->
      script.vosco = vosco
      return script
