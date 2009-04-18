# helper for generating rss feeds
#
# based on the atom_feed method distributed with nanoc

def rss_feed(params = {})
  require 'builder'

  # Extract parameters
  limit             = params[:limit] || 5
  relevant_articles = params[:articles] || articles || []
  content_proc      = params[:content_proc] || lambda { |a| a.content }

  # Check article attributes
  if relevant_articles.empty?
    raise RuntimeError.new('Cannot build Atom feed: no articles')
  end
  if relevant_articles.any? { |a| a.created_at.nil? }
    raise RuntimeError.new('Cannot build Atom feed: one or more articles lack created_at')
  end

  # Get sorted relevant articles
  sorted_relevant_articles = relevant_articles.sort_by { |a| a.created_at }.reverse.first(limit)

  # Get most recent article
  last_article = sorted_relevant_articles.first

  # Create builder
  buffer = ''
  xml = Builder::XmlMarkup.new(:target => buffer, :indent => 2)

  xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
    xml.channel do

      xml.title       @page.title
      xml.link        @page.base_url + "/"
      #xml.description ""

      sorted_relevant_articles.each do |a|
        xml.item do
          xml.title       a.title
          xml.link        url_for(a)
          xml.guid        url_for(a)
          xml.description do
            xml.cdata! content_proc.call(a)
          end
          xml.pubDate     a.created_at.to_iso8601_time
          xml.guid        url_for(a)
        end
      end

    end
  end


  buffer
end
