# Provide service methods for getting a list of all authorities and scenarios for an authority.
class AuthorityListerService

  # Return a list of supported authorities
  # @return [Array<String>] list of authorities
  def self.authorities_list
    LINKED_DATA_AUTHORITIES_CONFIG.keys.sort
  end

  # Fill in status_log with data about each scenario for an authority
  # @param authority_name [String] the name of the authority
  # @param status_log [ScenarioLogger] the log that will hold the data about the scenarios
  def self.scenarios_list(authority_name:, status_log:)
    scenarios = ScenariosLoaderService.load(authority_name: authority_name, status_log: status_log)
    return if scenarios.blank?
    list_terms(scenarios, status_log)
    list_searches(scenarios, status_log)
  end

  private

    def self.list_terms(scenarios, status_log)
      scenarios.term_scenarios.each { |scenario| TermScenarioValidator.new(scenario: scenario, status_log: status_log).log_without_running }
    end

    def self.list_searches(scenarios, status_log)
      scenarios.search_scenarios.each { |scenario| SearchScenarioValidator.new(scenario: scenario, status_log: status_log).log_without_running }
    end
end
