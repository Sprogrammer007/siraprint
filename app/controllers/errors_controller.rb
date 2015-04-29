class ErrorsController < ApplicationController
  def file_not_found
    render layout: false
  end

  def unprocessable
    render layout: false
  end

  def internal_server_error
    render layout: false
  end
end
