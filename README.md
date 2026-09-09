# FAIRsharing-Scripts

<!-- QUALITY_BADGE_START -->
[![Software quality](https://img.shields.io/badge/FAIRness-24%25-red "score: 24% | passed: 10 | failed: 31 | errors: 1")](RSFC_REPORT.md)
<!-- QUALITY_BADGE_END -->

A variety of user scripts for getting statistics on FAIRsharing records, etc. etc.

## To config
.env file needs your FAIRsharing API key (see the example file)

## To Install

Install RVM, then run `bundle install`.

## To Use

```
% bundle exec irb   in FAIRsharing-Scripts folder                                                                                          /.../FAIRsharing-Scripts 10:06
3.4.2 :001 > require_relative 'lib/scripts/records_by_date_created.rb'; include RecordsByDateCreated
3.4.2 :001 > get_records_by_date_created()
```
Results are stored in files in the folder lib/scripts/