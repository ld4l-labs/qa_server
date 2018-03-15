module Validators
  class LocDirectValidator < AuthorityValidatorService
    AUTHORITY_NAME = :LOC_DIRECT
    SERVICE = DIRECT_SERVICE

    NAMES_SUBAUTH = "names".freeze
    SUBJECT_SUBAUTH = "subjects".freeze
    GENRE_SUBAUTH = "genre".freeze
    CLASSIFICATION_SUBAUTH = "classification".freeze
    CHILD_SUBJECT_SUBAUTH = "child_subject".freeze
    DEMOGRAPHIC_SUBAUTH = "demographic".freeze
    PERFORMANCE_SUBAUTH = "music_performance".freeze

    NAME_ID = "n92016188".freeze
    SUBJECT_ID = "sh85118553".freeze
    GENRE_ID = "gf2011026370".freeze
    CLASSIFICATION_ID = "KF26.L383".freeze
    CHILD_SUBJECT_ID = "sj96006043".freeze
    DEMOGRAPHIC_ID = "dg2015060550".freeze
    PERFORMANCE_ID = "mp2013015171".freeze

    def self.test_count
      7
    end

    def self.failure_count
      authority = test_authority
      return test_count unless authority

      failures = 0
      failures += 1 unless test_term(authority, NAME_ID, false, NAMES_SUBAUTH) == PASS
      failures += 1 unless test_term(authority, SUBJECT_ID, false, SUBJECT_SUBAUTH) == PASS
      failures += 1 unless test_term(authority, GENRE_ID, false, GENRE_SUBAUTH) == PASS
      failures += 1 unless test_term(authority, CLASSIFICATION_ID, false, CLASSIFICATION_SUBAUTH) == PASS
      failures += 1 unless test_term(authority, CHILD_SUBJECT_ID, false, CHILD_SUBJECT_SUBAUTH) == PASS
      failures += 1 unless test_term(authority, DEMOGRAPHIC_ID, false, DEMOGRAPHIC_SUBAUTH) == PASS
      failures += 1 unless test_term(authority, PERFORMANCE_ID, false, PERFORMANCE_SUBAUTH) == PASS
      failures
    end

    def self.status_data
      authority = test_authority
      return unless authority

      add_status(test_term(authority, NAME_ID, false, NAMES_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, NAME_ID, false, NAMES_SUBAUTH))
      add_status(test_term(authority, SUBJECT_ID, false, SUBJECT_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, SUBJECT_ID, false, SUBJECT_SUBAUTH))
      add_status(test_term(authority, GENRE_ID, false, GENRE_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, GENRE_ID, false, GENRE_SUBAUTH))
      add_status(test_term(authority, CLASSIFICATION_ID, false, CLASSIFICATION_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, CLASSIFICATION_ID, false, CLASSIFICATION_SUBAUTH))
      add_status(test_term(authority, CHILD_SUBJECT_ID, false, CHILD_SUBJECT_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, CHILD_SUBJECT_ID, false, CHILD_SUBJECT_SUBAUTH))
      add_status(test_term(authority, DEMOGRAPHIC_ID, false, DEMOGRAPHIC_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, DEMOGRAPHIC_ID, false, DEMOGRAPHIC_SUBAUTH))
      add_status(test_term(authority, PERFORMANCE_ID, false, PERFORMANCE_SUBAUTH), AUTHORITY_NAME, '', SERVICE, TERM_ACTION, term_qa_url(AUTHORITY_NAME, PERFORMANCE_ID, false, PERFORMANCE_SUBAUTH))
    end

    def self.urls
      {
        term: [
          term_qa_url(AUTHORITY_NAME, NAME_ID, false, NAMES_SUBAUTH),
          term_qa_url(AUTHORITY_NAME, SUBJECT_ID, false, SUBJECT_SUBAUTH),
          term_qa_url(AUTHORITY_NAME, GENRE_ID, false, GENRE_SUBAUTH),
          term_qa_url(AUTHORITY_NAME, CLASSIFICATION_ID, false, CLASSIFICATION_SUBAUTH),
          term_qa_url(AUTHORITY_NAME, CHILD_SUBJECT_ID, false, CHILD_SUBJECT_SUBAUTH),
          term_qa_url(AUTHORITY_NAME, DEMOGRAPHIC_ID, false, DEMOGRAPHIC_SUBAUTH),
          term_qa_url(AUTHORITY_NAME, PERFORMANCE_ID, false, PERFORMANCE_SUBAUTH)
        ],
        search: []
      }
    end

    def self.test_authority
      test_authority_status(AUTHORITY_NAME, SERVICE)
    end
  end
end
