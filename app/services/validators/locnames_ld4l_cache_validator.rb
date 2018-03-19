module Validators
  class LocnamesLd4lCacheValidator < AuthorityValidatorService
    AUTHORITY_NAME = :LOCNAMES_LD4L_CACHE
    SERVICE = LD4L_SERVICE

    TERM_URI = 'http://id.loc.gov/authorities/names/n92016188'.freeze

    PERSON_SUBAUTH = 'person'.freeze
    ORGANIZATION_SUBAUTH = 'organization'.freeze
    PLACE_SUBAUTH = 'place'.freeze
    INTANGIBLE_SUBAUTH = 'intangible'.freeze
    GEOCOORDINATES_SUBAUTH = 'geocoordinates'.freeze
    WORK_SUBAUTH = 'work'.freeze

    SEARCH_QUERY = 'mark twain'.freeze
    PERSON_QUERY = SEARCH_QUERY
    ORGANIZATION_QUERY = SEARCH_QUERY
    PLACE_QUERY = 'Cayuga'.freeze
    INTANGIBLE_QUERY = 'Cayuga'.freeze
    GEOCOORDINATES_QUERY = 'Cayuga'.freeze
    WORK_QUERY = SEARCH_QUERY

    def self.test_count
      8
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, TERM_URI) == PASS
      failures += 1 unless test_search(authority, SEARCH_QUERY) == PASS
      failures += 1 unless test_search(authority, PERSON_QUERY, PERSON_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, PLACE_QUERY, PLACE_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH) == PASS
      failures += 1 unless test_search(authority, WORK_QUERY, WORK_SUBAUTH) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, TERM_URI), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, TERM_URI, true))
      add_status(test_search(authority, SEARCH_QUERY), AUTHORITY_NAME, '', SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, SEARCH_QUERY))
      add_status(test_search(authority, PERSON_QUERY, PERSON_SUBAUTH), AUTHORITY_NAME, PERSON_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PERSON_QUERY, PERSON_SUBAUTH))
      add_status(test_search(authority, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH), AUTHORITY_NAME, ORGANIZATION_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH))
      add_status(test_search(authority, PLACE_QUERY, PLACE_SUBAUTH), AUTHORITY_NAME, PLACE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PLACE_QUERY, PLACE_SUBAUTH))
      add_status(test_search(authority, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH), AUTHORITY_NAME, INTANGIBLE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH))
      add_status(test_search(authority, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH), AUTHORITY_NAME, GEOCOORDINATES_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH))
      add_status(test_search(authority, WORK_QUERY, WORK_SUBAUTH), AUTHORITY_NAME, WORK_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, WORK_QUERY, WORK_SUBAUTH))
    end

    def self.urls
      {
        term: [term_qa_url(AUTHORITY_NAME, TERM_URI, true)],
        search: [
          search_qa_url(AUTHORITY_NAME, SEARCH_QUERY),
          search_qa_url(AUTHORITY_NAME, PERSON_QUERY, PERSON_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, PLACE_QUERY, PLACE_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, WORK_QUERY, WORK_SUBAUTH)
        ]
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
