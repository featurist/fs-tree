fs = require 'fs'
mktree = require '../src/mktree'

describe "mktree"

  after
    rm "./public/scripts/app.js"
    rm "./public/index.html"
    rmdir "./public/scripts"
    rmdir "./public"
  
  (path) should contain (contents) =
    fs.read file sync(path, "utf-8").should.equal (contents)
  
  rmdir (path) = 
    if (fs.exists sync (path))
      fs.rmdir sync (path)
      
  rm (path) = 
    if (fs.exists sync (path))
      fs.unlink sync (path)
    
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
