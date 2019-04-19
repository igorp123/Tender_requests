require 'rexml/document'

class ZakupkiXmlService
  ZAKUPKI_URL = "http://zakupki.gov.ru"
  ZAKUPKI_AUCTION_URL = "/epz/order/notice/ea44/view/common-info.html?regNumber="

  XML_PATH_NUMBER = 'id'
  XML_PATH_ETP = 'ETP/name'
  XML_PATH_CUSTOMER = 'lot/customerRequirements/customerRequirement/customer/fullName'
  XML_PATH_PURCHASE_INFO = 'purchaseObjectInfo'
  XML_PATH_MAX_PRICE = 'lot/maxPrice'
  XML_PATH_DELIVERY_TIME = 'lot/customerRequirements/customerRequirement/deliveryTerm'
  XML_PATH_KLADR_PLACE = 'lot/customerRequirements/customerRequirement/kladrPlaces/kladrPlace/kladr/fullName'
  XML_PATH_DELIVERY_PLACE = 'lot/customerRequirements/customerRequirement/kladrPlaces/kladrPlace/deliveryPlace'

  def self.call(request)
    agent = Mechanize.new

    agent.user_agent_alias = 'Mac Safari'

    page = agent.get("#{ZAKUPKI_URL}#{ZAKUPKI_AUCTION_URL}#{request.auction_number}")

    xml_link = "#{ZAKUPKI_URL}#{page.link_with(class: 'size14').href.gsub('view.html', 'viewXml.html')}"

    page = agent.get(xml_link)

    xml_doc = REXML::Document.new(page.body)

    request.number = xml_element(xml_doc, XML_PATH_NUMBER)
    request.etp = xml_element(xml_doc, XML_PATH_ETP)
    request.customer = xml_element(xml_doc, XML_PATH_CUSTOMER)
    request.purchase_info = xml_element(xml_doc, XML_PATH_PURCHASE_INFO)
    request.max_price = xml_element(xml_doc, XML_PATH_MAX_PRICE)
    request.delivery_time = xml_element(xml_doc, XML_PATH_DELIVERY_TIME)

    kladr_address = xml_element(xml_doc, XML_PATH_KLADR_PLACE)
    request.delivery_place = "#{kladr_address} ||||| #{xml_element(xml_doc, XML_PATH_DELIVERY_PLACE)}"
  end

  private

  def self.xml_element(doc, path)
    value = doc.root.elements[path]
    value.text unless value.blank?
  end

end