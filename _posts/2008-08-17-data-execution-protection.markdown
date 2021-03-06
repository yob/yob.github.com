---
layout: post
---
I was just bitten by a feature of recent Windows OS's that I hadn't encountered
before: [Data Execution Protection](http://en.wikipedia.org/wiki/Data_Execution_Prevention).

It allows pages of memory to be marked as executable or non-executable, which
sounds reasonable to me, as it can prevent malicious data that ends up in a
'data' chunk of memory (via a buffer overflow attack or something) from
causing much damage.

DEP is enabled by default on Windows XP SP2 and above, and Windows Server 2003,
but only works at full effectiveness if the CPU supports it as well.

In my case, I'm replacing an old P4 based 2003 server with a Core 2 Quad based
one. An application that worked fine on the old server was refusing to load on
the new one, displaying the following cryptic error message as the only clue:

    The application failed to initialize properly (0xC0000005). Click OK to terminate the application.

A bit of googling turned up [this
site](http://www.updatexp.com/0xC0000005.html) which put me on the path to a
solution.

It turns out some badly coded applications (like this one) require their data
chunks of memory to be executable. To exclude an application from DEP, open the
system control panel, select the advanced tab, open performance settings,
select the DEP tab, and add the bothersome application to the exclusion list.

I suspect in our case, the issue isn't the application itself but the mediocre
library it uses to render GUI widgets: [CA Visual
Objects](http://www.cavo.com/)
