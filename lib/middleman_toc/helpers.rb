module MiddlemanToc
  module Helpers
    def toc
      MiddlemanToc.toc(sitemap, current_path)
    end

    def prev_page
      MiddlemanToc.prev_page(sitemap, current_path)
    end

    def next_page
      MiddlemanToc.next_page(sitemap, current_path)
    end
  end
end
