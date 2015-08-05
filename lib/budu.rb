require "budu/version"
require "budu/routing"
require "budu/dependencies"
require "budu/util"
require "budu/controller"
require "budu/file_model"

module Budu
  class Application
    def call(env)
      `echo debug > debug.txt`;

      # janky favicon stuff 
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      klass, act = get_controller_and_action(env)

      begin 
        controller = klass.new(env)
      rescue
        return [500, {'Content-Type' => 'text/html'}, ["No controller named #{klass}"]]
      end

      # no error handling
      text = controller.send(act)

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end

end
