require 'middleman'
require 'middleman_toc/extension'
require 'middleman_toc/link'
require 'middleman_toc/page'
require 'middleman_toc/paths'
require 'forwardable'
require 'yaml'

class MiddlemanToc
  attr_reader :sitemap, :paths, :tree

  def initialize(sitemap)
    @sitemap = sitemap
    @paths = Paths.new(manifest)
    @tree = build('.')
  end

  def render(current_path)
    tree.activate(current_path.sub('.html', ''))
    tree.render
  end

  def prev(current_path)
    page = page_for(current_path)
    href = paths.prev(page.path)
    Link.new(href, 'Previous', class: 'prev').render if href
  end

  def next(current_path)
    page = page_for(current_path)
    href = paths.next(page.path)
    Link.new(href, 'Next', class: 'next').render if href
  end

  private

    def manifest
      @manifest ||= YAML.parse('toc.yml')
    end

    def build(path, level = 1)
      path = path.sub('./', '')
      page = Page.new(level, path, page_for("#{path}.html"))
      paths.select(path).each { |path| page.children << build(path, level + 1) }
      page
    end

    def page_for(path)
      sitemap.find_resource_by_path(path)
    end

    def title_for(path)
      File.read(path)
    end
end

Middleman::Extensions.register(:toc, MiddlemanToc::Extension)
