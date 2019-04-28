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

    xml_doc = agent.get(xml_link).xml.remove_namespaces!

    request.number = xml_doc.search(XML_PATH_NUMBER)
    request.etp = xml_doc.search(XML_PATH_ETP).text
    request.customer = xml_doc.search(XML_PATH_CUSTOMER).text
    request.purchase_info = xml_doc.search(XML_PATH_PURCHASE_INFO).text
    request.max_price = xml_doc.search(XML_PATH_MAX_PRICE).text
    request.delivery_time = xml_doc.search(XML_PATH_DELIVERY_TIME).text

    kladr_address = xml_doc.search(XML_PATH_KLADR_PLACE).text
    request.delivery_place = "#{kladr_address} ||||| #{xml_doc.search(XML_PATH_DELIVERY_PLACE).text}"

    xml_doc.search("drugPurchaseObjectInfo").each do |drug|
      drug_name = drug.search('MNNName').first.text
      drug_quantity = drug.search('drugQuantity').first.text
      drug_price = drug.search('pricePerUnit').first.text
      drug_cost = drug.search('positionPrice').first.text

      new_drug = find_or_build(request.customer_drugs, {mnn: drug_name, quantity: drug_quantity, price: drug_price, cost: drug_cost })

      drug.search("drugInfo").each do |drug_form|
        form = drug_form.search('medicamentalFormName').text

        value = drug_form.search('dosageGRLSValue').text

        unit = if drug_form.search('manualUserOKEI/name').any?
                 drug_form.search('manualUserOKEI/name').text
               else
                 drug_form.search('dosageUserOKEI/name').text
               end

        new_drug.dosages.detect{|x| x.form == form && x.value == value && x.unit == unit} ||
            new_drug.dosages.build(form: form, value: value, unit: unit)
      end
    end
  end

  private

  def self.find_or_build(model, attributes)
    model.detect{ |x| x.mnn == attributes[:mnn] &&
                      x.quantity == attributes[:quantity] &&
                      x.price == attributes[:price] } ||
      model.build(attributes)
  end
end