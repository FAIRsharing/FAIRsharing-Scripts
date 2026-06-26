require 'httparty'
require 'json'
require 'dotenv/load'
require 'pathname'

# Utility functions common to all FAIR tests.
module Utils

  # This will get a record from the FAIRsharing database via the API.
  # TODO: Currently the data are very extensive, but we may need only metadata and perhaps relations.
  def query_fairsharing(id: nil, query:)
    headers = {
      'Content-Type' => 'application/json' ,
      'Accept' => 'application/json',
      'X-GraphQL-Key' => ENV['FAIRSHARING_API_KEY']
    }

    query = "#{query}.graphql"

    unless query.to_s.match?(/\A[\w.-]+\z/)
      return {
        message: "Invalid GraphQL query filename: #{query}",
      }
    end

    queries_dir = Pathname.new(__dir__).join('queries')
    query_path = queries_dir.join(query).cleanpath

    unless query_path.to_s.start_with?("#{queries_dir.cleanpath}#{File::SEPARATOR}") && query_path.file?
      return {
        message: "GraphQL query file not found: #{query}",
      }
    end

    query_string = query_path.read
    query_string = query_string.gsub('__ID__', JSON.generate(id.to_s)[1...-1]) unless id.nil?

    response = HTTParty.post(ENV['FAIRSHARING_API_URL'],
                             body: { query: query_string }.to_json,
                             headers: headers
    )


    if response.code == 200
      begin
        JSON.parse(response.body)['data']
      rescue
        {}
      end
    else
      {
        message: "Error getting record from FAIRsharing API: #{response.code}, #{response.message}",
      }
    end
  end


end
