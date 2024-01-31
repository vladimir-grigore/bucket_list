# frozen_string_literal: true

module RequestsHelpers
  def json_response
    @json_response ||= begin
      result = JSON.parse(response.body)
      result.is_a?(Hash) ? result.with_indifferent_access : result
    end
  end

  def error_response
    json_response
  end

  def headers(response)
    json_headers.merge('Authorization' => response.headers['Authorization'])
  end

  def json_headers
    {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
  end
end
