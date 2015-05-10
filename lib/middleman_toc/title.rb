module MiddlemanToc
  class Title < Struct.new(:path, :page)
    def title
      from_data || from_html || from_path
    end

    private

      def from_data
        page.data.title if page
      end

      def from_html
        html.match(/<h.+>(.*?)<\/h1>/) && $1
      end

      def html
        page ? page.render(layout: false, no_images: true) : ''
      end

      def from_path
        File.basename(path).sub(/[\d]{2}-/, '').titleize if path
      end
  end
end
