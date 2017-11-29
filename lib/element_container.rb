module TheHatefulVicent
  module ElementContainer
    def element(element_name, selector)
      class_eval %{
        def #{element_name}
          @#{element_name} ||= TheHatefulVicent::Element.new("#{selector}")
        end
      }
    end

    def elements(collection_name, selector, opt = nil)
      define_method collection_name.to_s do
        elements = query(selector, *opt)

        unless elements.empty?
          elements = if opt.nil?
            elements.map.with_index { |_element, index|
              TheHatefulVicent::Element.new("#{selector} index:#{index}")
            }
          else
            elements.select{ |e| !e.is_a? Hash }
          end
        end

        elements
      end
    end

    def section(element_name, class_name)
      class_eval %{
        def #{element_name}
          @#{element_name} ||= page(#{class_name})
        end
      }
    end
  end
end
