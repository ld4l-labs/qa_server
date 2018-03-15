class AuthorityListService
  # Return a list of supported authorities
  # @returns list of authorities
  def self.list
    [
      'agrovoc_direct',
      'agrovoc_ld4l_cache',
      'dbpedia_direct',
      'dbpedia_ld4l_cache',
      'geonames_direct',
      'geonames_ld4l_cache',
      'loc_direct',
      'locnames_ld4l_cache',
      'locgenres_ld4l_cache',
      'locsubjects_ld4l_cache',
      'nalt_cornell',
      'nalt_direct',
      'nalt_ld4l_cache',
      'oclcfast_direct',
      'oclcfast_ld4l_cache'
    ]
  end

  # Return a list of supported authorities and sample URLs
  # @returns [Hash<String><Hash>] list of authorities and sample URLs
  # @example list of authorities and sample URLs
  #   {
  #     "agrovoc_direct" => {
  #       term: ["/qa/show/linked_data/agrovoc_direct/http%3A%2F%2Faims%2Efao%2Eorg%2Faos%2Fagrovoc%2Fc_9513"],
  #       search: ["/qa/search/linked_data/agrovoc_direct?q=milk&maxRecords=4"] },
  #     "dbpedia_ld4l_cache" => {
  #       term: ["/qa/show/linked_data/dbpedia_ld4l_cache/http%3A%2F%2Fdbpedia%2Eorg%2Fresource%2FBarack_Obama"],
  #       search: ["/qa/search/linked_data/dbpedia_ld4l_cache?q=Barack Obama&maxRecords=4"] }
  #   }
  def self.list_and_urls
    urls = {}
    list.each { |auth_name| urls[auth_name] = AuthorityValidatorService.url_list(auth_name) }
    urls
  end
end
