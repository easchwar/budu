require "budu/version"
require "budu/routing"
require "budu/dependencies"
require "budu/util"
require "budu/controller"
require "budu/file_model"
require "budu/orm"

module Budu
  # This is where everything happens. This is a Rack application 
  # the application gets called with environment variables 
  # (i.e. the request), and it returns an array of
  # [status, headers, body].
  # Can be chained together (e.g. app1.call(env) calls app2.call(env))
  # indefinitely.
  class Application
    def call(env)
      # random system call
      `echo debug > debug.txt`;

      # janky favicon stuff 
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      # parse the controller and action from the env (uses old rails routing)
      klass, action = get_controller_and_action(env) 

      begin 
        controller = klass.new(env) 
      rescue
        return [500, {'Content-Type' => 'text/html'}, ["No controller named #{klass}"]]
      end

      # call the appropriate action on the controller 
      controller.send(action) # no error handling :(

      # if the controller didn't render a response, render one with the action name
      controller.render(action) unless controller.get_response

      # return the data based on the response
      status, headers, resp = controller.get_response.to_a
      puts "headers: #{headers}" # debugging
      headers['Content-Type'] = 'text/html' # right now putting this here to force html
      [status, headers, [resp.body].flatten]
    end
  end
end
