# mktree

Builds a hierarchy of directories and files as a single asynchronous operation.

## Usage

    make tree = require 'mktree'
  
    make tree ! {
      ideas = {
        colours = {
          "green.txt" = "apples, pears"
          "white.txt" = "snow"
        }
      }
    }
    
...creates these directories and files:

    ./ideas/
    ./ideas/colours/
    ./ideas/colours/green.txt  (apples, pears)
    ./ideas/colours/white.txt  (snow)

### The root directory

By default the hierarchy is created in the current working directory.

Make a hierarchy under another directory like this:

    make tree "/base/directory" ! {
      subdir = {
        file = "contents"
      }
    }

### Deleting the files you created

Retain a reference to the original tree to destroy it later:

    my tree = make tree ! {
      subdir = {
        file = "contents"
      }
    }
    // later...
    my tree.destroy !
    
Destroying the tree is equivalent to deleting all files, then all directories and their contents, (rm -rf on all directories).
