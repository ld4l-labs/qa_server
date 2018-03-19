module Validators
  class GeonamesLd4lCacheValidator < AuthorityValidatorService
    AUTHORITY_NAME = :GEONAMES_LD4L_CACHE
    SERVICE = LD4L_SERVICE

    TERM_URI = 'http://sws.geonames.org/261707/'.freeze

    AREA_SUBAUTH = 'area'.freeze
    PLACE_SUBAUTH = 'place'.freeze
    AREAPLACE_SUBAUTH = 'area_and_place'.freeze
    WATER_SUBAUTH = 'water'.freeze
    PARK_SUBAUTH = 'park'.freeze
    ROAD_SUBAUTH = 'road'.freeze
    SPOT_SUBAUTH = 'spot'.freeze
    TERRAIN_SUBAUTH = 'terrain'.freeze
    UNDERSEA_SUBAUTH = 'undersea'.freeze
    VEGETATION_SUBAUTH = 'vegetation'.freeze

    SEARCH_QUERY = 'Ithaca'.freeze
    AREA_QUERY = 'France'.freeze
    PLACE_QUERY = 'Ithaca'.freeze
    AREAPLACE_QUERY = 'Ithaca'.freeze
    WATER_QUERY = 'Cayuga'.freeze
    PARK_QUERY = 'Cayuga'.freeze
    ROAD_QUERY = 'Cayuga'.freeze
    SPOT_QUERY = 'Cayuga'.freeze
    TERRAIN_QUERY = 'Cayuga'.freeze
    UNDERSEA_QUERY = 'Pacific'.freeze
    VEGETATION_QUERY = 'Red'.freeze

    def self.test_count
      12
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, TERM_URI) == PASS
      failures += 1 unless test_search(authority, SEARCH_QUERY) == PASS
      failures += 1 unless test_search(authority, AREA_QUERY, AREA_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, PLACE_QUERY, PLACE_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, AREAPLACE_QUERY, AREAPLACE_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, WATER_QUERY, WATER_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, PARK_QUERY, PARK_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, ROAD_QUERY, ROAD_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, SPOT_QUERY, SPOT_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, TERRAIN_QUERY, TERRAIN_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, UNDERSEA_QUERY, UNDERSEA_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, VEGETATION_QUERY, VEGETATION_SUBAUTH) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, TERM_URI), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, TERM_URI, true))
      add_status(test_search(authority, SEARCH_QUERY), AUTHORITY_NAME, '', SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, SEARCH_QUERY))
      add_status(test_search(authority, AREA_QUERY, AREA_SUBAUTH), AUTHORITY_NAME, AREA_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, AREA_QUERY, AREA_SUBAUTH))
      add_status(test_search(authority, PLACE_QUERY, PLACE_SUBAUTH), AUTHORITY_NAME, PLACE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PLACE_QUERY, PLACE_SUBAUTH))
      add_status(test_search(authority, AREAPLACE_QUERY, AREAPLACE_SUBAUTH), AUTHORITY_NAME, AREAPLACE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, AREAPLACE_QUERY, AREAPLACE_SUBAUTH))
      add_status(test_search(authority, WATER_QUERY, WATER_SUBAUTH), AUTHORITY_NAME, WATER_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, WATER_QUERY, WATER_SUBAUTH))
      add_status(test_search(authority, PARK_QUERY, PARK_SUBAUTH), AUTHORITY_NAME, PARK_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PARK_QUERY, PARK_SUBAUTH))
      add_status(test_search(authority, ROAD_QUERY, ROAD_SUBAUTH), AUTHORITY_NAME, ROAD_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, ROAD_QUERY, ROAD_SUBAUTH))
      add_status(test_search(authority, SPOT_QUERY, SPOT_SUBAUTH), AUTHORITY_NAME, SPOT_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, SPOT_QUERY, SPOT_SUBAUTH))
      add_status(test_search(authority, TERRAIN_QUERY, TERRAIN_SUBAUTH), AUTHORITY_NAME, TERRAIN_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, TERRAIN_QUERY, TERRAIN_SUBAUTH))
      add_status(test_search(authority, UNDERSEA_QUERY, UNDERSEA_SUBAUTH), AUTHORITY_NAME, UNDERSEA_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, UNDERSEA_QUERY, UNDERSEA_SUBAUTH))
      add_status(test_search(authority, VEGETATION_QUERY, VEGETATION_SUBAUTH), AUTHORITY_NAME, VEGETATION_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, VEGETATION_QUERY, VEGETATION_SUBAUTH))
    end

    def self.urls
      {
        term: [term_qa_url(AUTHORITY_NAME, TERM_URI, true)],
        search: [
          search_qa_url(AUTHORITY_NAME, SEARCH_QUERY),
          search_qa_url(AUTHORITY_NAME, AREA_QUERY, AREA_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, PLACE_QUERY, PLACE_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, AREAPLACE_QUERY, AREAPLACE_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, WATER_QUERY, WATER_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, PARK_QUERY, PARK_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, ROAD_QUERY, ROAD_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, SPOT_QUERY, SPOT_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, TERRAIN_QUERY, TERRAIN_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, UNDERSEA_QUERY, UNDERSEA_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, VEGETATION_QUERY, VEGETATION_SUBAUTH)
        ]
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
