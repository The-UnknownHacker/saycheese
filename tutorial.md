# Tutorial-ish

Starting a project like this can be daunting,
which is why I've put together a semi-tutorial that details a how to get started and how to optimize for size!
The limits of QR codes require our entire program to fit inside a binary that is less than 3 kilobytes large.
Size optimization on this scale brings a whole slew of challenges,
namely the fact that most high-level languages are unable to fit in such a small size.
Even a simple hello world program in C takes up a whopping 297 kilobytes!

There are a few different ways to get around this,
namely using languages that allow you either fine-grain control of the binary size,
or offload much of the processing to the host device.
This makes either a form of assembly language ideal for binaries,
or HTML+JavaScript for a web app! 

# Assembly

# HTML+JavaScript

JavaScript is what's called an interpretted language,
which means that much of the actual processing is done by another program.
For JS, this is typically a browser ~~or Node/Bun/Deno if you're feeling silly~~.
The ability of JavaScript to offload it's functionality allows it to fit in much smaller file sizes than a typical binary.

This offloading, however,
does not fully counter the heavy size constraints of a QR code.
Even the [Hackatime dashboard](https://waka.hackclub.com),
used for [High Seas](httpps://highseas.hackclub.com),
has a single base (`base.js`) that is 33kB, 
10x bigger than we can fit!

The main way to combat size in JavaScript and HTML is something called "minifying".
Essentially, 
