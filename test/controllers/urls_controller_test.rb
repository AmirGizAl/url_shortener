require 'test_helper'

class UrlsControllerTest < ActionDispatch::IntegrationTest
  test 'should create url' do
    post urls_url, params: { url: 'https://example.com' }
    assert_response :created

    response_body = JSON.parse(response.body)
    assert_not_nil response_body['short_url']
  end

  test 'should handle create error' do
    # Передайте неверный параметр, чтобы вызвать ошибку
    post urls_url, params: { invalid_param: 'invalid_value' }
    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_not_nil response_body['error']
  end

  test 'should show url' do
    Url.create(original_url: 'https://example.com', short_url: 'abc123')

    get short_url_url(short_url: 'abc123')
    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 'https://example.com', response_body['original_url']
  end

  test 'should handle show error' do
    get short_url_url(short_url: 'nonexistent')
    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_not_nil response_body['error']
  end

  test 'should show url stats' do
    Url.create(original_url: 'https://example.com', short_url: 'abc123', clicks: 10)

    get url_stats_url(short_url: 'abc123')
    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 10, response_body['clicks']
  end

  test 'should handle stats error' do
    get url_stats_url(short_url: 'nonexistent')
    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_not_nil response_body['error']
  end
end
