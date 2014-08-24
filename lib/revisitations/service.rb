class Revisitations::Service
  SERVICES = {}

  class << self
    def register(name, klass)
      SERVICES[name] = klass
    end

    def names
      SERVICES.keys
    end

    def [](service_name)
      SERVICES[service_name]
    end
  end

  def initialize(body)
    @body = body
  end

  def run
  end

  def log(msg, level = :info)
    Revisitations::Server.log(msg, level)
  end
end