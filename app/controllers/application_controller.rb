class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

  private

  # TODO: Add error message for related record or parameter
  def handle_not_found(_exception)
    head :not_found
  end

  # TODO: Add error message for invalid fields
  def handle_invalid_record(_exception)
    head :unprocessable_entity
  end
end
