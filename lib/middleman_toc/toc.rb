require 'middleman_toc/builder'

module MiddlemanToc
  class Toc < Struct.new(:pages)
    attr_reader :root

    def initialize(*)
      super
      @root = Builder.new(manifest, pages).build
    end

    def toc(path)
      root.activate(normalize_path(path))
      root.render
    end

    def prev_page(path)
      node = prev_node(path)
      Tag.new(:a, 'Previous', class: 'prev', href: "/#{node.path}.html").render if node
    end

    def next_page(path)
      node = next_node(path)
      Tag.new(:a, 'Next', class: 'next', href: "/#{node.path}.html").render if node
    end

    private

      def normalize_path(path)
        path.sub('.html', '')
      end

      def manifest
        raise 'Could not load data/toc.yml' unless File.exists?('data/toc.yml')
        normalize_nodes(YAML.load_file('data/toc.yml'))
      end

      def nodes
        @nodes ||= root.flatten
      end

      def find(path)
        nodes.detect { |node| node.path == path }
      end

      def index(path)
        node = find(normalize_path(path))
        nodes.index(node)
      end

      def prev_node(path)
        ix = index(path)
        nodes[ix - 1] if ix
      end

      def next_node(path)
        ix = index(path)
        nodes[ix + 1] if ix
      end

      def normalize_nodes(nodes)
        Array(nodes).map do |node|
          case node
          when Array
            normalize_nodes(node)
          when String
            { 'path' => node }
          when Hash
            node.merge('children' => normalize_nodes(node['children']))
          else
            node
          end
        end
      end
  end
end
