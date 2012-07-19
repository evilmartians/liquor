module Liquor
  module ASTTools
    private

    def ntype(node)
      node[0]
    end

    def nloc(node)
      node[1]
    end

    def nvalue(node)
      node[2..-1]
    end

    def kwname(node)
      kw, val = nvalue(node)
      name, = nvalue(kw)
      name
    end

    def kwvalue(node)
      kw, val = nvalue(node)
      val
    end
  end
end