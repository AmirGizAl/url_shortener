class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_url, only: %i[show stats]

  def create
    @url = Url.find_or_initialize_by(original_url: params[:url])

    if @url.persisted?
      render json: { message: 'Для данной ссылки уже существует короткий URL', short_url: @url.short_url }, status: 200
    else
      begin
        @url.save!
        render json: { short_url: @url.short_url, encoded: CGI.escape(@url.short_url).gsub('.', '%2e') }, status: :created
      rescue ActiveRecord::RecordInvalid, URI::InvalidURIError => e
        render json: { error: "Не удалось создать короткий URL. #{e.message}" }, status: :unprocessable_entity
      end
    end
  end

  def show
    @url.increment!(:clicks)
    render json: { original_url: @url.original_url }
  end

  def stats
    render json: { clicks: @url.clicks }
  end

  private

  def find_url
    @url = Url.find_by(short_url: params[:short_url])
    render json: { error: 'URL не найден' }, status: :not_found unless @url
  end
end
