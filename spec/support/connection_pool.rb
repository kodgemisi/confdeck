class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = {}

  def self.connection
    @@shared_connection[self.connection_config[:database]] ||= retrieve_connection
  end
end