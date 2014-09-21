Dependencies
============

    fs     = require "fs"
    path   = require "path"
    {exec} = require "child_process"
    VOSCO  = require "vosco"

    Shell  = require "./shell"
    Script = require "./script"

Sanity Checks
-------------

VOSCO must always be run by the **root** user. Using `sudo` is also acceptable. VOSCO is designed to manage system wide configurations and needs read/write access to many restricted files of the system.

    # do ->
    #   await exec "id -u", defer(error, stdout, stderr)
    #   unless parseInt(stdout) is 0
    #     console.log "VOSCO must be run as root user"
    #     process.exit()

Initialize VOSCO
----------------

    vosco = do ->
      repo_path = process.env.VOSCO_ROOT_DIR || '/'
      repo_opts =
        author_name : process.env.USER
        author_email: "#{process.env.USER}@#{process.env.HOSTNAME}"
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
      script[command](args)
    else do ->
      filePath = path.resolve __dirname, "help-text.txt"
      helpText = fs.readFileSync filePath
      console.log helpText.toString()
