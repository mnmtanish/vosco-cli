Dependencies
============

    inquirer = require "inquirer"
    colors   = require "cli-color"

Shell
=====

    shell = {}

    shell.exit = (status) ->
      log "bye"
      process.exit status || 0

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
      log "WELCOME"

    shell.install = () ->
      message = "Do you want to install VOSCO"
      await confirm message, defer(doInstall)
      unless doInstall then @exit()
      await @vosco.install defer(error)
      @welcome()

Helpers
-------

    confirm = (msg, callback) ->
      question = {type: "confirm", name: "answer", message: msg}
      await inquirer.prompt question, defer(data)
      callback data.answer

    log = (message) ->
      console.log colors.xterm(238)("- #{message}")

Export Module
-------------

    module.exports = (vosco) ->
      shell.vosco = vosco
      return shell
