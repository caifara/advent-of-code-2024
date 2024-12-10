require "bundler/setup"
require "debug"

require_relative "shared/part.rb"

class Object
  def tpp(message)
    tap { |l| pp "#{message} #{l}" }
  end
end
