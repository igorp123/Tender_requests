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
    request.customer_drugs.destroy_all
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

      new_drug = request.customer_drugs.where(mnn: drug_name,
                                     quantity: drug_quantity,
                                     price: drug_price,
                                     cost: drug_cost).first_or_initialize

      drug.search("drugInfo").each do |drug_form|
        form = drug_form.search('medicamentalFormName').text

        value = drug_form.search('dosageGRLSValue').text

        unit = if drug_form.search('manualUserOKEI/name').any?
                 drug_form.search('manualUserOKEI/name')

               else
                 drug_form.search('dosageUserOKEI/name')
               end

        new_drug.dosages.build(form: form, value: value, unit: unit.text)
      end

      end



    # xml_doc.search("drugPurchaseObjectInfo").each do |drug|
    #   drug_name = drug.search('MNNName').first.text
    #   drug_quantity = drug.search('drugQuantity').first.text
    #   drug_price = drug.search('pricePerUnit').first.text
    #   drug_cost = drug.search('positionPrice').first.text
    #
    #   if request.customer_drugs.detect{ |c| c.mnn == drug_name &&
    #       c.quantity == drug_quantity &&
    #       c.price == drug_price &&
    #       c.cost == drug_cost}.blank?
    #
    #     new_drug = request.customer_drugs.build(mnn: drug_name,
    #                                             quantity: drug_quantity,
    #                                             price: drug_price,
    #                                             cost: drug_cost)
    #     new_drug.dosages.build(form: drug.search().text)
    #
    #   end
    #
    # end

      # puts aaa.search("medicamentalFormName")
      # puts aaa.search("dosageGRLSValue")
      # puts aaa.search("name") #dosageUserOKEI manualUserOKEI


  end

  # private
  #
  # def self.xml_element(doc, path)
  #   value = doc.root.elements[path]
  #   value.text unless value.blank?
  # end

end