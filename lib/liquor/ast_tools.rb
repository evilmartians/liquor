module Liquor
  module ASTTools
    private

    def ntype(node)
      node[0]
    end

    def npos(node)
      node[1]
    end

    def nvalue(node)
      node[2..-1]
    end
  end
end