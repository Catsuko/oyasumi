class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

  private

  # TODO: Add some helpful error message formats for exceptions.
  def handle_not_found(_exception)
    head :not_found
  end

  def handle_invalid_record(_exception)
    head :unprocessable_entity
  end
end
