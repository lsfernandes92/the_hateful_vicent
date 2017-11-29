#!/bin/env ruby
# encoding: utf-8

# author: Rodolpho Ferreira Rodrigues

module PageObjectModel
  module PageActions

    def to_center(element)
      rect_element = query(element).first['rect']

      from_x = rect_element['center_x']
      from_y = rect_element['center_y']
      to_x = screen_coordinate['center_x']
      to_y = screen_coordinate['center_y']

      drag_coordinates(from_x, from_y, to_x, to_y)
    end

    def to_top(element)
      rect_element = query(element).first['rect']

      from_x = rect_element['center_x']
      from_y = rect_element['center_y']
      to_x = rect_element['x']
      to_y = 150

      drag_coordinates(from_x, from_y, to_x, to_y, 30)
    end

    # About scroll_.* methods
    # scroll_types: :light, :normal and :strong
    # directions: :up and :down
    # by default :scroll_type is :soft and :direction is :down
    def scroll_and_touch(element, options = {})
      scroll_until_i_see(element, options)
      touch(element)
    end

    def scroll_until_i_see(element, options = {})
      search(element, options)
    end

    def scroll_until_i_see_mark(mark, options = {})
      search("* marked:'#{mark}'", options)
    end

    def tap_on_text(text)
      element = Element.new("* { text CONTAINS[c] '#{text}'}")
      element.await.touch
    end

    def scroll_by_type(direction, type)
      swipe direction, force: type
    end

    # Description: Method to perform a swipe to the delta coordinates
    # Flick up: move screen to the bottom
    # delta = {:x => 0, :y => -124.0}
    # Flick down: move screen to the top
    # delta = {:x => 0, :y => 124.0}
    def flick_screen(delta = {:x => 0, :y => -80})
      flick("*", delta)
      sleep 1
    end

    def until_not_have_same_content(opts = { raise_if_not_found: nil })
      current_content = query('*')
      last_content = nil

      until current_content == last_content
        yield(current_content)
        last_content = current_content
        current_content = query('*')
      end

      element = opts[:raise_if_not_found]
      raise PageObjectModel::Exceptions::ElementNotFoundError,
        "Não foi encontrado elemento com a query: #{element}" if element
    end

    def wait_for_load_finish(timeout = 60)
      sleep 1
      begin
        wait_for_element_does_not_exist("* {text CONTAINS[c] 'Carregando'}", timeout: timeout)
      rescue Calabash::Cucumber::WaitHelpers::WaitError
        raise Calabash::Cucumber::WaitHelpers::WaitError,
          "Timeout! Excedido tempo de #{timeout} segundos de carregamento de página."
      end
    end

    def screen_coordinate
      @coordinates ||= query('DecorView').first['rect']
    end

    private

    def search(element, opts = {})
      opts = default_scroll_options.merge(opts)
      until_not_have_same_content raise_if_not_found: element do
        break if element_exists(element)
        scroll_by_type opts[:direction], opts[:scroll_type]
      end
    end

    def default_scroll_options
      { scroll_type: :light, direction: :up }
    end
  end
end

World(PageObjectModel::PageActions)
