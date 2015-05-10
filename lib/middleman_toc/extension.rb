require 'middleman_toc/helpers'

module MiddlemanToc
  class Extension < ::Middleman::Extension
    # option :ignore, ['sitemap.xml', 'robots.txt'], 'Ignored files and directories.'
    # option :titles, { 'index.md' => 'Home' }, 'Default link titles.'

    self.defined_helpers = [Helpers]

    def manipulate_resource_list(resources)
      resources.each do |resource|
        resource.destination_path.gsub!(/(^|\/)[\d]+\-/, '\1')
      end
    end
  end
end
