class Importer
  require 'nokogiri'
  require 'open-uri'

  # Wygoda           #  Dzielnica:district
  # Osoby prywatnej  #  Oferta od:from
  # 2                #  Poziom:lvl
  # Nie              #  Umeblowane:furniture
  # Blok             #  Rodzaj zabudowy:body
  # 44 m2            #  Powierzchnia:area
  # 2 pokoje         #  Liczba pokoi:rooms

  @lookup = {
      'Dzielnica:' => 'district',
      'Oferta od:' => 'from',
      'Poziom:' => 'lvl',
      'Umeblowane:' => 'furniture',
      'Rodzaj zabudowy:' => 'body',
      'Powierzchnia:' => 'area',
      'Liczba pokoi:' => 'rooms'
  }

  def self.import_offers page = nil
    url = 'http://olx.pl/nieruchomosci/mieszkania/wynajem/bialystok/?search%5Bdist%5D=5'
    url<<'&page='<<page.to_s if page
    doc = Nokogiri::HTML(open(url))
    links = doc.css('#offers_table .offer h3 a.detailsLink @href')
    links.reverse_each { |link| self.create_offer(link) }
  end

  def self.create_offer(link)
    puts link
    page_url = cleanup_link(link)
    #offer already present - return
    if Flat.where(url: page_url).first
      return
    end
    doc = Nokogiri::HTML(open(link))

    res = {
        title: doc.css(".offerheadinner h1 text()").to_s.strip,
        address: doc.css(".offerheadinner p span strong text()").to_s.strip,
        images: doc.css(".offerdescription .img-item div img @src").map { |elem| elem.to_s },
        desc: doc.xpath("//div[@id='textContent']/p/node()").to_html.strip,
        url: page_url,
        created_at: Time.now,
        full_price: false
    }

    street = res[:desc][/(ul\.|ul|ulic(y|a))\s+[[:alnum:]]+/]
    if street
      res[:address]<<', '<< street
    end
    hash = res.merge(parse_details(doc)).merge(parse_price(doc))

    Flat.create hash
  end

  def self.parse_details(doc)
    details = doc.css(".descriptioncontent table tr td div").map do |elem|
      if elem
        [@lookup[elem.css('text()')[0].to_s.strip], elem.css('strong text()').to_s.strip]
      end
    end
    Hash[details]
  end
  # extract price value, and negotiate
  def self.parse_price(doc)
    price_label = doc.css(".offerbox .pricelabel text()").to_s.strip
    puts price_label
    {price: price_label[/\A[\d\s]*/].sub(' ', ''),
     negotiate: price_label[/Do negocjacji/].present?
    }
  end
  ###
  # remove #fragment from url
  def self.cleanup_link(link)
    u = URI(link)
    u.fragment = nil
    u.to_s
  end


end