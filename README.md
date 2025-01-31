# Home configurations


## Desing
Everything that creates options is in modules
The end user configs reside in home, where every user has theyr own file, named after themselves, where they can use my options or their own.


----


### Structure

#### Modules
These modules contain my _normal_ configurations. Everyting that is customised is located here

#### Home
each User has their own `$name.nix` file inside this directory. It contains the configuration of the modules. It is basically another abstractionlayer ontop of the existing module system.


#### feautures
Features are settings modules that contains suites of programms, to enable them in bulk. For example `development` is used to enable a bunch of programs by default, like `git` and `neovim`.


## Inspiration

A lot of this config was inspired by _tiredofit_'s [Home](https://github.com/tiredofit/home) configuration. Defintley check that out 
