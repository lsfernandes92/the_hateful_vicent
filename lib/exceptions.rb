module PageObjectModel
  module Exceptions
    class ElementNotFoundError < RuntimeError
    end
  end
end

World(PageObjectModel::Exceptions)