require 'rack/options'
require 'rack/mock'

context "Rack::Options" do
  def test_response(headers = {})
    app = lambda { |env| [200, {"Content-type" => "test/plain", "Content-length" => "3"}, ["foo"]] }
    request = Rack::MockRequest.env_for("/", headers)
    response = Rack::Options.new(app).call(request)

    return response
  end

  specify "passes GET, POST, PUT, DELETE, HEAD, TRACE requests" do
    %w[GET POST PUT DELETE HEAD TRACE].each do |type|
      resp = test_response("REQUEST_METHOD" => type)

      resp[0].should.equal(200)
      resp[1].should.equal({"Content-type" => "test/plain", "Content-length" => "3"})
      resp[2].should.equal(["foo"])
    end
  end

  specify "removes body from OPTIONS requests" do
    resp = test_response("REQUEST_METHOD" => "OPTIONS")

    resp[0].should.equal(200)
    resp[1].should.equal({"Content-type" => "test/plain", "Content-length" => "0"})
    resp[2].should.equal([])
  end
end
