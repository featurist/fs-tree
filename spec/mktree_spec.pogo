fs = require 'fs'
rimraf = require 'rimraf'
mktree = require '../src/mktree'

(path) should contain (contents) =
    fs.read file sync(path, "utf-8").should.equal (contents)

describe "mktree"

    after
        rimraf.sync 'public'
  
    it "makes directories and files from nested properties"
        mktree! {
            public = {
                scripts = {
                    "app.js" = "javascript"
                }
                "index.html" = "<html />"
            }
        }
        "public/scripts/app.js" should contain "javascript"
        "public/index.html" should contain "<html />"

    it "makes directories and files from flat properties"
        mktree! {
            "public/scripts/app.js" = "javascript"
            "public/index.html" = "<html />"
        }
        "public/scripts/app.js" should contain "javascript"
        "public/index.html" should contain "<html />"

    it "accepts a base directory as an optional first argument"
        mktree! "./public" { "index.html" = "ok!" }
        "./public/index.html" should contain "ok!"
  
    it "overwrites files"
        mktree! { public = { "index.html" = "overwrite me!" } }
        mktree! { public = { "index.html" = "overwritten" } }
        "public/index.html" should contain "overwritten"
  
    it "creates empty directories"
        mktree! { public = { } }
        fs.exists sync("./public").should.be.true

    it "destroys the tree it created"
        tree = mktree! "public" { a = { b = "1" }, c = "2" }
        fs.exists sync "./public/a/b".should.be.true
        fs.exists sync "./public/c".should.be.true
        tree.destroy!
        fs.exists sync "./public".should.be.true
        fs.exists sync "./public/a".should.be.false
        fs.exists sync "./public/c".should.be.false
    
