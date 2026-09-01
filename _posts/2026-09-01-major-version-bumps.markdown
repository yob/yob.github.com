---
layout: post
title: "Bumping the major version of your Javascript library is user hostile"
---

I was surprised this week to discover my employer's medium sized typescript
monorepo was using eight distinct versions of [glob](https://www.npmjs.com/package/glob) across five major version lines[^1].
glob has transitives, contributing to the repository also having seven distinct
versions of [minimatch](https://www.npmjs.com/package/minimatch) [^2] and three
distinct versions of [brace-expansion](https://www.npmjs.com/package/brace-expansion)[^3]. We only have
a single version of [slonik](https://www.npmjs.com/package/slonik), but it's gone from v33 to
v49 over three years and the upgrade path between them is not simple.

Between them, these packages have had dozens of Github security alerts in
our repository over the past 12 months. Mostly [ReDOS](https://en.wikipedia.org/wiki/ReDoS) and vulnerability classes
that are not exploitable in our specific use case, but nonetheless trigger
compute to try updates and consume valuable engineer time to triage. Even worse,
how many thousands of open source maintainers have burnt time and money dealing
with [requests to bump dependency constraints to resolve security alerts](https://github.com/jestjs/jest/issues/16291)?

The original sin was node building a dependency system that makes breaking changes
appear cheap by supporting multiple versions of each dependency at the same time.
Sadly that ship has long sailed.

I’m begging maintainers of javascript libraries: **bump the major versions on
your packages as infrequently as you can**. Allow your users to consolidate on
fewer distinct versions of your package, and reduce the upgrading, triaging, and
reviewing you’re externalising onto them.

It’s true that semantic versioning permits breaking changes in a major version
bump. However, that doesn’t obligate you to make breaking changes. What if you …
didn’t? Not forever, just for much longer. Even limiting major version bumps to
once every 2-3 years would be an improved user experience.

Can some changes be additive only, expanding the API of your library
and deprecating (but not removing) old features? Do you really need to
remove support for older node versions annually? Is removing active CI and
compatibility guarantees for older node versions even a breaking change? Do you
really need to change the default exports of your ESM package right now?

Additionally, library maintainers can help insulate their users from the
insanity in transitive dependencies and reduce their own maintenance burden:

* Avoid dependencies and peer dependencies as much as possible. At the time of writing ~47%
  of npm’s most downloaded packages in August have no dependencies, so it’s possible. Follow
  your heart with development dependencies, they have no impact on the experience of using your library
* Consider dependencies that are well behaved and bump their major version infrequently. Many popular
  libraries have slower moving alternatives available that may work just as well
* Depend on the widest version range of a package as possible. Put `axios: ^1` in your
  `package.json` if you use the basic axios API and your library will work with any 1.x release.
  Don’t let dependabot change your `package.json` to `axios: ^1.18.0` to resolve a vulnerability,
  `axios: ^1` allows your library users to trivially avoid the vulnerability downstream without
  a new release of your library
* Consider depending on multiple major versions, like `brace-expansion: ^2 || ^3 || ^4`. For
  ESM callers the basic brace expansion API did not change across those versions, and it’s
  very likely your library will work with any of them. Give your users’ package resolver as
  much flexibility to choose a de-duped vulnerability free version as you can

Finally, a shout out to some high profile packages that get this right, with
many minor versions and few (if any) major bumps over recent years:

* [debug](https://www.npmjs.com/package/debug): 4.x release line active since 2018
* [semver](https://www.npmjs.com/package/semver): 7.x release line active since 2019
* [strip-ansi](https://www.npmjs.com/package/strip-ansi): only 6.x and 7.x active since 2019
* [axios](https://www.npmjs.com/package/axios): 1.x release line VERY active since 2022

--

### Postfix

If you're a specification fan, [semver.org](https://semver.org/) has you covered:

> Q: If even the tiniest backward incompatible changes to the public API require a major
> version bump, won’t I end up at version 42.0.0 very rapidly?
>
> A: This is a question of responsible development and foresight. Incompatible changes should
> not be introduced lightly to software that has a lot of dependent code. The cost that
> must be incurred to upgrade can be significant. Having to bump major versions to release
> incompatible changes means you’ll think through the impact of your changes, and evaluate
> the cost/benefit ratio involved

[^1]: `[ "7.1.7", "7.2.3", "8.0.1", "8.1.0", "10.5.0", "11.1.0", "13.0.0", "13.0.6" ]`
[^2]: `[ "3.0.8", "3.1.5", "5.1.9", "7.4.9", "9.0.9", "10.1.1", "10.2.6" ]`
[^3]: `[ "1.1.18", "2.1.4", "5.0.9" ]`
