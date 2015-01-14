class MiddlemanToc
  module Helpers
    def _toc
      @_toc ||= MiddlemanToc.new(sitemap)
    end

    def toc
      _toc.render(current_page.path)
    end

    def prev_page
      _toc.prev(current_page.path)
    end

    def next_page
      _toc.next(current_page.path)
    end
  end
end
