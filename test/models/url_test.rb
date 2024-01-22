require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  test 'should be valid with valid attributes' do
    url = Url.new(original_url: 'https://example.com')
    assert url.valid?
  end

  test 'should be invalid with non-unique short_url' do
    Url.create(original_url: 'https://example.com', short_url: 'abc123')
    url = Url.new(original_url: 'https://example.org', short_url: 'abc123')
    assert_not url.valid?
    assert_equal ['has already been taken'], url.errors[:short_url]
  end

  test 'should generate short_url before validation' do
    url = Url.new(original_url: 'https://example.com')
    url.valid?
    assert_not_nil url.short_url
  end

  test 'should raise error for invalid original_url' do
    assert_raises URI::InvalidURIError do
      Url.create(original_url: 'invalid_url')
    end
  end

  test 'should raise error for non-HTTP original_url' do
    assert_raises URI::InvalidURIError do
      Url.create(original_url: 'ftp://example.com')
    end
  end
end

