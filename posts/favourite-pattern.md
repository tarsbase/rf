---
title: My Favourite Programming Pattern
published: 2018-08-29
---

so at work we were talking about interviewer questions for graduates, and one of them was the standard simple test to weed out graduates who faked it till they made it. it went something like this:

> you are given a list of characters, please return the list with commas seperating each element. do not leave a trailing comma.

there may have been language restrictions or something, honestly i wasnt paying a huge amount of attention, but it got me thinking about my honest answer to that, and here is what i came up with.

in my favourite language of course, Haskell:

```
join' :: [Char] -> ([Char] -> [Char])
join' (x:xs) = (x:) . dropLast . (join' xs)
   where
      dropLast = if (xs /= []) then (',':) else (id)
join' [] = id

answer :: [Char] -> [Char]
answer x = join' x $ []
```

for people who don't know haskell, heres a quick run down of the important parts.

the function will look at the first character in the list, and partially apply it to the prepend function `:`

in haskell you can partially apply functions, which means if you have a function taking two arguments, only give it one, and get back a new function that takes a single argument.

in the case of prepend, `x:` is a function that will take another list, and return that list prepended with `x`, ie

```
'a' : ['b', 'c', 'd'] == "abcd" == ['a', 'b', 'c', 'd']
```

we then compose that function with one of two functions returned by `dropLast`, dependending on whether `x` is the last character in the list. 

composing is done with `.`, and simply is a way to chain functions together. ie:

```
(f . g)(x) == f(g(x))
```

if the character we're looking at isn't the last, then we add another prepend for a comma. if it is the last, we add the `id` function into the mix, which just returns the input unchanged.

after that we recurse with the tail of the list.

at the end of this we aren't given a comma seperated list like you'd think, we're given a function. for the input `"abcd"` our function is something like:

```
'a' : ',' : 'b' : ',' : 'c' : ',' : 'd' : id
```

which is a function that takes a list of characters, and returns a list of characters. to get our answer we need to give this function an argument, and the argument we want is an empty list.

the steps this function goes through build up the list from the back, prepending one character at a time, until we get our answer:

```
"a,b,c,d"
```

## but... why?

i like this pattern for a few reasons, whether they're valid or not is up to you.

### its not super slow.

this one is more applicable to haskell, but the naive way to do this (outside of using a prebuilt function) would be to use `++` and just go through each character adding it and a comma to a final output string.

strings in haskell are lists, and lists are linked lists under the hood. so appending anything requires traversing the entire list, and doing so in the way described above ends up being `O(n^2)`

the prepend function method, however, is much faster. prepending takes constant time, so doing so as shown only ends up being `O(n)` which is far *far* better.

### it uses id

this is one of the few times i get to honestly use the `id` function for something other than teaching how lambda calculus works, so it gets points for that.

### its fun and different

you can't discount this, programming is a hobby and therefore should be fun. not much more to say about that.

## where else?

another time this method is great, and possibly a cooler example, is for getting the traversal of a tree.

this has the same problem when done naively of being an `O(n^2)` operation due to all the list appending, however we can convert it to create a prepend function chain which cuts it down to `O(n)`. yay :)

the idea here is to recursively go down the tree, like you would normally, but at each node instead of recursing left, appending the root, then recursing right, we instead compose an extra prepend operation, and as a base case, when there is no child we instead prepend `id` and keep going.

---

i really like this pattern, it is in fact my favourite. someone please come up with a nice name for it i can't.

thanks for listening.

close this world. txen eht nepo
