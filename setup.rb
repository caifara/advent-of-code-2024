require "bundler/setup"
require "debug"

require_relative "shared/part.rb"

class Object
  def tpp(message = nil)
    tap { |l| puts message if message }
    tap { |l| pp l }
  end
end
