require 'middleman'
require 'middleman_toc/extension'
require 'forwardable'

class MiddlemanToc
  module Indent
    def indent(string)
      string.split("\n").map { |line| "#{'  ' * (level)}#{line}" }.join("\n")
    end
  end

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

  class Tree
    extend Forwardable
    include Indent

    def_delegators :@children, :empty?
    attr_reader :level, :path, :children

    def initialize(level, path)
      @level = level
      @path = path
      @children = []
    end

    def <<(child)
      children << child
    end

    def activate(active)
      children.each { |child| child.activate(active) }
      @active = active == path
    end

    def render
      %(<ul#{%( class="active") if active?}>\n#{render_children}\n</ul>) unless children.empty?
    end

    def render_children
      indent(children.map(&:render).join("\n"))
    end

    def active?
      @active
    end

    def expanded?
      level == 1 || children.any?(&:active?)
    end
  end

  class Page < Struct.new(:directory, :level, :page, :path)
    include Indent

    attr_reader :active, :active

    def activate(active)
      @active = active == path
      directory.activate(active)
    end

    def render
      html = title
      html = link("/#{path}.html", html) if File.file?(filename)
      html = [html, directory.render].join("\n")
      html = item(html)
      html
    end

    def link(href, content)
      %(<a href="#{href}">#{content}</a>)
    end

    def item(content)
      %(<li#{%( class="#{classes}") unless classes.empty?}>#{content}</li>)
    end

    def directory?
      !directory.empty?
    end

    def active?
      @active
    end

    def classes
      classes = []
      classes << 'active' if active?
      classes << 'directory' if directory?
      classes << 'expanded' if active? && !directory.empty? || directory.expanded?
      classes.join(' ')
    end

    def title
      title = page_title if page
      title || path_title
    end

    def page_title
      if page.data.title
        page.data.title
      else
        html = page.render(layout: false, no_images: true)
        matches = html.match(/<h.+>(.*?)<\/h1>/)
        matches[1] if matches
      end
    end

    def path_title
      path.sub(/[\d]{2}-/, '').titleize
    end

    def filename
      "source/#{path}.md"
    end
  end

  class Link < Struct.new(:href, :content, :options)
    def render
      %(<a href="#{href}" class="#{options[:class]}">#{content}</a>)
    end
  end

  attr_reader :sitemap, :paths, :tree

  def initialize(sitemap)
    @sitemap = sitemap
    @paths = Paths.new(sitemap)
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

    def build(dir, level = 1)
      tree = Tree.new(level, dir.sub('./', ''))
      paths.select(dir).each do |path|
        child = build(path, level + 1)
        path = path.sub('./', '')
        page = page_for("#{path}.html")
        tree.children << Page.new(child, level, page, path)
        # tree << child unless child.empty?
      end
      tree
    end

    def page_for(path)
      sitemap.find_resource_by_path(path)
    end

    def title_for(path)
      File.read(path)
    end
end

Middleman::Extensions.register(:toc, MiddlemanToc::Extension)
