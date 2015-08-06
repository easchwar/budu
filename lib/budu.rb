require "budu/version"
require "budu/routing"
require "budu/dependencies"
require "budu/util"
require "budu/controller"
require "budu/file_model"

module Budu
  # this is where the magic happens. Rack application
  # the application gets called with environment variables 
  # (i.e. the request), and it returns an array of
  # [status, headers, body].
  # Can be chained together (e.g. app1.call(env) calls app2.call(env))
  # indefinitely.
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
