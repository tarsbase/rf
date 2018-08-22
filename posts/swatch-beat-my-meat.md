---
title: Swatch Beat (My Meat)
published: 2018-08-23
---

i really like swatch internet time. does that make me a hipster? probably.

## eggs

**swatch internet time** is a time system developed by Swatch Ltd., a company that made digital watches, as a marketing gimmick for their 1999 line of watches. the supposed goal was to simplify the way we keep time, and create a standard that would match the use-cases of a new generation of internet enabled children.

it was promptly forgotten about.

i personally hope for a resurrection in the usage of swatch time amongst the nerds and unpopular weirdos. the time is now. join us.

## milk

the basics of swatch beats are based on a decimal system - the day is split up into sections that are divisible by 10, rather than 12 and 60 like our regular time.

these sections are called ***beats***, and there are one thousand of them in a day compared to the 86400 seconds or fourteen forty minutes.

already a plus, as long as we count in a decimal system, its easier to do math with decimally divisive numbers. we can see this with how the metric system is easy and the imperial system is ***fuarking garbáge***.

each **beat** is the same amount of time as **eighty six point four** seconds, so about a minute and a half. the day starts (sort of) at @000 beats, and ends at @999 - no groupings of hours and minutes, no conversions needed, just one kay beats and nothing else.

there are no time zones or daylight savings time in swatch beats, instead, @000 is defined as 00:00 utc+1, or midnight in sweden. this has pros and cons, i like to ignore the cons and pretend they don't exist.

the main pro is that ***time zones give me an aneurysm and make me feel like a dumbass***, and with them gone its a lot easier to sort events in the near future. for example

>hello friend from another country, i am going to be ready to partake in some multiplayer entertainment at @084, does that suit you?

>howdy fellow human. @084 beats suits me fine and i did not require the expendenture of a large portion of my mind in order to figure that out, despite our differing time zones. also i am most definitely not a spider.

the cons are that dates get tricky as, unless you're in sweden, the swatch day changes at some point during the section of time you're awake.

## flour

a quick run-down of the spec, and conversion:

   * `@XXX` is the standard way of writing the current time. zero padded to three digits.
   * `@XXX.YYY` is the way i like to write the current time, showing some sort of "semi-beats". each semi-beat is worth 1/86.4 of a second.
   * `dDD.MM.YY` is the standard way to write the current date, as determined by UTC+1 time.
   * `.XXX` or `.XXX.YYY` is the standard way to write "XXX time from now".
   * conversion from UTC+1 to Swatch Beats can be done as so:

```
(UTC+1seconds + (UTC+1minutes * 60) + (UTC+1hours * 3600)) / 86.4
```

with any floating point digits truncated depending on preference.

## bread

liking swatch internet time probably makes you a hipster. if you're the sort of person that made it through this article and still think "man, gimme some of that" you probably use something other than qwerty or azerty, and own a "normal people scare me shirt", but thats rad and i rate it.

swatch internet time is for the same people who think its cool to recompile their kernel and read fantasy stories online. its for the nerds and the geek and the losers, and its time we were proud of that.

join me in making this standard, the standard.

---

while i'm on topic i'll shill my little script for if you want swatch beats as part of a system tray or bash prompt or something, hope you enjoy.

[Swatch Beats Script](https://github.com/techieAgnostic/swatch)

peace out guys, catcha on the flip-side. make like an alligator and seeya later.
