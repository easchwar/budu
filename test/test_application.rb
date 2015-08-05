require_relative 'test_helper'

class TestController < Budu::Controller
  def testing
    "Hello"
  end  
end

class TestApp < Budu::Application
  def get_controller_and_action(env)
    [TestController, "testing"]
  end
end

class BuduTestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end
end
