require 'open-uri'

class TreehouseClient < ProviderClient

  def origin(row)
    lnk = row.css('a.title')
    'http://teamtreehouse.com' + lnk[0]['href']
  end

  def name(row)
    lnk = row.css('a.title h3')
    lnk[0].text 
  end

  def description(row)
    desc = row.css('a.title p.description')
    desc.text
  end

  def authors(row)
    link = origin(row)
    page = Nokogiri::HTML(open(link))
    # first try to get workshop layout
    author = page.css('div.module.module-instructor > ul > li > h4 > a')
    # if did not get it, then try again for course layout
    if author.blank?
      author = page.css('div.module.module-instructor > ul > li > a > h4')
    end
    return author.blank? ? nil : author.text[0..254]
  end

  def courses
    page = Nokogiri::HTML(open("http://teamtreehouse.com/library/sort:title"))
    courses = page.css('ul.card-list li.card')
  end

  def instructors
    # TODO
    nil
  end

  def school(row)
    nil
  end

  def duration(row)
    d = nil
    d_css = row.css('span.estimate')
    if d_css
      split = d_css.text.split(" ")
      if split[1] == "min"
        d = split[0].to_f/60
      elsif split[1] == 'hours'
        d = split[0].to_f
      end
    end
    return d
  end

end
