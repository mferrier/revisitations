#### Revisitations

Ruby service framework for http://revisit.link services.

##### Add a service

bundle exec rake services:add

##### Deploy your own

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

##### Multi-buildpack

If you want to install imagemagick on your heroku instance, uncomment the lines in .buildpack and set the buildpack URL:

heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi