require 'thor/shell/color'

module MiddlemanToc
  class Validator < Struct.new(:pages, :node)
    INDENT = '   '

    def validate!
      hrefs.each do |href|
        missing_page(href) unless exists?(href)
      end
    end

    private

      def missing_page(href)
        puts [INDENT, warn("Link to local page is missing in the table of contents: #{href}")].join
      end

      def exists?(href)
        paths.include?(href)
      end

      def warn(message)
        "#{ansi('warning', :red, :bold)}: #{message}"
      end

      def ansi(string, *attrs)
        Thor::Shell::Color.new.set_color('warning', *attrs)
      end

      def hrefs
        pages.map { |path, page| hrefs_from(page) }.flatten
      end

      def paths
        pages.keys
      end

      def hrefs_from(page)
        html = render(page) || ''
        html.scan(%r(<a.+href="/([^"]+)")).flatten.map do |href|
          href.sub('.html', '')
        end
      end

      def render(page)
        page.render(layout: false, no_images: true)
      end
  end
end
