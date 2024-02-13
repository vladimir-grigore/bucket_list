# frozen_string_literal: true

# Devise failure app
class FailureApp < Devise::FailureApp
  def respond
    json_api_error_response
  end

  def json_api_error_response
    response_hash = {
      title: message(i18n_message),
      status: 401
    }

    self.status        = response_hash[:status]
    self.content_type  = 'application/json'
    self.response_body = response_hash.to_json
  end

  def message(i18n_message)
    case i18n_message
    when 'nil user', 'revoked token', 'Signature verification raised'
      'You need to sign in or sign up before continuing.'
    else
      i18n_message
    end
  end
end
