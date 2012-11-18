require 'thinking_sphinx'
require 'liquor/extensions/pagination'

module ThinkingSphinx
  class Search
    def to_drop
      Liquor::Pagination::Scope.new(self)
    end

    def to_page_path(url_generator, page)
      url_generator.search_path(query: @query, page: page)
    end
  end
end