class Url < ApplicationRecord

  validate :original_url_validation
  before_save :generate_short_url

  private

  def original_url_validation
    if original_url.blank?
      raise URI::InvalidURIError, 'URL не может быть пустым'
    elsif !URI.parse(original_url).is_a?(URI::HTTP) || URI.parse(original_url).host.blank?
      raise URI::InvalidURIError, 'Не верный формат URL'
    end
  end

  def generate_short_url
    uri = URI.parse(original_url)
    self.short_url = "#{uri.scheme}://#{uri.host}/#{Digest::SHA256.hexdigest(original_url)}"
  end
end
