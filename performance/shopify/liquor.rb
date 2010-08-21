require File.dirname(__FILE__) + '/../../lib/liquor'

require File.dirname(__FILE__) + '/comment_form'
require File.dirname(__FILE__) + '/paginate'
require File.dirname(__FILE__) + '/json_filter'
require File.dirname(__FILE__) + '/money_filter'
require File.dirname(__FILE__) + '/shop_filter'
require File.dirname(__FILE__) + '/tag_filter'
require File.dirname(__FILE__) + '/weight_filter'

Liquor::Template.register_tag 'paginate', Paginate
Liquor::Template.register_tag 'form', CommentForm

Liquor::Template.register_filter JsonFilter
Liquor::Template.register_filter MoneyFilter
Liquor::Template.register_filter WeightFilter
Liquor::Template.register_filter ShopFilter
Liquor::Template.register_filter TagFilter
