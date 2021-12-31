---
layout: post
title: "Type Checking a Ruby Gem with Sorbet"
---

I'm writing less ruby than I used too so I haven't had much chance to try out
[sorbet](https://sorbet.org/), the type checker built by Stripe.

My experience with type checking in golang has made me curious though, and the
similar-but-not-sorbet type checking experiments in ruby 3.0 and 3.1 suggest
type checking might be part of the ruby landscape going forward.

Experimenting on a large codebase at [work](https://buildkite.com) is tricky
though, so to see how it works I've been playing in
[pdf-reader](https://github.com/yob/pdf-reader/) - a ruby gem I mantain. It's
modestly sized, has no databases or complex state to manage, and has no
collaborators I need to coordinate with.

## The Result

pdf-reader 2.7.0 ships with some type annotations in the gem. They're in an rbi
file within the gem rather than inline, and users of pdf-reader who also use
sorbet will find much of their use of the PDF::Reader namespace will be type
checked.

Here's an example that incorrectly uses a string argument instead of an integer:

```ruby
# typed: true

require 'pdf/reader'

PDF::Reader.open("somefile.pdf") do |pdf|
  puts pdf.page("1").text
end
```

And a sorbet type check will flag this file like so:

```
$ bundle exec srb tc
./foo.rb:6: Expected Integer but found String("1") for argument num https://srb.help/7002
     6 |  puts pdf.page("1").text
                        ^^^
  Expected Integer for argument num of method PDF::Reader#page:
    /home/jh/.rbenv/versions/3.0.3/lib/ruby/gems/3.0.0/gems/pdf-reader-2.8.0/rbi/pdf-reader.rbi:28:
    28 |    sig { params(num: Integer).returns(PDF::Reader::Page) }
                         ^^^
  Got String("1") originating from:
    ./foo.rb:6:
     6 |  puts pdf.page("1").text
                        ^^^
Errors: 1
```

## How I got there

Much of the documentation for sorbet assumes types are being added to an
application rather than a publicly shipped ruby gem.

In that context, the type annotations can go inline with methods like this:

```ruby
class PDF::Reader
  extend T::Sig

  sig { params(num: Integer).returns(PDF::Reader::Page) }
  def page(num)
    ...
  end
end
```

That's no good for most ruby gems though. Extending `T::Sig` means the gem
needs a run time dependency on `sorbet`, and all users of pdf-reader would
suddenly gain a transitive runtime dependency on a native extension - even if
they don't want it.

For a gem I wanted the type annotations stored in rbi files, separate from the
source files. This makes them more awkward to work with for development, but
also means they're an optional enhancement for users that want them.

Through trial and error, the process looked something like this. First, The
basic [Getting Started process from the sorbet
docs](https://sorbet.org/docs/adopting):

1. Add sorbet to the Gemfile (but not a runtime dep in the gemspec)
2. `bundle exec srb init` in the project root to initialize the `sorbet/` directory
3. `bundle exec srb tc`. Type checking isn't enabled yet, but this will flush out syntax and undefined constant errors
4. Add the `typed: true` sigil to the top of source files that we want sorbet to type check
5. [Add a CI step that fails the build if type checking fails](https://github.com/yob/pdf-reader/blob/b31d65b2f83069bc5e4aba15ae2f1972016409c6/.buildkite/pipeline.yml#L2-L6)
6. Commit the `sorbet/` directory and updated source files to git

With the basics out of the way, I was ready to start annotating types. I
ignored the docs that suggest adding these inline in the source files, and
instead added them into a single file: `rbi/pdf-reader.rbi` that is included in
my published gems.

To get started, I auto generated the rbi file and then adjusted it over time:

1. Add parlour to the Gemfile (but not a runtime dep in the gemspec)
2. Run `bundle exec parlour` a few times, tweaking the [config file](https://github.com/yob/pdf-reader/blob/b31d65b2f83069bc5e4aba15ae2f1972016409c6/.parlour) until I was happy with the result
3. Run `bundle exec srb tc` to confirm the type annotations are working and not causing any type checking failures
4. Start changing a few of the type annotations from `T.untyped` to real types (`String`, `Numeric`, etc) and re-run `bundle exec srb tc` to confirm no failures
5. Commit `rbi/` to git and [update the gemspec to include it in the gem](https://github.com/yob/pdf-reader/blob/b31d65b2f83069bc5e4aba15ae2f1972016409c6/pdf-reader.gemspec#L9)

Working with the type annotations in separate files to the source has been.....
awkward. I'm not sure if parlour will be the right tool going forward - I'm
hoping to explore alternative tooling that will make keeping the rbi file in
sync a bit easier. For now though, parlour and some hand editing is where I'm
at.

## References

* The [pull request that initially adds sorbet to pdf-reader](https://github.com/yob/pdf-reader/pull/361)
* The rbi-file solution to the error: [Use of undeclared variable @abc https://srb.help/6002](https://github.com/yob/pdf-reader/pull/415)
* The rbi-file solution to [asserting a user-provided param is non-nil, when sorbet thinks such a check is impossible](https://github.com/yob/pdf-reader/pull/396)
