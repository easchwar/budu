require 'rack/request'
require 'budu/file_model'
require 'budu/view'

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

    def response(text, status = 200, headers = {})
      raise "already responded" if @response
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    def get_response
      @response
    end

    def render(view_name, locals = {})
      ivars = {} 
      instance_variables.each do |name|
        ivars[name] = instance_variable_get(name)
      end

      view = Budu::View.new(view_name, env, ivars)

      response(view.render_content(controller_name, locals))
    end

    def params
      request.params
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, '')

      Budu.to_underscore(klass)
    end
  end
end
