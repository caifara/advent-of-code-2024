require "bundler/setup"
require "debug"

class Object
  def tpp
    tap { |l| pp l }
  end
end
