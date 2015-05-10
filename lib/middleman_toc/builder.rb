require 'middleman_toc/node'
require 'middleman_toc/title'

module MiddlemanToc
  class Builder < Struct.new(:manifest, :pages)
    def build
      Node.new(0, nil, nil, nodes(manifest))
    end

    private

      def nodes(data, parents = [])
        data.inject([]) do |pages, data|
          pages << node(data['path'], data['children'], parents)
        end
      end

      def node(path, children, parents)
        path = parents + [path]
        children = nodes(children, path) if children
        Node.new(path.size, path.join('/'), title_for(path.join('/')), children)
      end

      def title_for(path)
        Title.new(path, pages[path]).title
      end
    end
end
