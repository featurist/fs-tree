(function() {
    var self = this;
    var fs, async, mkdirp, rimraf, path, write, destroyable, flatten, mergeInto;
    fs = require("fs");
    async = require("async");
    mkdirp = require("mkdirp");
    rimraf = require("rimraf");
    path = require("path");
    module.exports = function() {
        var self = this;
        var root, tree, done, entries;
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
        return write(entries, done);
    };
    write = function(entries, done) {
        var writeFile;
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
                    return done(err, destroyable(entries));
                });
            }
        });
    };
    destroyable = function(entries) {
        return {
            destroy: function(done) {
                var self = this;
                return async.forEachSeries(Object.keys(entries.files), fs.unlink, function(err) {
                    if (err) {
                        return done(err);
                    } else {
                        return async.forEachSeries(entries.dirs, rimraf, done);
                    }
                });
            }
        };
    };
    flatten = function(obj, prefix) {
        var dirs, files, gen1_items, gen2_i, key, objectPath, children;
        dirs = [];
        files = {};
        gen1_items = Object.keys(obj);
        for (gen2_i = 0; gen2_i < gen1_items.length; ++gen2_i) {
            key = gen1_items[gen2_i];
            objectPath = prefix + key;
            if (obj[key].constructor === {}.constructor) {
                dirs.push(objectPath);
                children = flatten(obj[key], objectPath + "/");
                dirs = dirs.concat(children.dirs);
                mergeInto(children.files, files);
            } else {
                files[objectPath] = obj[key];
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
}).call(this);