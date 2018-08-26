---
title: An Idiot's Guide to Lambda Calculus
published: TBD
---

clarification: this is not a guide to lambda calculus for idiots, this is a guide to lambda calculus written by an idiot.

imagine for a second you need to explain our numbering system without ***any*** background. any at all, think about that for a second.

* you have no idea what the number symbols mean
* you have no idea what plus minus or anything mean
* you have no idea of anything

and this isn't limited to just numbering, because almost anything we do on a computer is based around maths, imagine the same for pretty much literally anything.

what you would need is....

**is**...

***is***...

## a way to describe computability

and one way of doing that is with lambda calculus. to define lambda calculus we need just a few rules - variables, abstraction, application, reduction.

these concepts aren't too difficult, so awayyyy we go.

### variables

variables are simply a name, most of the time we use letters. there are two catches here, if you're used to variables in maths or other languages:

* unlike pretty much every other language, lambda calc variables don't have a value, only a name. this is because we don't have any concept of what a value is.

* unlike any language worth using, variables in lambda calculus do not have a *type*. again this is because we don't have a concept of what type is.

this guide is gonna use lowercase letters for the most part, so the examples are `a b c d e f` etc etc

### abstraction

abstractions are the functions of lambda calc, and take the form off:

```
(λx.M)
```

where `λ` denotes that this is a function  
`x` is an argument name (that is local to this function)  
and `M` is a list of variables that will form the function body

a quick example of an abstraction is the identity function:

```
(λx.x)
```

we'll get onto more to do with fuctions in a bit, but next

### application

application is what we pretentious people call "actually using a function" and it takes the form of:

```
(M N)
```

where `M` is an abstraction, and `N` is any lambda term at all. i will refer to `M` as an abstraction and `N` as the application body

to do the application we just use `N` as the argument for `M`, and then do a find and replace based on the abstraction definition.

for example, lets do an easy one using the identity function, which is a function that returns its input unchanged:

if we have the abstraction `(λx.x)` and the variable `y` to use for the application, and then lay the application out as so:

```
( (λx.x) y )
```

we can then begin applying.

the identity function has `x` as its argument, so we take the application body, in this case `y`, and every time we see `x` in the abstraction body (the bit past `.`) we replace it with our argument, `y`.

so our abstraction body is `x`, and `x` is equal to our argument `y`, so therefore our function will return `y`, which is the identity.

a sligtly more interesting example is something like
