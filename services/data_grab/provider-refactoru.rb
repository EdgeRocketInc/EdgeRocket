require 'open-uri'

class RefactorUClient < ProviderClient

  def origin(row)
    lnk = row.css('a.ru-link')
    'https://refactoru.learningcart.com/' + lnk[0]['href']
  end

  def name(row)
    lnk = row.css('a.ru-link p')
    lnk[0].text 
  end

  def description(row)
    desc = row.css('p.course-intro-text')
    desc.text
  end

  def authors(row)
    nil
  end

  def courses
    page = Nokogiri::HTML(open("https://refactoru.learningcart.com/custom/ProductSubCats.aspx?SubCatID=21"))
    courses = page.css('div#courses-available div.shim')
  end

  def instructors
    # TODO
    nil
  end

  def school(row)
    nil
  end

  def price(row)
    price = nil
    link = origin(row)
    page = Nokogiri::HTML(open(link))
    price_css = page.css('div.offer-box p.header-1').text
    if !price_css.nil?
      price = price_css.split('$')[1].to_f
    end
  end

  def duration(row)
    nil
  end

end
