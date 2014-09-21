Dependencies
============

    fs     = require "fs"
    path   = require "path"
    {exec} = require "child_process"
    VOSCO  = require "vosco"

    Shell  = require "./lib/shell"
    Script = require "./lib/script"

Sanity Checks
-------------

VOSCO must always be run with **root** previliges. It is expected to run with `sudo` command by logged in user. VOSCO is designed to manage system wide configurations and needs read/write access to many restricted files. The program will stop unless the user id is zero.

    await exec "id -u", defer(error, userId)
    unless parseInt(userId) is 0
      console.error "VOSCO must be run as root user"
      process.exit 1

Initialize VOSCO
----------------

    vosco = do ->
      repo_path = process.env.VOSCO_ROOT_DIR || '/'
      repo_opts =
        author_name : process.env.USER
        author_email: "#{process.env.USER}@localhost"
      return new VOSCO repo_path, repo_opts

    shell  = Shell(vosco)
    script = Script(vosco)

Script or Interactive
---------------------

If no arguments are given, we assume that user wishes to enter an interactive shell to run VOSCO commands. Otherwise assume user needs to run specific commands.

    command = process.argv[2]
    args    = process.argv.slice 3

    if command is undefined
      shell.init()
    else if typeof script[command] is 'function'
      script[command].apply script, args
    else do ->
      filePath = path.resolve __dirname, "help-text.txt"
      helpText = fs.readFileSync filePath
      console.log helpText.toString()
