require 'middleman_toc/tag'

module MiddlemanToc
  class Renderer < Struct.new(:node)
    def render
      if node.root?
        children
      else
        html = node.title
        html = link("/#{node.path}.html", html)
        html = [html, children].join("\n") if node.directory?
        item(html)
      end
    end

    private

      def children
        Tag.new(:ul, node.children.map(&:render)).render
      end

      def link(href, content)
        Tag.new(:a, content, href: href).render
      end

      def item(content)
        Tag.new(:li, content, class: classes).render
      end

      def classes
        %w(active directory expanded).select { |name| node.send(:"#{name}?") }
      end

      def indent(string)
        string.split("\n").map { |line| "  #{line}" }.join("\n")
      end
    end
end
