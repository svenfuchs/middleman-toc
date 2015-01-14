require 'middleman_toc/helpers'

class MiddlemanToc
  class Extension < ::Middleman::Extension
    # option :ignore, ['sitemap.xml', 'robots.txt'], 'Ignored files and directories.'
    # option :titles, { 'index.md' => 'Home' }, 'Default link titles.'

    self.defined_helpers = [Helpers]
  end
end
