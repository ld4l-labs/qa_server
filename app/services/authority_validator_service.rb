require 'erb'

class AuthorityValidatorService
  class << self
    include ERB::Util
  end

  MAX_RECORDS = '4'.freeze
  PASS = :good
  FAIL = :bad
  UNKNOWN = :unknown

  TERM_ACTION = 'term'.freeze
  SEARCH_ACTION = 'search'.freeze

  DIRECT_SERVICE = 'direct'.freeze
  LD4L_SERVICE = 'ld4l_cache'.freeze

  MIN_EXPECTED_SIZE = 200
  DEFAULT_SUBAUTH = nil

  # Return the number of tests for the specified authority
  # @param [String] name of authority
  # @returns count of tests
  def self.test_count(authority_name)
    return 0 unless authority_name.present? # invalid count when authority_name is not passed in
    begin
      validator_class = validator_class(authority_name)
      validator_class.test_count
    rescue
      0 # unable to load authority
    end
  end

  # Return the number of test failures for the specified authority
  # @param [String] name of authority
  # @returns count of failed tests
  def self.failure_count(authority_name)
    return 0 unless authority_name.present? # invalid count when authority_name is not passed in
    begin
      validator_class = validator_class(authority_name)
      validator_class.failure_count
    rescue
      0 # unable to load authority
    end
  end

  # Return status data for the specified authority
  # @param [String] name of authority
  # @returns [Array<Hash>] data array for display on a status page including... authority name, subauthority name
  #   * status - :good, :bad, :unknown
  #   * status_label - √, X, ?
  #   * authority - name of the authority
  #   * subauth - name of the subauthority
  #   * service - 'direct, 'ld4l_cache', etc.
  #   * action - 'term' or 'search'
  #   * url - sample url for the authority
  def self.status_data(authority_name)
    return [] unless authority_name.present?
    @@authority_status = []
    begin
      validator_class = validator_class(authority_name)
      @@authority_status = validator_class.status_data
    rescue Exception => e
      puts "Exception: #{e.message}"
      add_status(FAIL, authority_name, '', '', '', '')
    end
    @@authority_status
  end

  # Return sample URLs for the specified authority
  # @param [String] name of authority
  # @returns [Hash<Symbol><Array>] sample term and search URLs
  # @example list of URLs
  #   { term: ["/qa/show/linked_data/agrovoc_direct/http%3A%2F%2Faims%2Efao%2Eorg%2Faos%2Fagrovoc%2Fc_9513"],
  #     search: ["/qa/search/linked_data/agrovoc_direct?q=milk&maxRecords=4"] }
  def self.url_list(authority_name)
    return {} unless authority_name.present?
    begin
      validator_class = validator_class(authority_name)
      validator_class.urls
    rescue Exception => e
      {} # unable to load or fully test authority
    end
  end

  def self.validator_class(authority_name)
    class_name = "Validators::#{authority_name.to_s.downcase.camelcase}Validator"
    class_name.constantize
  end
  private_class_method :validator_class

  def self.add_status(status, authority, subauth, service, action, url)
    case status
    when PASS
      status_label = '√'
    when UNKNOWN
      status_label = '?'
    when FAIL
      status_label = 'X'
    end
    @@authority_status << { status: status, status_label: status_label, authority: authority, subauth: subauth, service: service, action: action, url: url }
  end
  private_class_method :add_status

  def self.test_authority_status(authority_name, service)
    begin
      authority = Qa::Authorities::LinkedData::GenericAuthority.new(authority_name)
    rescue Exception => e
      add_status(FAIL, authority_name, '', service, 'ALL', '')
      return false
    end
    authority
  end
  private_class_method :test_authority_status

  def self.test_status(min_expected_size = MIN_EXPECTED_SIZE)
    begin
      results = yield if block_given?
      results.to_s.length > min_expected_size ? PASS : UNKNOWN
    rescue Exception => e
      FAIL
    end
  end
  private_class_method :test_status

  def self.url_prefix(action, authority_name, subauthority_name = DEFAULT_SUBAUTH)
    subauth = "/#{subauthority_name}" if subauthority_name
    return "/qa/show/linked_data/#{authority_name.downcase}#{subauth}/" if action == TERM_ACTION
    return "/qa/search/linked_data/#{authority_name.downcase}#{subauth}?" if action == SEARCH_ACTION
  end
  private_class_method :url_prefix

  def self.uri_encode(uri)
    url_encode(uri).gsub(".", "%2E")
  end
  private_class_method :uri_encode

  def self.test_term(authority, term, encode = false, subauth = DEFAULT_SUBAUTH)
    term = uri_encode(term) if encode
    test_status { authority.find(term, subauth: subauth) }
  end
  private_class_method :test_term

  def self.term_qa_url(authority_name, term, encode = false, subauth = DEFAULT_SUBAUTH)
    term = uri_encode(term) if encode
    "#{url_prefix(TERM_ACTION, authority_name, subauth)}#{term}"
  end
  private_class_method :term_qa_url

  def self.test_search(authority, query, subauth = DEFAULT_SUBAUTH, min_expected_size = MIN_EXPECTED_SIZE, replacements = { maxRecords: MAX_RECORDS })
    test_status(min_expected_size) { authority.search(query, subauth: subauth, replacements: replacements) }
  end
  private_class_method :test_search

  def self.search_qa_url(authority_name, query, subauth = DEFAULT_SUBAUTH, replacements = "&maxRecords=#{MAX_RECORDS}")
    "#{url_prefix(SEARCH_ACTION, authority_name, subauth)}q=#{query}#{replacements}"
  end
  private_class_method :search_qa_url
end
