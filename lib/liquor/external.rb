module Liquor
  module External
    def liquor_send(method, *args)
      liquor_method_missing(method, *args)
    end
  end
end