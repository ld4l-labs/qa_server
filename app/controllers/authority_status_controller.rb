class AuthorityStatusController < ApplicationController
  attr_reader :all_status

  MAX_RECORDS = '4'.freeze
  ALL_AUTHORITIES = '__all__'.freeze

  def index
    @all_status = []
    authorities_list
    validate
  end

  private
    def authority_name
      return nil unless params.key? :authority
      params[:authority].downcase
    end

    def authorities_list
      @authorities_list ||= ['agrovoc_direct',
                             'agrovoc_ld4l_cache',
                             'dbpedia_direct',
                             'dbpedia_ld4l_cache',
                             'geonames_direct',
                             'geonames_ld4l_cache',
                             'loc_direct',
                             'locnames_ld4l_cache',
                             'locgenres_ld4l_cache',
                             'locsubjects_ld4l_cache',
                             'nalt_cornell',
                             'nalt_direct',
                             'nalt_ld4l_cache',
                             'oclcfast_direct',
                             'oclcfast_ld4l_cache']
    end

    def validate
      return unless authority_name.present?
      return send("validate_#{authority_name}".to_sym) unless authority_name == ALL_AUTHORITIES
      authorities_list.each { |auth_name| send("validate_#{auth_name}".to_sym) }
    end

    def add_status(status, authority, subauth, service, action, url)
      case status
      when :good
        status_label = '√'
      when :unknown
        status_label = '?'
      when :bad
        status_label = 'X'
      end
      @all_status << { status: status, status_label: status_label, authority: authority, subauth: subauth, service: service, action: action, url: url }
    end

    def test_authority_status(authority_name, service)
      begin
        authority = Qa::Authorities::LinkedData::GenericAuthority.new(authority_name)
      rescue Exception => e
        add_status(:bad, authority_name, '', service, 'ALL', '')
        return false
      end
      authority
    end

    def test_status(authority_name, subauth, service, action, url, min_expected_size = 200)
      begin
        results = yield if block_given?
        status = results.to_s.length > min_expected_size ? :good : :unknown
        add_status(status, authority_name, subauth, service, action, url)
      rescue Exception => e
        add_status(:bad, authority_name, subauth, service, action, url)
      end
    end

    def validate_agrovoc_direct
      authority_name = :AGROVOC_DIRECT
      service = 'direct'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Faims%2Efao%2Eorg%2Faos%2Fagrovoc%2Fc_9513"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://aims.fao.org/aos/agrovoc/c_9513') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=milk&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('milk', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_agrovoc_ld4l_cache
      authority_name = :AGROVOC_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Faims%2Efao%2Eorg%2Faos%2Fagrovoc%2Fc_9513"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://aims.fao.org/aos/agrovoc/c_9513') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=milk&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('milk', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_dbpedia_direct
      authority_name = :DBPEDIA_DIRECT
      service = 'direct'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fdbpedia%2Eorg%2Fresource%2FBarack_Obama"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://dbpedia.org/resource/Barack_Obama') }
    end

    def validate_dbpedia_ld4l_cache
      authority_name = :DBPEDIA_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fdbpedia%2Eorg%2Fresource%2FBarack_Obama"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://dbpedia.org/resource/Barack_Obama') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=Barack Obama&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('Barack Obama', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_geonames_direct
      authority_name = :GEONAMES_DIRECT
      service = 'direct'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fsws%2Egeonames%2Eorg%2F261707%2F"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://sws.geonames.org/261707/') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=Ithaca&maximumRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('Ithaca', replacements: { maximumRecords: MAX_RECORDS })
      end
    end

    def validate_geonames_ld4l_cache
      authority_name = :GEONAMES_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fsws%2Egeonames%2Eorg%2F261707%2F"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://sws.geonames.org/261707/') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=Ithaca&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('Ithaca', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/area?q=France&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'area', service, 'search', url) do
        authority.search('France', subauth: 'area', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/place?q=Ithaca&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'place', service, 'search', url) do
        authority.search('Ithaca', subauth: 'place', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/area_and_place?q=Ithaca&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'area_and_place', service, 'search', url) do
        authority.search('Ithaca', subauth: 'area_and_place', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/water?q=Cayuga&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'water', service, 'search', url) do
        authority.search('Cayuga', subauth: 'water', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/park?q=Cayuga&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'park', service, 'search', url) do
        authority.search('Cayuga', subauth: 'park', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/road?q=Cayuga&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'road', service, 'search', url) do
        authority.search('Cayuga', subauth: 'road', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/spot?q=Cayuga&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'spot', service, 'search', url) do
        authority.search('Cayuga', subauth: 'spot', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/terrain?q=Cayuga&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'terrain', service, 'search', url) do
        authority.search('Cayuga', subauth: 'terrain', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/undersea?q=Pacific&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'undersea', service, 'search', url) do
        authority.search('Pacific', subauth: 'undersea', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/vegetation?q=Red&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'vegetation', service, 'search', url) do
        authority.search('Red', subauth: 'vegetation', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_loc_direct
      authority_name = :LOC_DIRECT
      service = 'direct'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/names/n92016188"
      test_status(authority_name, 'names', service, 'term', url) { authority.find('n92016188', subauth: 'names') }

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/genre/gf2011026370"
      test_status(authority_name, 'genre', service, 'term', url) { authority.find('gf2011026370', subauth: 'genre') }

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/subjects/sh85118553"
      test_status(authority_name, 'subjects', service, 'term', url) { authority.find('sh85118553', subauth: 'subjects') }
    end

    def validate_locnames_ld4l_cache
      authority_name = :LOCNAMES_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fid%2Eloc%2Egov%2Fauthorities%2Fnames%2Fn92016188"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://id.loc.gov/authorities/names/n92016188') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('mark twain', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/person?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'person', service, 'search', url) do
        authority.search('mark twain', subauth: 'person', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/organization?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'organization', service, 'search', url) do
        authority.search('mark twain', subauth: 'organization', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/work?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'work', service, 'search', url) do
        authority.search('mark twain', subauth: 'work', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_locgenres_ld4l_cache
      authority_name = :LOCGENRES_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fid%2Eloc%2Egov%2Fauthorities%2FgenreForms%2Fgf2011026141"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://id.loc.gov/authorities/genreForms/gf2011026141') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=animation&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('animation', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/person?q=animation&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'person', service, 'search', url) do
        authority.search('animation', subauth: 'person', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/organization?q=animation&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'organization', service, 'search', url) do
        authority.search('animation', subauth: 'organization', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/work?q=animation&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'work', service, 'search', url) do
        authority.search('animation', subauth: 'work', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_locsubjects_ld4l_cache
      authority_name = :LOCSUBJECTS_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Fid%2Eloc%2Egov%2Fauthorities%2Fsubjects%2Fsh2003008312"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://id.loc.gov/authorities/subjects/sh2003008312') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=science&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('science', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/person?q=science&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'person', service, 'search', url) do
        authority.search('science', subauth: 'person', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/organization?q=science&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'organization', service, 'search', url) do
        authority.search('science', subauth: 'organization', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/work?q=science&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'work', service, 'search', url) do
        authority.search('science', subauth: 'work', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_nalt_cornell
      authority_name = :NALT_CORNELL
      service = 'cornell'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Flod%2Enal%2Eusda%2Egov%2Fnalt%2F20627"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://lod.nal.usda.gov/nalt/20627') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=milk&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('milk', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_nalt_direct
      authority_name = :NALT_DIRECT
      service = 'direct'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Flod%2Enal%2Eusda%2Egov%2Fnalt%2F20627"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://lod.nal.usda.gov/nalt/20627') }
    end

    def validate_nalt_ld4l_cache
      authority_name = :NALT_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/http%3A%2F%2Flod%2Enal%2Eusda%2Egov%2Fnalt%2F20627"
      test_status(authority_name, '', service, 'term', url) { authority.find('http://lod.nal.usda.gov/nalt/20627') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=milk&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('milk', replacements: { maxRecords: MAX_RECORDS })
      end
    end

    def validate_oclcfast_direct
      authority_name = :OCLCFAST_DIRECT
      service = 'direct'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/1914919"
      test_status(authority_name, '', service, 'term', url) { authority.find('1914919') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=mark twain&maximumRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('mark twain', replacements: { maximumRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/personal_name?q=mark twain&maximumRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'personal_name', service, 'search', url, 150) do
        authority.search('mark twain', subauth: 'personal_name', replacements: { maximumRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/corporate_name?q=mark twain&maximumRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'corporate_name', service, 'search', url) do
        authority.search('mark twain', subauth: 'corporate_name', replacements: { maximumRecords: MAX_RECORDS })
      end
    end

    def validate_oclcfast_ld4l_cache
      authority_name = :OCLCFAST_LD4L_CACHE
      service = 'ld4l_cache'
      authority = test_authority_status(authority_name, service)
      return unless authority

      url = "#{main_app.root_path}qa/show/linked_data/#{authority_name.downcase}/1914919"
      test_status(authority_name, '', service, 'term', url) { authority.find('1914919') }

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, '', service, 'search', url) do
        authority.search('mark twain', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/concept?q=ferret&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'concept', service, 'search', url) do
        authority.search('ferret', subauth: 'concept', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/event?q=tribunal&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'event', service, 'search', url) do
        authority.search('tribunal', subauth: 'event', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/intangible?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'intangible', service, 'search', url) do
        authority.search('mark twain', subauth: 'intangible', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/organization?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'organization', service, 'search', url) do
        authority.search('mark twain', subauth: 'organization', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/person?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'person', service, 'search', url, 150) do
        authority.search('mark twain', subauth: 'person', replacements: { maxRecords: MAX_RECORDS })
      end

      url = "#{main_app.root_path}qa/search/linked_data/#{authority_name.downcase}/work?q=mark twain&maxRecords=#{MAX_RECORDS}"
      test_status(authority_name, 'work', service, 'search', url, 150) do
        authority.search('mark twain', subauth: 'work', replacements: { maxRecords: MAX_RECORDS })
      end
    end
end
