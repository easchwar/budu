module Budu
  class Application
    def get_controller_and_action(env)
      _, cont, action, after = env["PATH_INFO"].split("/", 4)
      controller = cont.capitalize + "Controller"

      [Object.const_get(controller), action] 
    end
  end
end
