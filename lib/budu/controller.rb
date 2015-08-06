require 'erubis'
require 'budu/file_model'
require 'rack/request'

module Budu
  class Controller
    include Budu::Model
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, '')

      Budu.to_underscore(klass)
    end

    def render(view_name, locals = {})
      # default file path
      file_name = File.join("app","views", controller_name, "#{view_name}.html.erb")
      template = File.read(file_name)
       
      eruby = Erubis::Eruby.new(template)
      eruby.result(locals.merge({env: env}))
    end
  end
end
