class Url < ApplicationRecord

  validates :original_url, presence: true
  validates :short_url, uniqueness: true

  before_validation :generate_short_url

  private

  def generate_short_url
    uri = URI.parse(original_url)
    if uri.is_a?(URI::HTTP) && uri.host.present?
      self.short_url ||= "#{uri.scheme}://#{uri.host}/#{SecureRandom.hex(4)}"
    else
      raise URI::InvalidURIError unless uri.is_a?(URI::HTTP) && uri.host.present?
    end
  end
end
