#### Revisitations

Ruby service framework for http://revisit.link services.

##### Add a service

bundle exec rake services:add

##### Run locally

bundle exec rackup

##### Deploy your own

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

##### Multi-buildpack

If you want to install imagemagick on your heroku instance, add these lines to .buildpack:

```
https://github.com/mcollina/heroku-buildpack-imagemagick
https://github.com/heroku/heroku-buildpack-ruby.git
```

and set the buildpack URL:

```
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi
```