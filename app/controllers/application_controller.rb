require 'rexml/document'

class ApplicationController < ActionController::Base
  ZAKUPKI_URL = "http://www.zakupki.gov.ru/epz/order/notice/ea44/view/common-info.html?regNumber="
  ZAKUPKI_SHORT_URL = "http://zakupki.gov.ru"

  helper_method :parse_xml

  def parse_xml(auction_number)
    agent = Mechanize.new

    agent.user_agent_alias = 'Mac Safari'

    page = agent.get("#{ZAKUPKI_URL}#{auction_number}")

    xml_link = "#{ZAKUPKI_SHORT_URL}#{page.link_with(class: 'size14').href.gsub('view.html', 'viewXml.html')}"

    page = agent.get(xml_link).body

    xml_doc = REXML::Document.new(page)

    @request.number = REXML::XPath.first(xml_doc, "*/id").text
    @request.etp = REXML::XPath.first(xml_doc, "*/ETP/name",).text
    @request.customer = REXML::XPath.first(xml_doc, "*/lot/customerRequirements/customerRequirement/customer/fullName",).text
    @request.purchase_info = REXML::XPath.first(xml_doc, "*/purchaseObjectInfo").text
    @request.max_price = REXML::XPath.first(xml_doc, "*/lot/maxPrice").text
    @request.delivery_time = REXML::XPath.first(xml_doc, "*/lot/customerRequirements/customerRequirement/deliveryTerm").text


    # address = REXML::XPath.first(xml_doc, "*/lot/customerRequirements/customerRequirement/kladrPlaces/kladrPlace/kladr/fullName")
    # address = address.text until address.blank?
    #
    # address = "#{address}, #{REXML::XPath.first(xml_doc, "*/lot/customerRequirements/customerRequirement/kladrPlaces/kladrPlace/deliveryPlace").text}"
  end
end
