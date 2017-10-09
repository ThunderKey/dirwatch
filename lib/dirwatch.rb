require 'yaml'
require_relative 'dirwatch/executors'
require_relative 'dirwatch/options'
require_relative 'dirwatch/errors'

module Dirwatch
  @console = Console.new

  class << self
    attr_reader :console
  end
end
