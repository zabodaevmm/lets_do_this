require 'lets_do_this/version'
require 'lets_do_this/command'
require 'lets_do_this/scenario'

module LetsDoThis
  class EmptyCommandSequence < StandardError; end
  class EmptyStateAttrsWhitelist < StandardError; end
end
