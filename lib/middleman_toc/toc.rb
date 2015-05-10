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
      node = root.find(normalize_path(path)).try(:prev)
      Tag.new(:a, node.path, 'Previous', class: 'prev').render if node
    end

    def next_page(path)
      node = root.find(normalize_path(path)).try(:next)
      Tag.new(:a, node.path, 'Next', class: 'next').render if node
    end

    def normalize_path(path)
      path.sub('.html', '')
    end

    def manifest
      raise 'Could not load data/toc.yml' unless File.exists?('data/toc.yml')
      normalize_nodes(YAML.load_file('data/toc.yml'))
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
