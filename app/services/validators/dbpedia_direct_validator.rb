module Validators
  class DbpediaDirectValidator < AuthorityValidatorService
    AUTHORITY_NAME = :DBPEDIA_DIRECT
    SERVICE = DIRECT_SERVICE

    TERM_URI = 'http://dbpedia.org/resource/Barack_Obama'.freeze

    def self.test_count
      1
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, TERM_URI) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, TERM_URI), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, TERM_URI, true))
    end

    def self.urls
      {
        term: [term_qa_url(AUTHORITY_NAME, TERM_URI, true)],
        search: []
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
