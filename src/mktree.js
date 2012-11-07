((function() {
    var self = this;
    var fs, async, mkdirp, flatten, mergeInto;
    fs = require("fs");
    async = require("async");
    mkdirp = require("mkdirp");
    module.exports = function() {
        var self = this;
        var root, tree, done, entries, path, writeFile;
        if (arguments.length === 2) {
            root = ".";
            tree = arguments[0];
            done = arguments[1];
        } else {
            root = arguments[0];
            tree = arguments[1];
            done = arguments[2];
        }
        entries = flatten(tree, root + "/");
        path = require("path");
        writeFile = function(filePath, written) {
            return mkdirp(path.dirname(filePath), function() {
                return fs.writeFile(filePath, entries.files[filePath], function(err) {
                    return written(err);
                });
            });
        };
        return async.forEachSeries(entries.dirs, mkdirp, function(err) {
            if (err) {
                return done(err);
            } else {
                return async.forEach(Object.keys(entries.files), writeFile, function(err) {
                    return done(err);
                });
            }
        });
    };
    flatten = function(obj, prefix) {
        var dirs, files, gen1_items, gen2_i, key, path, children;
        dirs = [];
        files = {};
        gen1_items = Object.keys(obj);
        for (gen2_i = 0; gen2_i < gen1_items.length; ++gen2_i) {
            key = gen1_items[gen2_i];
            path = prefix + key;
            if (obj[key].constructor === {}.constructor) {
                dirs.push(path);
                children = flatten(obj[key], path + "/");
                dirs = dirs.concat(children.dirs);
                mergeInto(children.files, files);
            } else {
                files[path] = obj[key];
            }
        }
        return {
            dirs: dirs,
            files: files
        };
    };
    mergeInto = function(obj, other) {
        var key;
        for (key in obj) {
            (function(key) {
                other[key] = obj[key];
            })(key);
        }
        return void 0;
    };
})).call(this);