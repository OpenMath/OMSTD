# The OpenMath Standard (Development draft)

This repository contains the sources and build system for the OpenMath 2 standard. The
repository was initialised as copy of the original version in the
[OpenMath SVN repository](https://github.com/OpenMath/OMSVN), specifically 
[www/standard/om20-2004-06-30](https://github.com/OpenMath/OMSVN/tree/master/www/standard/om20-2004-06-30).

It has been updated with a draft version which had been prepared as dropbox om-2017-03-17.

## The Editor's Draft

The HTML and PDF versions of the standard are automatically built (by travis) from the  DocBook source upon commit to this repository. They are available as an "[editor's draft](https://openmath.github.io/standard/om20-editors-draft/)" on the [OpenMath Web Site](http://openmath.github.io).

If you want to commit without forcing Travis to rebuild, add `[ci skip]` to your commit message.

## Building locally 

To build it, just run `source ./run` on top-level. If you have `trang.jar` and
`saxon9he.jar` installed, this should build the standard for you.

* `saxon9he` is available from [sourcefourge](http://saxon.sourceforge.net/)
 * `trang` is available from [google code archive](https://code.google.com/archive/p/jing-trang/downloads)

## Contributing to the Standard Development 

We use the GitHub functionalities to openly and transparently develop the OpenMath Standard. 

### Issue Discussions

We use the [GitHub Issue Tracker](http://github.com/OpenMath/OMSTD/issues) to discuss open issues with the standard. This ensures that all concerns are dealt with properly and the current state of the discussion is documented. 

### Making a Pull Request

The best way of proposing changes to the standard development is by making a [pull request](https://gist.github.com/Chaser324/ce0505fbed06b947d962). In a nutshell 
* fork this repository to your personal namespace (using the "Fork" button on the top left [the repository page](https://github.com/OpenMath/OMSTD/)
* Make any changes in your local fork, test them by building locally, commit them to your fork, and make a new pull request via the "New pull request" button under the magentar bar (second from left). Make sure that you explain your proposed changes. 
* discuss (and possibly augment) the pull request from [the interface in the OpenMath/OMSTD repository](https://github.com/OpenMath/OMSTD/pulls).
