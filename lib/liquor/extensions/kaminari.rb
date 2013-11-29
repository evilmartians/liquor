require 'kaminari/models/array_extension'
require 'liquor/extensions/pagination'

module Kaminari
  class PaginatableArray
    def to_drop
      Liquor::Pagination::Scope.new(self)
    end

    def to_page_path(url_generator, page)
      raise NotImplementedError, "Liquor: Kaminari::PaginatableArray cannot generate page paths"
    end
  end
end