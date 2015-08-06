require 'erubis'

module Budu
  class View
    attr_reader :env

    def initialize(name, env, ivars = {})
      @name = name
      @ivars = ivars
      @env = env
      # ivars.each do |name, val|
      #   instance_variable_set("@#{name}", val)
      # end
    end

    def render_content(controller_name, locals = {})
      # default file path
      file_name = File.join("app","views", controller_name, "#{@name}.html.erb")
      template = File.read(file_name)
       
      eruby = Erubis::Eruby.new(template)

      args = locals.merge({ env: env }).merge(@ivars)
      eruby.result(args)
    end
  end
end
