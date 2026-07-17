
module RecordsByYearCreatedSubject
  require_relative '../../utils.rb'
  require 'date'
  include Utils

  #To execute it:
  # 0. "bundle exec irb" in FAIRsharing-Scripts folder
  # 1. require_relative 'lib/scripts/records_by_year_created_subject.rb'; include RecordsByYearCreatedSubject
  # 2. get_records_by_year_subject()
  # Results are in file lib/scripts/data/records_by_year_subjects.tsv

  def get_records_by_year_subject()
    file = File.open("lib/scripts/data/records_by_year_subjects.tsv", 'w')
    init_date = Date.new(2014, 1, 1)
    date_today = Date.today
    stats_by_year = {}
    subject_labels = ['Natural Science', 'Engineering Science', 'Humanities and Social Science', 'Subject Agnostic']
    (init_date.year..date_today.year).each do |y|
      stats_by_year[y] = {}
      stats_by_year[y]['created'] = 0
      subject_labels.each do |sub_im|
        stats_by_year[y][sub_im] = 0
      end
    end
    subject_labels.each do |sub|
      data = query_fairsharing(page: 1, subject: sub, query: 'search_fairsharing_records')
      total_page = data['searchFairsharingRecords']['totalPages']
      (1..total_page).each do |current_page|
        data = query_fairsharing(page: current_page, subject: sub, query: 'search_fairsharing_records')
        data['searchFairsharingRecords']['records'].each do |rec|
          dat = rec['createdAt']
          y = dat.split('-')[0].to_i
          stats_by_year[y]['created'] += 1
          stats_by_year[y][sub] += 1
        end
      end
    end
    file.write("YEAR\tRECORDS_CREATED")
    subject_labels.each do |sub_im|
      file.write( "\t#{sub_im}")
    end
    file.write("\n")
    (init_date.year..date_today.year).each do |y|
      file.write("#{y}\t#{stats_by_year[y]['created']}")
      subject_labels.each do |f|
        file.write("\t#{stats_by_year[y][f]}")
      end
      file.write("\n")
    end
  end
end