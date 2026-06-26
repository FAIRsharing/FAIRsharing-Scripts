# FAIRsharing-Scripts

A variety of user scripts for getting statistics on FAIRsharing records, etc. etc.

## To Install

Install RVM, then run `bundle install`.

## To Use

```
% bundle exec irb                                                                                             /.../FAIRsharing-Scripts 10:06
3.4.2 :001 > require_relative 'utils.rb'; include Utils
3.4.2 :001 > data = query_fairsharing(id: 1547, query: 'get_fairsharing_record')
```