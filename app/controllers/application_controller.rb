class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from StandardError, with: :render_something_happened

  private

  def render_something_happened
    render json: { error: 'Something bad happen. Try again later.' }, status: :bad_request
  end
end
