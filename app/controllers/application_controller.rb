# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Knock::Authenticable
end
