class MiddlemanToc
  class Page
    extend Forwardable

    def_delegators :@children, :empty?

    attr_reader :level, :path, :page, :children, :active

    def initialize(level, path, page)
      @level = level
      @path = path
      @page = page
      @children = []
    end

    def <<(child)
      children << child
    end

    def activate(active)
      @active = active == path
      children.each { |child| child.activate(active) }
    end

    def render
      if level == 1
        render_children
      else
        html = title
        html = link("/#{path}.html", html) if File.file?(filename)
        html = [html, render_children].join("\n") unless children.empty?
        item(html)
      end
    end

    def render_children
      %(<ul#{%( class="active") if active?}>\n#{indent(children.map(&:render).join("\n"))}\n</ul>)
    end

    def link(href, content)
      %(<a href="#{href}">#{content}</a>)
    end

    def item(content)
      %(<li#{%( class="#{classes}") unless classes.empty?}>#{content}</li>)
    end

    def classes
      classes = []
      classes << 'active' if active?
      classes << 'directory' if directory?
      classes << 'expanded' if active? && !children.empty? || expanded?
      classes.join(' ')
    end

    def directory?
      !children.empty?
    end

    def active?
      @active
    end

    def expanded?
      level == 1 || children.any?(&:active?)
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
      File.basename(path).sub(/[\d]{2}-/, '').titleize
    end

    def filename
      "source/#{path}.md"
    end

    def indent(string)
      string.split("\n").map { |line| "#{'  ' * (level)}#{line}" }.join("\n")
    end
  end
end
