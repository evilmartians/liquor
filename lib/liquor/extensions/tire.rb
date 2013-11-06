require 'tire'
require 'liquor/extensions/pagination'

module Tire
  module Results
    class Collection
      def to_drop
        Liquor::Pagination::Scope.new(self)
      end

      def to_page_path(url_generator, page)
        url_generator.search_path(query: @query, page: page)
      end
    end
  end
end

module Tire
  module Search
    class Search
      def to_drop
        Liquor::Pagination::Scope.new(self.results)
      end

      def to_page_path(url_generator, page)
        url_generator.search_path(query: @query, page: page)
      end
    end
  end
end
