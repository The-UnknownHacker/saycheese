# Tutorial-ish

Starting a project like this can be daunting,
which is why I've put together a semi-tutorial that gives a quick introduction to optimizing for size!
The limits of QR codes require our entire program to fit inside a binary that is less than 3 kilobytes large.
Size optimization on this scale brings a whole slew of challenges,
namely the fact that most high-level languages are unable to fit in such a small size.
Even a simple hello world program in C takes up a whopping 297 kilobytes!

There are a few different ways to get around this,
namely using languages that allow you either fine-grain control of the binary size,
or offload much of the processing to the host device.
This makes either a form of assembly language ideal for binaries,
or HTML+JavaScript for a web app

For both of these methods,
you'll need a way for your users to actually use your program ~~obviously~~.
Although you could just use a binary QR-code,
this adds lots of extra steps for your users.
The method I recommend is to use the [Data URI Scheme](https://developer.mozilla.org/en-US/docs/Web/URI/Schemes/data).
This scheme is able to accomodate both webpages and native binaries
(with the "text/html" and "application/octet-stream" media types respectively).
While this does reduce the total size of your program from 3kB to 2kB,
a pretty substantial reduction,
but it allows your users to simply scan your QR code and have you program 
either automatically opened or downloaded without any additional steps!

## Assembly

Assembly is just about the only way to build native binaries small enough to fit inside a QR code,
unless you're prepared to do some major fiddling with your preferred compiler while avoiding breaking your program.
An important aspect of assembly is that it is often architecture (and operating-system) specific.
This is both a blessing and a curse,
since you will only be able to create a program for a single system,
but you are also able to create a program for any system you can dream of.

Say Cheese is platform agnostic, meaning you're allowed to build a program for anything,
be it a common platform like x64 Windows,
or something outlandish like the TI-84 Graphing Calculator or the Nintendo GameBoy.
Whatever you desire, you can build for!

A consequence of this, however,
is that I can't possibly tell you how to optimize for every single platform.
Although, if you're looking for a way to get into Assembly programming,
make sure to check out Hack Club's own [Some Assembly Required](https://github.com/hackclub/some-assembly-required), an approchable introduction to assembly.

If you're building for Linux and you're stuck on getting the ELF file smaller than 3kB,
take a look at this [incredible guide](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html) to ELF size optimization!

## HTML+JavaScript

JavaScript is what's called an interpretted language,
which means that much of the actual work is done by another program.
For JS, this is typically a browser ~~or Node/Bun/Deno if you're feeling silly~~.
The ability of JavaScript to offload it's functionality allows it to fit in much smaller file sizes than a typical binary.

This offloading, however,
does not fully counter the heavy size constraints of a QR code.
Even the [Hackatime dashboard](https://waka.hackclub.com),
used for [High Seas](httpps://highseas.hackclub.com),
has a single base (`base.js`) that is 33kB, 
10x bigger than we can fit!

The main way to combat size in JavaScript and HTML is something called "minifying".
Essentially, getting rid of all unnecesarry blank space and long variable names.
This makes the code much less readable, but also shrinks the size considerably!
I'm much too lazy to make a custom minifyer for this site,
so I reccomend just searching for one on your favorite search engine.
