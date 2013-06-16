require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'

module Nitwit
  autoload :Helpers, 'nitwit/helpers'
  autoload :SearchService, 'nitwit/search_service'
end
