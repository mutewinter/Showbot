ENV['RACK_ENV'] = 'test'

require './environment'
require './showbot_web'
require 'test/unit'
require 'rack/test'


class ShowbotWebTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ShowbotWeb
  end

  # ------------------
  # Setup and Teardown
  # ------------------

  class << self
    def startup
    end

    def shutdown
    end
  end

  # ------------------
  # Success Cases
  # ------------------

  def test_home_page_works
    get '/'
    last_response.ok?
    assert last_response.body =~ /showbot/
  end

  def test_title_suggestion_api
    title = valid_title
    user = valid_user

    post '/suggestions/new', params = {api_key: api_key.value, title: title, user: user}

    assert_last_response_valid
    assert_equal json_response['suggestion']['title'], title
    assert_equal json_response['suggestion']['user'], user
  end

  # ------------------
  # Error Cases
  # ------------------

  def test_invalid_api_key
    invalid_key = 'invalid_key'
    post '/suggestions/new', params = {api_key: invalid_key}

    assert_equal last_response.status, 404

    assert_equal json_response['error'], "Invalid Api Key #{invalid_key}"
  end

  def test_too_long_title_api
    error_message = "That suggestion was too long. Showbot is sorry. Think title, not transcript."

    post '/suggestions/new', params = {api_key: api_key.value, title: ('x'*41), user: valid_user}

    assert_equal json_response['error'], error_message
  end

  def test_duplicate_title
    title = "Same Title"
    first_user = valid_user
    error_message = "Darn, #{first_user} beat you to \"#{title}\"."

    post '/suggestions/new', params = {api_key: api_key.value, title: title, user: first_user}
    post '/suggestions/new', params = {api_key: api_key.value, title: title, user: valid_user}

    assert_equal json_response['error'], error_message
  end

  def test_missing_user
    post '/suggestions/new', params = {api_key: api_key.value, title: valid_title}
    assert_equal json_response['error'], 'Missing / Invalid User'
  end

  def test_title_user
    post '/suggestions/new', params = {api_key: api_key.value, user: valid_user}
    assert_equal json_response['error'], 'Missing / Invalid Title'
  end

  # ------------------
  # Helpers
  # ------------------

  def api_key
    @@api_key ||= ApiKey.create(app_name: 'Test App')
  end

  def json_response
    @json ||= JSON.parse(last_response.body)
  end

  def valid_user
    user = SecureRandom.urlsafe_base64(10)
  end

  def valid_title
    title = SecureRandom.urlsafe_base64(20)
  end

  def assert_last_response_valid
    assert last_response.ok?, "Last response returned error status #{last_response.status}\nBody:#{last_response.body}"
  end

end
