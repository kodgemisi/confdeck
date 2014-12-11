#ConfDeck

[![Build Status](https://travis-ci.org/kodgemisi/confdeck.svg?branch=development)](https://travis-ci.org/kodgemisi/confdeck)
[![Code Climate](https://codeclimate.com/github/kodgemisi/confdeck/badges/gpa.svg)](https://codeclimate.com/github/kodgemisi/confdeck)
[![Test Coverage](https://codeclimate.com/github/kodgemisi/confdeck/badges/coverage.svg)](https://codeclimate.com/github/kodgemisi/confdeck)

ConfDeck is a conference management tool for small or big organizations. It's especially good for conferences where speakers are expected to apply first and then they are evaluated by a committee and then accepted or rejected. ConfDeck aims to ease this speaker application process.

Only a Few ConfDeck Features:

* Create your conference 
* Add organization(s) who arranges the event 
* Add sponsor(s) if any 
* Add separate and detailed schedule for every day of conference for every room that a speak will take place 
* Your conference page is created automatically with all necessary part already filled 
* Get speaker applications 
* Discuss and evaluate speaker applications 
* Committee members can vote and comment on applications 
* Applications can be accepted or rejected and aplicants are informed via email

Configuration
-------------

* Confdeck uses localeapp for its translation service. You need to add a LoCALEAPP_KEY environment value to work with localeapp correctly. You can get your api key from https://www.localeapp.com/.


Contributing
------------

To get Confdeck running follow those commands:

* Fork and clone the project
* Go in project folder

```
# make sure you're using ruby-2
$ rvm list

rvm rubies

   ruby-1.9.3-p545 [ x86_64 ]
=* ruby-2.1.2 [ x86_64 ]

# => - current
# =* - current && default
#  * - default

$ rvm gemset create confdeck
$ rvm use 2.1.2@confdeck
$ rvm gemset list

gemsets for ruby-2.1.2 (found in /home/theuser/.rvm/gems/ruby-2.1.2)
   (default)
=> confdeck

$ bundle install --without production
$ rails s
```


Special thanks to [john.pozy](www.twitter.com/pampersdry) for contributing the project by giving his [Adminre Admin Theme](http://themeforest.net/item/adminre-responsive-admin-theme/7133307)
