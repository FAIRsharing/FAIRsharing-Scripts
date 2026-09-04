
module RecordsByObjectType
  require_relative '../../utils.rb'
  include Utils

  #To execute it:
  # 0. "bundle exec irb" in FAIRsharing-Scripts folder
  # 1. require_relative 'lib/scripts/records_by_object_type.rb'; include RecordsByObjectType
  # 2. get_records_by_object_type()
  # Results are in file lib/scripts/data/records_by_object_types.tsv

  def get_records_by_object_type()
    file = File.open("lib/scripts/data/records_by_object_type.tsv", 'w')
    rec_ot = {}
    data = query_fairsharing(page: 1, subject: 'REMOVE', query: 'search_fairsharing_records')
    total_page = data['searchFairsharingRecords']['totalPages']
    (1..total_page).each do |current_page|
      data = query_fairsharing(page: current_page, subject: 'REMOVE', query: 'search_fairsharing_records')
      data['searchFairsharingRecords']['records'].each do |rec|
        rec['objectTypes'].each do |ot|
          rec_ot[ot['label']] = 0 unless rec_ot.include?(ot['label'])
          rec_ot[ot['label']] += 1
        end
      end
    end
    file.write("OBJECT_TYPE\tNUM_RECORDS\n")
    rec_ot.each do |k, v|
      file.write( "#{k}\t#{v.to_s}\n")
    end
    file.close

  end
end
