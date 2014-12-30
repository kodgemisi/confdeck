class BaseService

  private

  def error(message)
    {
        message: message,
        status: :error
    }
  end

  def success
    {
        status: :success
    }
  end
end