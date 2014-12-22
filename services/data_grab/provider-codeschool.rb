require 'open-uri'

class CodeSchoolClient < ProviderClient

  def origin(row)
    lnk = row.css('div h2 a')
    'https://www.codeschool.com' + lnk[0]['href']
  end

  def name(row)
    lnk = row.css('div h2 a')
    lnk[0].text 
  end

  def description(row)
    desc = row.css('p')
    desc.text
  end

  def authors(row)
    link = origin(row)
    page = Nokogiri::HTML(open(link))
    author = page.css('h3 a')
    return author.blank? ? nil : author[0].text[0..254]
  end

  def courses
    page = Nokogiri::HTML(open("https://www.codeschool.com/courses"))
    courses = page.css('article')
  end

  def instructors
    # TODO
    nil
  end

  def school(row)
    nil
  end

  def duration(row)
    nil
  end

end
