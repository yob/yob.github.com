---
layout: post
title: Slug Considerations with Ruby on Rails
---

It's common in Rails applications to alter default URLs (like `/users/1`) to
include slugs (like `/users/1-james-healy`) for readability or perceived SEO
benefits.

## Format

A variety of options are available when choosing a slug format, and three I've
commonly seen are:

1. Surrogate ID then text (`1-james-healy`)
2. Text then surrogate ID (`james-healy-1`)
3. Just text (`james-healy`)

The first is the easiest to implement in rails and very common. The second is
only slightly harder to implement, and is arguably slightly more readable by
humans.

The third option is tempting for maximum readability and hiding of
implementation details, but I've found it difficult to work with over the long
term. Slugs of this form are usually based on a natural attribute of the entity
(user name, product name, etc) and then stored in the database for lookup. If
the natural attribute changes (people can change their name, companies rebrand)
should the slug remain unchanged to keep URLs and google rankings unmodified,
or should the slug change and a redirect be put in place? Neither option is
ideal.

In my experience, option three is best kept for situations where the natural
attribute is highly unlikely to change, possibly entities like tags, currencys
and classifications. Options one or two will keep your site flexible to changing
requirements and messy real-world data.

## ASCII?

My experience is limited to English and French users, but in both cases I've
found it acceptable to limit slugs to ASCII characters only. In rails, utf-8 characters
in a URL are perfectly acceptable, however I've seen plenty of non-browser software
mangle multi-byte UTF-8 characters in URLs and lead to failing requests.

My preferred approach is:

* strip accents and other embelishments from charaters that have similar looking counterparts in the ASCII range
* downcase everything
* replace '&' with 'and'
* convert remaining non-ASCII characters to an ASCII hyphen (-)
* convert any adjacent hyphens (---) into a single hyphen (-)

The outcome is poor for non-latin scripts (Japanese, Arabic, etc) but hopefully
acceptable if supporting such scripts isn't required.
