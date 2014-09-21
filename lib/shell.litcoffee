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
      shell[category].call shell

    shell.install = () ->
      message = "Do you want to install VOSCO"
      await confirm message, defer(doInstall)
      unless doInstall then process.exit 1
      await @vosco.install defer(error)
      @welcome()

    shell.repository = () ->
      message = "Choose a Task"
      choices = ["status", "history", "content history", "uninstall"]
      await choose message, choices, defer(task)
      shell.repository[task].call shell

    shell.repository.status = () ->
      await @vosco.getStatus defer(error)
      @welcome()

    shell.repository.history = () ->
      await @vosco.getHistory defer(error)
      @welcome()

    shell.repository['content history'] = () ->
      message = "Enter file path"
      await input message, defer(path)
      await @vosco.getContentHistory path, defer(error)
      @welcome()

    shell.repository.uninstall = () ->
      await @vosco.uninstall defer(error)
      @install()

    shell.snapshots = () ->
      message = "Choose a Task"
      choices = ["preview", "create", "rollback"]
      await choose message, choices, defer(task)
      shell.snapshots[task].call shell

    shell.snapshots.preview = () ->
      # TODO replace with list
      message = "Enter commit hash"
      await input message, defer(hash)
      await @vosco.previewSnapshot hash, defer(error)
      @welcome()

    shell.snapshots.create = () ->
      message = "Enter commit message"
      await input message, defer(message)
      await @vosco.createSnapshot message, defer(error)
      @welcome()

    shell.snapshots.rollback = () ->
      # TODO replace with list
      message = "Enter commit hash"
      await input message, defer(hash)
      await @vosco.rollbackToSnapshot hash, defer(error)
      @welcome()

    shell.branches = () ->
      message = "Choose a Task"
      choices = ["list", "create", "select", "delete"]
      await choose message, choices, defer(task)
      shell.branches[task].call shell

    shell.branches.list = () ->
      await @vosco.getBranches defer(error)
      @welcome()

    shell.branches.create = () ->
      message = "Enter branch name"
      await input message, defer(branch)
      await @vosco.createBranch branch, defer(error)
      @welcome()

    shell.branches.select = () ->
      message = "Enter branch name"
      await input message, defer(branch)
      await @vosco.selectBranch branch, defer(error)
      @welcome()

    shell.branches.delete = () ->
      message = "Enter branch name"
      await input message, defer(branch)
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

    input = (msg, callback) ->
      question = {type: "input", name: "answer", message: msg}
      await inquirer.prompt question, defer(data)
      callback data.answer

    echo = (message) ->
      console.log "#{message}"

    log = (message) ->
      console.log colors.xterm(238)("- #{message}")

Export Module
-------------

    module.exports = (vosco) ->
      shell.vosco = require("./vosco-cli")(vosco)
      return shell
