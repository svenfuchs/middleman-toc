module MiddlemanToc
  class Tag < Struct.new(:name, :content, :attrs)
    class Attr < Struct.new(:key, :value)
    end

    def render
      "<#{name} #{attrs}".strip + ">\n#{indent(content)}\n</#{name}>"
    end

    private

      def attrs
        Array(super).map { |key, value| attr(key, value) }.compact.join(' ')
      end

      def attr(key, value)
        %(#{key}="#{Array(value).join(' ')}") unless value.nil? || value.empty?
      end

      def indent(lines)
        Array(lines).join("\n").split("\n").map { |line| "  #{line}" }.join("\n")
      end
  end
end
