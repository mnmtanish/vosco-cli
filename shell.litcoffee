Dependencies
============

    _        = require "underscore"
    inquirer = require "inquirer"
    colors   = require "cli-color"

Shell
=====

    shell = {}

    shell.init = () ->
      log "looking for VOSCO repository at (#{@vosco.path})"
      await @vosco.isInstalled defer(error, isInstalled)
      if isInstalled
        log "found VOSCO repository"
        @welcome()
      else
        log "could not find VOSCO repository"
        @install()

    shell.welcome = () ->
      message = "Choose a Category"
      choices = ["repository", "snapshots", "branches"]
      await choose message, choices, defer(category)
      shell[category]()

    shell.install = () ->
      message = "Do you want to install VOSCO"
      await confirm message, defer(doInstall)
      unless doInstall then process.exit 1
      await @vosco.isInstalled defer(error, isInstalled)
      if isInstalled then process.exit 1
      await @vosco.install defer(error)
      @welcome()

    shell.repository = () ->
      message = "Choose a Task"
      choices = ["status", "history", "content history", "uninstall"]
      await choose message, choices, defer(task)
      switch task
        when "status"
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
        when "history"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.getHistory defer(error, history)
          for commit in history
            hash = commit.hash.substr(0, 7)
            date = new Date(commit.date).toDateString()
            msg  = commit.message
            console.log colors.xterm(240)("  #{hash}  #{date}  #{msg}")
        when "content history"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          # show warning if file doesn"t exist
          console.log "content history"
        when "uninstall"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.uninstall defer(error)
          process.exit 0
      @welcome()

    shell.snapshots = () ->
      message = "Choose a Task"
      choices = ["preview", "create", "rollback"]
      await choose message, choices, defer(task)
      switch task
        when "preview"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          hash = hash or 'HEAD'
          await @vosco.previewSnapshot hash, defer(error, diff)
          console.log diff
        when "create"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          message = message or 'Untitled Snapshot'
          await @vosco.createSnapshot message, defer(error)
        when "rollback"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.rollbackToSnapshot hash, defer(error)
      @welcome()

    shell.branches = () ->
      message = "Choose a Task"
      choices = ["list", "create", "select", "delete"]
      await choose message, choices, defer(task)
      switch task
        when "list"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.getBranches defer(error, branches, current)
          for branch in branches
            branch = if branch is current then "* #{branch}" else
              colors.xterm(240)("  #{branch}")
            console.log "#{branch}"
        when "create"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.createBranch branch, defer(error)
        when "select"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.selectBranch branch, defer(error)
        when "delete"
          await @vosco.isInstalled defer(error, isInstalled)
          unless isInstalled then process.exit 1
          await @vosco.deleteBranch branch, defer(error)
      @welcome()

Helpers
-------

    choose = (msg, choices, callback) ->
      choices.push new inquirer.Separator()
      choices.push "exit"
      question = {type: "list", name: "answer", message: msg, choices: choices}
      await inquirer.prompt question, defer(data)
      if data.answer is "exit" then process.exit 0
      callback data.answer

    confirm = (msg, callback) ->
      question = {type: "confirm", name: "answer", message: msg}
      await inquirer.prompt question, defer(data)
      callback data.answer

    echo = (message) ->
      console.log "#{message}"

    log = (message) ->
      console.log colors.xterm(238)("- #{message}")

Export Module
-------------

    module.exports = (vosco) ->
      shell.vosco = vosco
      return shell
