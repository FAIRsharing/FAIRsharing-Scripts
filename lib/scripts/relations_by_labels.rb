
module RelationsByLabels
  require_relative '../../utils.rb'
  include Utils

  #To execute it:
  # 0. "bundle exec irb" in FAIRsharing-Scripts folder
  # 1. require_relative 'lib/scripts/relations_by_labels.rb'; include RelationsByLabels
  # 2. get_relations_by_labels()
  # Results are in file lib/scripts/data/relations_by_labels.tsv

  def get_relations_by_labels()

    file = File.open("lib/scripts/data/relations_by_labels.tsv", 'w')

    labels = []
    data = query_fairsharing(query: 'get_all_relation_labels')
    data['recordAssociationLabels'].each do |l|
      labels << l['name']
    end
    stats_by_type_label= {}
    %W[standard database policy collection fairassist].each do |f|
      stats_by_type_label[f] = {}
      stats_by_type_label[f]['rec_created'] = 0
      labels.each do |l|
        stats_by_type_label[f][l] = 0
      end
      stats_by_type_label[f]['all'] = 0
    end


    data = query_fairsharing(page: 1, query: 'search_fairsharing_records')
    total_page = data['searchFairsharingRecords']['totalPages']
    (1..total_page).each do |current_page|
      data = query_fairsharing(page: current_page, query: 'search_fairsharing_records')
      data['searchFairsharingRecords']['records'].each do |rec|
        registry = rec['registry'].downcase
        stats_by_type_label[registry]['rec_created'] += 1
        rec['recordAssociations'].each do |ra|
          stats_by_type_label[registry][ra['recordAssocLabel']] += 1
          stats_by_type_label[registry]['all'] += 1
        end
      end
    end
    file.write("\tRECORDS\tTOTAL_RELATIONS")
    labels.each do |l|
      file.write("\t#{l}")
    end
    file.write("\n")
    %W[standard database policy collection fairassist].each do |f|
      file.write("#{f}\t#{stats_by_type_label[f]['rec_created']}\t#{stats_by_type_label[f]['all']}")
      labels.each do |l|
        file.write("\t#{stats_by_type_label[f][l]}")
      end
      file.write("\n")
    end
  end
end