class MiddlemanToc
  class Paths < Struct.new(:sitemap)
    def prev(path)
      path = paths[index(path) - 1]
      "#{path.sub('.', '')}.html" if path
    end

    def next(path)
      path = paths[index(path) + 1]
      "#{path.sub('.', '')}.html" if path
    end

    def select(dir)
      paths.select { |path| path =~ %r(#{dir}/) }.reject { |path| path =~ %r(#{dir}/.+/) }
    end

    def paths
      @paths ||= begin
        paths = sitemap.resources.map(&:path)
        paths = paths.select { |path| path =~ /.html$/ }
        paths = paths.map { |path| "./#{path.sub(/.html$/, '')}" }
        paths = paths + paths.map { |path| ::File.dirname(path) } - ['.']
        paths.sort.unshift('./index').uniq
      end
    end

    def index(path)
      paths.index("./#{path.sub('.html', '')}")
    end
  end
end
