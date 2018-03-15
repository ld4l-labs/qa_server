module Validators
  class OclcfastDirectValidator < AuthorityValidatorService
    AUTHORITY_NAME = :OCLCFAST_DIRECT
    SERVICE = DIRECT_SERVICE

    TERM_ID = '1914919'.freeze

    PERSON_SUBAUTH = 'person'.freeze
    ORGANIZATION_SUBAUTH = 'organization'.freeze
    TOPIC_SUBAUTH = 'topic'.freeze
    EVENTNAME_SUBAUTH = 'event_name'.freeze
    GEOCOORDINATES_SUBAUTH = 'geocoordinates'.freeze
    TITLE_SUBAUTH = 'uniform_title'.freeze
    PERIOD_SUBAUTH = 'period'.freeze
    FORM_SUBAUTH = 'form'.freeze
    ALTLC_SUBAUTH = 'alt_lc'.freeze

    SEARCH_QUERY = 'mark twain'.freeze
    PERSON_QUERY = SEARCH_QUERY
    ORGANIZATION_QUERY = SEARCH_QUERY
    TOPIC_QUERY = 'Cayuga'.freeze
    EVENTNAME_QUERY = 'Festival'.freeze
    GEOCOORDINATES_QUERY = 'Cayuga'.freeze
    TITLE_QUERY = SEARCH_QUERY
    PERIOD_QUERY = '1276-1285'.freeze
    FORM_QUERY = 'animation'.freeze
    ALTLC_QUERY = 'animation'.freeze

    REPLACEMENTS = { maximumRecords: MAX_RECORDS }

    def self.test_count
      11
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, TERM_ID) == PASS
      failures += 1 unless test_search(authority, SEARCH_QUERY, DEFAULT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, PERSON_QUERY, PERSON_SUBAUTH, 150, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, TOPIC_QUERY, TOPIC_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, EVENTNAME_QUERY, EVENTNAME_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, TITLE_QUERY, TITLE_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, PERIOD_QUERY, PERIOD_SUBAUTH, 50, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, ALTLC_QUERY, ALTLC_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures += 1 unless test_search(authority, FORM_QUERY, FORM_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, TERM_ID), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, TERM_ID, true))
      add_status(test_search(authority, SEARCH_QUERY, DEFAULT_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, '', SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, SEARCH_QUERY, DEFAULT_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, PERSON_QUERY, PERSON_SUBAUTH, 150, REPLACEMENTS), AUTHORITY_NAME, PERSON_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PERSON_QUERY, PERSON_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, ORGANIZATION_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, TOPIC_QUERY, TOPIC_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, TOPIC_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, TOPIC_QUERY, TOPIC_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, EVENTNAME_QUERY, EVENTNAME_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, EVENTNAME_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, EVENTNAME_QUERY, EVENTNAME_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, GEOCOORDINATES_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, TITLE_QUERY, TITLE_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, TITLE_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, TITLE_QUERY, TITLE_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, PERIOD_QUERY, PERIOD_SUBAUTH, 50, REPLACEMENTS), AUTHORITY_NAME, PERIOD_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, PERIOD_QUERY, PERIOD_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, FORM_QUERY, FORM_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, FORM_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, FORM_QUERY, FORM_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
      add_status(test_search(authority, ALTLC_QUERY, ALTLC_SUBAUTH, MIN_EXPECTED_SIZE, REPLACEMENTS), AUTHORITY_NAME, ALTLC_SUBAUTH, SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, ALTLC_QUERY, ALTLC_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"))
    end

    def self.urls
      {
        term: [term_qa_url(AUTHORITY_NAME, TERM_ID, true)],
        search: [
          search_qa_url(AUTHORITY_NAME, SEARCH_QUERY),
          search_qa_url(AUTHORITY_NAME, PERSON_QUERY, PERSON_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, ORGANIZATION_QUERY, ORGANIZATION_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, TOPIC_QUERY, TOPIC_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, EVENTNAME_QUERY, EVENTNAME_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, GEOCOORDINATES_QUERY, GEOCOORDINATES_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, TITLE_QUERY, TITLE_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, PERIOD_QUERY, PERIOD_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, FORM_QUERY, FORM_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}"),
          search_qa_url(AUTHORITY_NAME, ALTLC_QUERY, ALTLC_SUBAUTH, "&maximumRecords=#{MAX_RECORDS}")
        ]
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
