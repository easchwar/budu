require "budu/version"
require "budu/array"
require "budu/routing"


module Budu
  class Application
    def call(env)
      `echo debug > debug.txt`;

      # janky favicon bullshit
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      
      # janky error handling
      begin
        text = controller.send(act)
      rescue
        return [500, {'Content-Type' => 'text/html'}, ["nah man no good"]]
      end

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end

  class Controller
    attr_reader :env
    def initialize(env)
      @env = env
    end
  end
end
