module RequestsHelper
end

ZAKUPKI_URL = "http://www.zakupki.gov.ru/epz/order/notice/ea44/view/common-info.html?regNumber=#{auction_number}"
ZAKUPKI_SHORT_URL = "http://zakupki.gov.ru"

def parse_xml(auction_number)

agent = Mechanize.new

agent.user_agent_alias = 'Mac Safari'

page = agent.get(ZAKUPKI_URL)

xml_link = "#{ZAKUPKI_SHORT_URL}#{page.link_with(class: 'size14').href.gsub('view.html', 'viewXml.html')}"

page = agent.get(xml_link).body

xml_doc = REXML::Document.new(page)

xml_values = {}

xml_values[
  number: "*/id"
]

fields = %w[*/id */ETP/name */purchaseObjectInfo */lot/maxPrice
            */lot/customerRequirements/customerRequirement/customer/fullName
            */lot/customerRequirements/customerRequirement/deliveryTerm]

# address = REXML::XPath.first(xml_doc, "*/lot/customerRequirements/customerRequirement/kladrPlaces/kladrPlace/kladr/fullName")
# address = address.text until address.blank?
#
# address = "#{address}, #{REXML::XPath.first(xml_doc, "*/lot/customerRequirements/customerRequirement/kladrPlaces/kladrPlace/deliveryPlace").text}"


fields.each do |field|
  REXML::XPath.first(xml_doc, field).text
end




end

