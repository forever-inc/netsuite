module NetSuite
  module Actions
      class mapSSO

        def initialize(attributes = {})
          @attributes = attributes
        end

        def self.call(attributes)
          new(attributes).call
        end

        def call
          response = NetSuite::Configuration.connection.request :map_sso do
            soap.header =  NetSuite::Configuration.auth_header
            soap.body = {
              :entityId    => @attributes[:entity_id],
              :companyName => @attributes[:company_name],
              :unsubscribe => @attributes[:unsubscribe]
            }
          end
          success = response.to_hash[:map_sso_response][:write_response][:status][:@is_success] == 'true'
          body    = response.to_hash[:map_sso_response][:write_response][:base_ref]
          NetSuite::Response.new(:success => success, :body => body)
        end
      end
  end
end

# response = NetSuite::Actions::map_sso.call(
#   :entity_id    => 'Shutter Fly',
#   :company_name => 'Shutter Fly, Inc.',
#   :unsubscribe  => false
# )                 # => #<NetSuite::Response:0x1041f64b5>
# response.success? # => true
# response.body     # => { :internal_id => '979', :type => 'customer' }