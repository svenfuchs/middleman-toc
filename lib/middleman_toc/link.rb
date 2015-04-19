class MiddlemanToc
  class Link < Struct.new(:href, :content, :options)
    def render
      %(<a href="#{href}" class="#{options[:class]}">#{content}</a>)
    end
  end
end
