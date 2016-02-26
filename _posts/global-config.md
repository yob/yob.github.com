---
layout: default
title: Global config of ruby gems
---

* How to collect configuration data when building a rubygem.
* Avoid a global accessor on the top module/class, it's rarely the best option.
  Allow the user to create an instance of your class and pass in the config.
* Particularly when the gem is for interacting with an external API
