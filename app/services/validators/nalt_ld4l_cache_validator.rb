module Validators
  class NaltLd4lCacheValidator < AuthorityValidatorService
    AUTHORITY_NAME = :NALT_LD4L_CACHE
    SERVICE = LD4L_SERVICE

    TERM_URI = 'http://lod.nal.usda.gov/nalt/20627'.freeze
    SEARCH_QUERY = 'milk'.freeze

    def self.test_count
      2
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, TERM_URI) == PASS
      failures += 1 unless test_search(authority, SEARCH_QUERY) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, TERM_URI), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, TERM_URI, true))
      add_status(test_search(authority, SEARCH_QUERY), AUTHORITY_NAME, '', SERVICE, SEARCH_ACTION, search_qa_url(AUTHORITY_NAME, SEARCH_QUERY))
    end

    def self.urls
      {
        term: [term_qa_url(AUTHORITY_NAME, TERM_URI, true)],
        search: [search_qa_url(AUTHORITY_NAME, SEARCH_QUERY)]
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
