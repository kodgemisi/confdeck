module ApplicationHelper

 def bs_will_paginate(collection)
  will_paginate collection, renderer: BootstrapPagination::Rails
 end
end
