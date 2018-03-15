class AuthorityStatusController < ApplicationController
  attr_reader :status_data
  attr_reader :latest_status

  MAX_RECORDS = '4'.freeze
  ALL_AUTHORITIES = '__all__'.freeze

  def index
    authorities_list
    validate
  end

  def authorities
    authorities_and_urls_list
  end

  def dashboard
    @latest_status = CronAuthorityStatus.first
    if refresh || @latest_status.blank? || @latest_status.dt_stamp < DateTime.yesterday.midnight
      test_count = 0
      failure_count = 0
      authorities_list.each do |auth_name|
        test_count += AuthorityValidatorService.test_count(auth_name)
        failure_count += AuthorityValidatorService.failure_count(auth_name)
      end
      @latest_status = CronAuthorityStatus.new if @latest_status.blank?
      @latest_status.dt_stamp = Time.now
      @latest_status.test_count = test_count
      @latest_status.failure_count = failure_count
      @latest_status.save
    end
    @authority_count = authorities_list.size
    render 'status', :status => :internal_server_error if @latest_status.failure_count.positive?
  end

  private
    def authority_name
      return nil unless params.key? :authority
      params[:authority].downcase
    end

    def refresh
      params.key? :refresh
    end

    def authorities_list
      @authorities_list = AuthorityListService.list
    end

    def authorities_and_urls_list
      @authorities_and_urls_list = AuthorityListService.list_and_urls
    end

    def validate
      return [] unless authority_name.present?
      return @status_data = AuthorityValidatorService.status_data(authority_name) unless authority_name == ALL_AUTHORITIES
      @status_data = []
      authorities_list.each { |auth_name| @status_data += AuthorityValidatorService.status_data(auth_name) }
    end
end
