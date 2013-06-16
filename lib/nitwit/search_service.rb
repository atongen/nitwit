module Nitwit
  module SearchService
    extend self

    def search(client, options = {})
      query = options[:query]
      latitude = options[:latitude]
      longitude = options[:longitude]
      max_id = options[:max_id]

      return [] unless query.present?

      opts = {}
      if latitude.present? && longitude.present?
        opts[:geocode] = "#{latitude},#{longitude},#{ENV['SEARCH_RADIUS']}"
      end
      if max_id.present?
        opts[:max_id] = max_id
      end

      client.search(query, opts)
    end
  end
end
