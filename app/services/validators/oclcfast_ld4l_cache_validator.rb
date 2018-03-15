module Validators
  class OclcfastLd4lCacheValidator < AuthorityValidatorService
    AUTHORITY_NAME = :OCLCFAST_LD4L_CACHE
    SERVICE = LD4L_SERVICE

    TERM_ID = '1914919'.freeze

    CONCEPT_SUBAUTH = 'concept'.freeze
    EVENT_SUBAUTH = 'event'.freeze
    PERSON_SUBAUTH = 'person'.freeze
    ORGANIZATION_SUBAUTH = 'organization'.freeze
    PLACE_SUBAUTH = 'place'.freeze
    INTANGIBLE_SUBAUTH = 'intangible'.freeze
    WORK_SUBAUTH = 'work'.freeze

    SEARCH_QUERY = 'mark twain'.freeze
    CONCEPT_QUERY = 'ferret'.freeze
    EVENT_QUERY = 'tribunal'.freeze
    PERSON_QUERY = SEARCH_QUERY
    ORGANIZATION_QUERY = SEARCH_QUERY
    PLACE_QUERY = 'Cayuga'.freeze
    INTANGIBLE_QUERY = SEARCH_QUERY
    WORK_QUERY = SEARCH_QUERY

    REPLACEMENTS = { maximumRecords: MAX_RECORDS }

    def self.test_count
      9
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, TERM_ID) == PASS
      failures += 1 unless test_search(authority, SEARCH_QUERY, DEFAULT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, PERSON_QUERY, PERSON_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, CONCEPT_QUERY, CONCEPT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, EVENT_QUERY, EVENT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, PLACE_QUERY, PLACE_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, WORK_QUERY, WORK_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, TERM_ID), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, TERM_ID, true))
      add_status(test_search(authority, SEARCH_QUERY, DEFAULT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, '', SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, SEARCH_QUERY, DEFAULT_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, PERSON_QUERY, PERSON_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, PERSON_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PERSON_QUERY, PERSON_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, ORGANIZATION_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, CONCEPT_QUERY, CONCEPT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, CONCEPT_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, CONCEPT_QUERY, CONCEPT_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, EVENT_QUERY, EVENT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, EVENT_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, EVENT_QUERY, EVENT_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, PLACE_QUERY, PLACE_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, PLACE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PLACE_QUERY, PLACE_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, INTANGIBLE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, WORK_QUERY, WORK_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, WORK_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, WORK_QUERY, WORK_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
    end


    def self.urls
      {
        term: [term_qa_url(AUTHORITY_NAME, TERM_ID, true)],
        search: [
          search_qa_url(AUTHORITY_NAME, SEARCH_QUERY, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, PERSON_QUERY, PERSON_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, CONCEPT_QUERY, CONCEPT_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, EVENT_QUERY, EVENT_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, PLACE_QUERY, PLACE_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, INTANGIBLE_QUERY, INTANGIBLE_SUBAUTH),
          search_qa_url(AUTHORITY_NAME, WORK_QUERY, WORK_SUBAUTH)
        ]
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
