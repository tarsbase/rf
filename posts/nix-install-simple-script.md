---
title: Installing a Simple Script in Nix // NixOS
published: 2018-08-20
---

so readers here are probably in one of two groups of people:

* people i know irl
* people from irc / discord

and luckily a single thing is true of both sections, we'll start with the easy one:

### people from irc / discord

if you use irc you're a functional programming nerd. no arguments.  
if you use discord then you're probably a nerd, at the very least you're not popular, and therefore you probably like functional programming, no arguments.

### people i know irl

you know me, and that means there's approximately a 100% chance you've heard me go on about functional programming ***at great length*** with the type of loving obsession that would cause an innocent bystander to (understandably) believe we were talking about a woman with a ***stonking pair of titter totters***, and thus, discussions on functional programming are nothing new to you at all, however one-sided.

## the actual article

> disclaimer: i know sweet country bumpkiss about this, but who knows maybe its still helpful

so with that out of the way, lets talk about something thats pretty fuarking computers, and that thing is [NixOS](https://nixos.org), and its package manager that if it were a person would have one magnum package, [Nix](https://nixos.org/nix/)

to put things briefly, nix is a functional package manager that is filled with awesome awesome features, and nixos is the operating system built around it that is fuarking black magic.

installing packages in nix are done through **nix derivations**, a piece of code written in nix that defines the parameters for building the package.

nix is weird to get into because it does things like **not have a /bin** or baically any other file structure that any other version of linux has, so theres some caveats to installing things.

this article will run through packaging a simple script, namely my [Swatch Beats Script](https://github.com/techieAgnostic/swatch)

swatch beats are pretty fizzityucking radical, but thats for another post. in essence they are a new time format, and i like to have them in my prompt, which is why i wrote this script and why i want to install it in nixos. sue me.

## the initial problems

so there are two main problems with this script that prevent us from just running it like we might in other distros:

* there is no `/bin/bash`
* our equivilent of `/bin/` is read-only

which is why we need a derivation to install it the way god intended (referring of course to Jon Osterman)

## step 1

we create a file called `swatch.nix` to place our derivation in, and will be using a tool called `mkDerivation` which is part of the `stdenv` library in nix.

`stdenv` provides us with many tools you might expect to find in a (ST)an(D)ard linux (ENV)ironment, such a `mv`, `echo`, `cp` etc etc, as well as a lot of nix specific things, in this case `mkDerivation`

now nix things are purely functional which means if we want to use any of the standard tools we need to pass them into the function. so lets begin `swatch.nix` like so

```
{ stdenv }:

stdenv.mkDerivation rec {

}
```

which tells the function its allowed to use stdenv stuff, and also begins our call to mkDerivation. the `rec` bit, i have been informed, allows the following attribute set (the bit between the curly brackets) to refer to itself recursively if need be, and its one of those things where if i remove it it doesnt work anymore so lets just leave it there for now.

now we can start to fill out the call.

## step 2

to start with we'll add some meta data to the package. the important one is the name, which is where into the nix store (`/nix/store/`, the nixos equivilent to `/bin/`) it will be placed.

generally this is in the form of `name-version` because its possible to have multiple versions of the same package installed at the same time (or even multiple versions of the same version of a package).

so add the following:

```
{ stdenv }:

stdenv.mkDerivation rec {
   name = "swatch-${version}";
   version = "1.0.0";
}
```

and now we can move on to the actual meta tag that has all the stuff package repositories like you to have. to do this we add a new set to the call:

```
{ stdenv }:

stdenv.mkDerivation rec {
   name = "swatch-${version}";
   version = "1.0.0";
   meta = {
      description = "Display the current swatch beats";
      longDescription = ''
         d i s p l a y   t h e   c u r r e n t   s w a t c h   b e a t s
      '';
      homepage = https://github.com/techieAgnostic/swatch/;
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ "Shaun Kerr (tA) - s@p7.co.nz" ];
      platforms = stdenv.lib.platforms.all;

   };
}
```

the things that may be new here are the `stdenv.lib.licenses.bsd3` bit, which is simply a variable defined as part of `stdenv` we can reference, and the square bracket notation, which creates a set (although this one only has one item in it).

there is also the double quote notation `\'\'`, which is just a multi line string.

now we're on to the meat and potatoes.

## step 3

so the basic steps for installing a script would be:

* download the script from somewhere
* install it to your preferred folder

which is exactly what we're gonna do, but with a ***twist***

this script is a single file, so we can use the `fetchurl` utility to grab it. this is **not** part of `stdenv` so we will need to add it to the first line in much the same way, and then we can define what we're going to download, in this case the script file from a specific commit to the repo (for reproducibility).

```
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
   name = "swatch-${version}";
   version = "1.0.0";
   meta = {
      description = "Display the current swatch beats";
      longDescription = ''
         Prints out the current Swatch Internet Time.
         Has the option for a short version.
      '';
      homepage = https://github.com/techieAgnostic/swatch/;
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ "Shaun Kerr (tA) - s@p7.co.nz" ];
      platforms = stdenv.lib.platforms.all;
   };
   repoUrl = "https://raw.githubusercontent.com/techieAgnostic/swatch";
   commit = "008f121290029a422af10328fc69f8f310cb19d5";
   src = fetchurl {
      url = "${repoUrl}/${commit}/swatch";
      sha256 = "e373ab25e713eac78e5ea0647a3f511e1e21a635691d7167c9420cb838bf4d71";
   };
}
```

the checksum can be calculated using the `sha256sum` program from `coreutils`.

this will download whatever is at src, and place it in `/tmp` for us to work on

now we need to move it into the right place, which is a bit weird in nix. `mkDerivation` has a bunch of predefined phases it will execute, with predefined behaviour unless we override them. these phases are all built for much larger programs, so we're only going to use two.

add the line

```
phases = "installPhase fixupPhase"
```

to tell nix we only want to use those two.

the **installPhase** is where we move our script into the nix store. the phase defines an environment variable `$out` which is the path to the programs folder in the store. this is useful because the actual path contains a big fuck-off hash at the start, and we don't know that ourselves.

the behaviour we want is pretty simple for this, so lets go ahead and override it by adding the following:

```
installPhase = ''
   mkdir -p $out/bin
   cp ${src} $out/bin/swatch
   chmod +x $out/bin/swatch
'';
```

the only piece of sneakiness here is that nix expects there to be a `/bin` in the `$out` directory, so we have to make that ourselves.

the **fixupPhase** is a nix specific thing, and is there to change things that would work on normal linux, but not in hipster linux. the main thing that this script trips up is there being no `/bin/bash` so our `#!/bin/bash` at the top of the file doesn't work, but in a larger program it may be things like there not being any standard libraries where the program things they are.

the standard behaviour for the fixupPhase is to do a find/replace on the `#!` lines to make them work, which is exactly what we want so we do not need to redefine this phase. null perspiration there.

once you've done this the whole derivation should look as follows:

```
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
   name = "swatch-${version}";
   version = "1.0.0";
   meta = {
      description = "Display the current swatch beats";
      longDescription = ''
         Prints out the current Swatch Internet Time.
         Has the option for a short version.
      '';
      homepage = https://github.com/techieAgnostic/swatch/;
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ "Shaun Kerr (tA) - s@p7.co.nz" ];
      platforms = stdenv.lib.platforms.all;
   };
   repoUrl = "https://raw.githubusercontent.com/techieAgnostic/swatch";
   commit = "008f121290029a422af10328fc69f8f310cb19d5";
   src = fetchurl {
      url = "${repoUrl}/${commit}/swatch";
      sha256 = "e373ab25e713eac78e5ea0647a3f511e1e21a635691d7167c9420cb838bf4d71";
   };
   phases = "installPhase fixupPhase";
   installPhase = ''
      mkdir -p $out/bin
      cp ${src} $out/bin/swatch
      chmod +x $out/bin/swatch
   '';
}
```

and is ready to be tested

## step fant4stic

to test this we can use the `nix-build` utility to install the package to a local folder rather than to the proper nix store. to do this we need to write a quick nix expression to call the package derivation (normally this would be part of a larger repository).

create `default.nix` with the following:

```
with import <nixpkgs> { };

rec {
   swatch = pkgs.callPackage ./swatch.nix { };
}
```

and we'll test our derivation by running `nix-build default.nix`.

assuming all goes well you'll find the result in a symlinked folder `./result/bin/swatch` and it will run fine.

## step five

once the derivation works you can add it to your main nixos configuration to install it system wide. this can be done by adding it to the `environment.systemPackages` set in your nixos configuration like so:

```
environment.systemPackages = with pkgs; [
   otherPackage1
   otherPackage2
   (callPackage /home/shaun/nds/swatch.nix { })
];
```

and a quick rebuild should have the script installed normally ^.^

## closing up

this is pretty basic stuff as far as nix is concerned, but it took me ages with about four different articles and irc open to figure it all out, so hopefully this helps someone work out how to get their script they need for their shitty rice avaliable to them.

peace out ny'all, ima bounce.
