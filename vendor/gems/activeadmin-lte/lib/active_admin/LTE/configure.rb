module ActiveAdmin::LTE
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    #yield(configuration)
  end

  class Configuration
    attr_accessor :skin
    attr_accessor :mini_title

    def initialize
      @skin = 'blue'
    end
  end
end
