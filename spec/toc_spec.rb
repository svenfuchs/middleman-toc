require 'spec_helper'

describe Middleman::Toc do
  let(:titles)  { ['Title 1', 'Title 2', 'Title 2-1', 'Title 2-2', 'Book'] }
  let(:paths)   { %w(1.html 2.html 2/2-1.html 2/2-2.html index.html) }
  let(:pages)   { paths.map { |path| stub(path: path) } }
  let(:sitemap) { stub(resources: pages) }
  let(:toc)     { Middleman::Toc.new(sitemap) }

  subject { toc.render }

  before do
    pages.map do |page|
      sitemap.stubs(:find_resource_by_path).with(page.path).returns(page)
      page.stubs(:data).returns(stub(title: nil))
      File.stubs(:file?).with("source/#{page.path.sub('html', 'md')}").returns(page.path != '2.html')
    end
  end

  describe 'with a directory that has an equivalent file' do
  end

  describe 'with page data title attribute set' do
    before do
      pages.map.with_index do |resource, ix|
        resource.stubs(:data).returns(stub(title: "Data: #{titles[ix]}"))
      end
    end

    it 'uses the page data title attribute' do
      expect(subject).to include('<a href="1.html">Data: Title 1</a>')
    end
  end

  describe 'with page data title attribute not set' do
    before do
      pages.map.with_index do |resource, ix|
        resource.stubs(:render).returns("<h1>Html: #{titles[ix]}</h1>")
      end
    end

    it 'renders and parses the page for a <h1> tag' do
      puts subject
      expect(subject).to include('<a href="1.html">Html: Title 1</a>')
    end
  end
end
