# Regular Flolloping

tA's Blog

## Getting Started

What you need to get the generator up and running.

### Prerequisites

Assumes you have Cabal and Nix.  
Nix can be installed with:  
```
curl https://nixos.org/nix/install | sh
```  
And Cabal can be installed with your package manager of choice.

### Installing

Enter the build environment

```
nix-shell --attr env rf.nix
```

Compile the generator

```
nix-build rf.nix
```  

Generate the site

```
./result/site clean
./result/site build
```

And test it out

```
./result/site watch
```

The site will now be avaliable at `localhost:8000`

## Deployment

Site will be completely static, so simply point your server to the `_site` directory

## Built With

* [Hakyll](https://jaspervdj.be) - The web framework used
* [Nix](https://nixos.org) - Package Management
* [Cabal](https://cabal.readthedocs.io) - Build System

## Versioning

Is very airy fairy and mainly based on what I think constitutes major / minor updates.

## Authors

* **Shaun Kerr** - [tA](https://github.com/techieAgnostic)

## License

This project is licensed under the BSD3 License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hakyll for having an incredible default, of which 90% was kept
* Douglas Adam's for providing the name
* You, for reading this :)
