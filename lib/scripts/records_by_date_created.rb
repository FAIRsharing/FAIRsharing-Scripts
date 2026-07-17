
module RecordsByDateCreated
  require_relative '../../utils.rb'
  require 'date'
  include Utils

  #To execute it:
  # 0. "bundle exec irb" in FAIRsharing-Scripts folder
  # 1. require_relative 'lib/scripts/records_by_date_created.rb'; include RecordsByDateCreated
  # 2. get_records_by_date_created()
  # Results are in file lib/scripts/data/records_by_date.ts
  def get_records_by_date_created()
    file = File.open("lib/scripts/data/records_by_date.tsv", 'w')
    file.write("DATE|ALL|STANDARD|DATABASE|POLICY|COLLECTION|ALL_ADDED|STANDARD_ADDED|DATABASE_ADDED|POLICY_ADDED|COLLECTION_ADDED\n")
    results = {}
    results_added ={}
    %W[ all standard database policy collection fairassist].each do |w|
      results[w] = {}
      results_added[w] = {}
    end


    data = query_fairsharing(page: 1, subject: 'REMOVE', query: 'search_fairsharing_records')
    total_page = data['searchFairsharingRecords']['totalPages']
    oldest_date =  Date.new(2100, 1, 1)
    (1..total_page).each do |current_page|
      data = query_fairsharing(page: current_page, subject: 'REMOVE', query: 'search_fairsharing_records')
      data['searchFairsharingRecords']['records'].each do |rec|
        dat = rec['createdAt']
        year = dat.split('-')[0]
        month = dat.split('-')[1]
        day = dat.split('-')[2][0..1]
        date = Date.new(year.to_i, month.to_i, day.to_i)
        oldest_date = date if date < oldest_date
        registry = rec['registry'].downcase
        dat_string = year+","+ month
        results[registry][dat_string] = 0 unless results[registry].key?(dat_string)
        results[registry][dat_string] += 1
        results['all'][dat_string] = 0 unless results["all"].key?(dat_string)
        results['all'][dat_string] += 1
      end
      current_month = Date.today.month
      current_year = Date.today.year
      %W[all standard database policy collection].each do |reg|
        (oldest_date.month..12).each { |m|
          month = (m <10)? "0"+m.to_s : m.to_s
          dat_string = oldest_date.year.to_s+","+month
          results[reg][dat_string] = 0 unless results[reg].key?(dat_string)
        }
        (oldest_date.year+1..current_year-1).each { |y|
          (1..12).each { |m|
            month = (m <10)? "0"+m.to_s : m.to_s
            dat_string = y.to_s+","+month
            results[reg][dat_string] = 0 unless results[reg].key?(dat_string)
          }
        }
        (1.. current_month).each { |m|
          month = (m <10)? "0"+m.to_s : m.to_s
          dat_string =  current_year.to_s+","+month
          results[reg][dat_string] = 0 unless results[reg].key?(dat_string)
        }
      end
      %W[all standard database policy collection].each do |reg|
        sorted_hash =  results[reg].sort_by { |key| key }.to_h
        results[reg] = sorted_hash
        add = 0
        sorted_hash.each do |i|
          add = add + i[1]
          results_added[reg][i[0]] = add
        end
      end
      results['all'].each do |l|
        aux = "#{l[0]}|#{l[1]}|#{results['standard'][l[0]]}|#{results['database'][l[0]]}|#{results['policy'][l[0]]}|#{results['collection'][l[0]]}"
        file.write("#{aux}|#{results_added['all'][l[0]]}|#{results_added['standard'][l[0]]}|#{results_added['database'][l[0]]}|#{results_added['policy'][l[0]]}|#{results_added['collection'][l[0]]}\n")
      end

    end
  end
end