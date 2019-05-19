module Models
  module Request
    module XmlParse
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


      def xml_parse

        agent = Mechanize.new

        agent.user_agent_alias = 'Mac Safari'

        page = agent.get("#{ZAKUPKI_URL}#{ZAKUPKI_AUCTION_URL}#{auction_number}")

        xml_link = "#{ZAKUPKI_URL}#{page.link_with(class: 'size14').href.gsub('view.html', 'viewXml.html')}"

        xml_doc = agent.get(xml_link).xml.remove_namespaces!

        self.number = xml_doc.search(XML_PATH_NUMBER)
        self.etp = xml_doc.search(XML_PATH_ETP).text
        self.customer = xml_doc.search(XML_PATH_CUSTOMER).text
        self.purchase_info = xml_doc.search(XML_PATH_PURCHASE_INFO).text
        self.max_price = xml_doc.search(XML_PATH_MAX_PRICE).text
        self.delivery_time = xml_doc.search(XML_PATH_DELIVERY_TIME).text

        kladr_address = xml_doc.search(XML_PATH_KLADR_PLACE).text
        self.delivery_place = "#{kladr_address} ||||| #{xml_doc.search(XML_PATH_DELIVERY_PLACE).text}"

        xml_doc.search("drugPurchaseObjectInfo").each do |drug|
          customer_drugs_attributes = {
            mnn: drug.search('MNNName').first.text,
            quantity: drug.search('drugQuantity').first.text,
            price: drug.search('pricePerUnit').first.text,
            cost: drug.search('positionPrice').first.text,
          }

          new_drug = find_or_build_customer_drug(customer_drugs_attributes)

          drug.search("drugInfo").each do |drug_form|
            dosages_attributes = {
              form: drug_form.search('medicamentalFormName').text,
              value: drug_form.search('dosageGRLSValue').text,
              unit: if drug_form.search('manualUserOKEI/name').any?
                      drug_form.search('manualUserOKEI/name').text
                    else
                      drug_form.search('dosageUserOKEI/name').text
                    end
            }

            find_or_create_dosage(new_drug, dosages_attributes)
          end

          add_quantity_to_request_drugs
        end
      end

      private

      def find_or_build_customer_drug(attributes)
        self.customer_drugs.detect do |drug|
          drug.mnn == attributes[:mnn] &&
            drug.quantity == attributes[:quantity] &&
            drug.price == attributes[:price]
        end || customer_drugs.build(attributes)
      end


      def find_or_create_dosage(drug, attributes)
        drug.dosages.detect do |dosage|
          dosage.form == attributes[:form] &&
            dosage.value == attributes[:value] &&
            dosage.unit == attributes[:unit]
        end || drug.dosages.build(attributes)
      end

      def add_quantity_to_request_drugs
        self.request_drugs.destroy_all

        self.customer_drugs.each do |drug|
          self.request_drugs.build(quantity: drug.quantity, unit: drug.dosages.first.unit)
        end
      end
    end
  end
end
