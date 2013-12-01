fs = require 'fs'
async = require 'async'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'
path = require 'path'

module.exports () =
    if (arguments.length == 2)
        root = "."
        tree = arguments.0
        done = arguments.1
    else
        root := arguments.0
        tree := arguments.1
        done := arguments.2

    entries = flatten (tree, "#(root)/")
    write (entries, done)

write (entries, done) =
    write file (file path, written) =
        mkdirp (path.dirname(file path))
            fs.write file (file path, entries.files.(file path), written)

    async.for each series (entries.dirs, mkdirp) @(err)
        if (err)
            done (err)
        else
            async.for each (Object.keys (entries.files), write file) @(err)
                done (err, destroyable (entries))

destroyable (entries) =
    {
        destroy (done) =
            async.for each series (Object.keys (entries.files), fs.unlink) @(err)
                if (err)
                    done (err)
                else
                    async.for each series (entries.dirs, rimraf, done)
    }

flatten (obj, prefix) =
    dirs = []
    files = {}
    for each @(key) in (Object.keys (obj))
        object path = prefix + key
        if (obj.(key).constructor == {}.constructor)
            dirs.push(object path)
            children = flatten (obj.(key), "#(object path)/")
            dirs := dirs.concat(children.dirs)
            merge (children.files) into (files)
        else
            files.(object path) = obj.(key)

    { dirs = dirs, files = files }

merge (obj) into (other) =
    for @(key) in (obj)
        other.(key) = obj.(key)
