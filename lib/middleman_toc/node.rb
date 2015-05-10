require 'middleman_toc/renderer'

module MiddlemanToc
  class Node < Struct.new(:level, :path, :title, :children)
    attr_reader :active

    def flatten
      [self, children.map(&:flatten)].flatten
    end

    def activate(path)
      @active = path == self.path
      children.each { |child| child.activate(path) }
    end

    def render
      Renderer.new(self).render
    end

    def children
      super || []
    end

    def root?
      level == 0
    end

    def directory?
      children.any?
    end

    def active?
      @active
    end

    def expanded?
      directory? && active? || children.any?(&:active?)
    end
  end
end

