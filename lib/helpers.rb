include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Tagging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::XMLSitemap

# Returns a sorted list of articles for the given year.
# - borrowed from the stonesip.org codebase
def articles_for_year(year)
  @pages.select { |page| page.kind == 'article' and page.created_at.year == year }.sort_by { |page| page.created_at }.reverse
end

def articles_by_year
  [
    [2009, articles_for_year(2009)],
    [2008, articles_for_year(2008)],
    [2007, articles_for_year(2007)]
  ]
end
