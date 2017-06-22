# The OpenMath Standard (Development draft)

This repository contains the sources and build system for the OpenMath 2 standard. The
repository was initialised as copy of the original version in the
[OpenMath SVN repository](https://github.com/OpenMath/OMSVN), specifically 
[www/standard/om20-2004-06-30](https://github.com/OpenMath/OMSVN/tree/master/www/standard/om20-2004-06-30).

It has been updated with a draft version which had been prepared as dropbox om-2017-03-17.

To build it, just run `source ./run` on top-level. If you have `trang.jar`, `rxp`, and
`saxon9he.jar` installed, this should build the standard for you.


rxp is inessential, if you do not have it just comment that line out of the run build script.

saxon9he is available from [sourcefourge](http://saxon.sourceforge.net/)

trang is available from [google code archive](https://code.google.com/archive/p/jing-trang/downloads)
