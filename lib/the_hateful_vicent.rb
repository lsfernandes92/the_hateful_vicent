require "the_hateful_vicent/version"

module TheHatefulVicent
  require_relative 'common_asserts'
  require_relative 'page_actions'
  autoload :ElementContainer, 'element_container'
  autoload :Page, 'page'
  autoload :Element, 'element'
end
