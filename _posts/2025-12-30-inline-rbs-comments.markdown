---
layout: post
title: Inline RBS Comments for a Rubygem Codebase
---
Back in 2021 [I wrote about my experiments adding sorbet types to a rubygem codebase](/2021/12/31/sorbet-with-gems.html).
I remain type-curious in 2025 (particularly now that I'm writing more Typescript than Ruby), enjoying the developer
experience benefits of type checking and an IDE integrated Language Server.

Sorbet was historically built for application codebases, where a runtime
dependency on sorbet was a decision a team could reasonably make. For a gem like
[pdf-reader](https://rubygems.org/gems/pdf-reader) though, a runtime dependency
on sorbet is a no-go. I want the benefits of type checking for development and
CI workflows, without imposing such a heavy native dependency on users.

The 2021 experiment worked, with caveats:

> Working with the type annotations in separate files to the source has been… awkward

Given that experience, I was [intruiged to see
Shopify announce support for RBS-style type annotations in
sorbet](https://railsatscale.com/2025-04-23-rbs-support-for-sorbet/) in early 2025, using
inline comments that require no runtime depencency.

The announcment has this as an example:

```ruby
#: (Array[String]) -> String
def greet(names)
  "Hello, #{names.join(", ")}!"
end

class User
  #: String?
  attr_reader :nickname

  #: (String, String?) -> void
  def initialize(name, nickname = nil)
    @name = name #: String
    @nickname = nickname #: String?
  end
end
```

Would this allow me to move the pdf-reader type annotations inline with the code, simplifying
ongoing maintenance?

[I gave it a crack](https://github.com/yob/pdf-reader/pull/562), and the answer
was **yes***. For the specific use case of type annotating a ruby gem codebase,
inline RBS type annotations are a significiantly better experience.

Starting from v2.15.0, pdf-reader:

* has type annotations defined inline using RBS comments
* no longer has an RBI file commited to the repository
* uses [spoom](https://rubygems.org/gems/spoom) to dynamically generates an RBI in CI for inclusion in gems published to rubygems.org, so downstream users have access to type annotations for sorbet to use. (command: `spoom srb sigs export`)
* continues to use sorbet for typechecking during CI for all builds

Is it weird to move from all-sorbet to having a foot in each of Ruby's
two competing type hinting ecosystems? For this specific use case,
it has so far been all upside. The [sorbet docs list a number of
caveats](https://sorbet.org/docs/rbs-support) to using RBS inline comments while
continuing to use sorbet to typecheck, but pdf-reader's needs are modest and
none of the caveats have been a problem yet.

## Bonus Upside

Additionally, there was a tangible improvement to the typing capabilities. Previously with RBI types stored in an
external file [sorbet struggled to support annotating class constants](https://github.com/sorbet/sorbet/issues/5137). That
left constants like this with no type hints:

```ruby
class Buffer
  TOKEN_WHITESPACE = [0x00, 0x09, 0x0A, 0x0C, 0x0D, 0x20]
  TOKEN_DELIMITER = [0x25, 0x3C, 0x3E, 0x28, 0x5B, 0x7B, 0x29, 0x5D, 0x7D]
```

With inline RBS comments, these are easy to annotate:

```ruby
class Buffer
  TOKEN_WHITESPACE=[0x00, 0x09, 0x0A, 0x0C, 0x0D, 0x20] #: Array[Integer]
  TOKEN_DELIMITER=[0x25, 0x3C, 0x3E, 0x28, 0x5B, 0x7B, 0x29, 0x5D, 0x7D] #: Array[Integer]
```

## Developer Experience

Here's how [helix](https://helix-editor.com/) shows a type error when I'm developing locally:

![Helix displaying an inline type error](/images/sorbet-error-helix.png)

... and [here's how CI fails when a type error gets that far](https://buildkite.com/yob-opensource/pdf-reader/builds/792/steps/canvas?sid=019b68ea-90ee-454c-8f2a-0b6c51cc5b38):

![Sorbet displaying a type error in CI](/images/sorbet-error-buildkite.png)
