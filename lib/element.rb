#!/bin/env ruby
# encoding: utf-8

# author: Rodolpho Ferreira Rodrigues

module PageObjectModel
  module CalabashProxy
    require 'calabash-cucumber/operations'
    include Calabash::Cucumber::Operations
  end
end

module PageObjectModel
  class Element
    attr_reader :selector

    def initialize(selector)
      @selector = selector
    end

    def set(text)
      query(setText: text.to_s)
    end

    def set_date(date)
      self.await_to_show_up
      self.touch
      calendar = PageObjectModel::DatePicker.new
      calendar.set_date date
      calendar.touch_ok_button
    end

    def id
      query['id']
    end

    def text
      query(:text)
    end

    def touch
      calabash_proxy.touch(self)
    end

    def double_tap
        calabash_proxy.double_tap(self)
    end

    def touch_transition(expected_query)
      calabash_proxy.touch_transition(self, expected_query)
    end

    def check
      query(setChecked: true)
    end

    def uncheck
      query(setChecked: false)
    end

    def clear
      calabash_proxy.clear_text(self)
    end

    def set_with_keyboard(text)
      self.touch
      calabash_proxy.wait_for_keyboard
      calabash_proxy.keyboard_enter_text(text.to_s)
    end

    def set_with_keyboard_and_hide(text)
      self.set_with_keyboard(text)
      button_ok_from_keyboard = Element.new("* marked:'OK'")
      button_ok_from_keyboard.await_to_show_up
      button_ok_from_keyboard.touch
    end

    def rect
      rect = query['rect']
      rect['size'] = (rect[:width] - rect[:height]).abs
      rect
    end

    def execute
      query
    end

    def class
      query['class']
    end

    def await(timeout = 15)
      calabash_proxy.wait_for_element_exists(self, timeout: timeout)
      self
    end

    def await_to_show_up
      calabash_proxy.wait_for_transition(self)
      self
    end

    def find_elements(selector)
      cql = "#{self} #{selector}"
      calabash_proxy.check_element_exists(cql)

      elements = query(selector)
      elements.map.with_index do |element, index|
        Element.new("#{cql} index:#{index}")
      end
    end

    def find_element(selector)
      cql = "#{self} #{selector} index:0"
      self.scroll_to
      Element.new(cql)
    end

    # by default is :up, but you can use :down to scroll down
    def scroll_to(direction = :up)
      scroll_until_i_see({ :direction => direction })
    end


    def visible?(timeout = 10)
      begin
        calabash_proxy.when_element_exists(self, timeout: timeout, action: -> { return true })
      rescue
        return false
      end
    end

    def has_text?(text)
      self.text.downcase.include?(text.downcase)
    end

    def selected?
      selected = query(:isSelected)
      selected == 1 ? true : false
    end

    def enabled?
      is_enabled = query(:isEnabled)
      is_enabled == 1 ? true : false
    end

    def checked?
      query(:isChecked)
    end

    def exists?
      calabash_proxy.element_exists(self)
    end

    def method_missing(method_name, *args, &block)
      if calabash_proxy.respond_to?(method_name)
        return calabash_proxy.send(method_name, selector, *args, &block)
      end
      if page_actions.respond_to?(method_name)
        if page_actions.method(method_name).arity == 1
          return page_actions.send(method_name, self)
        end
        return page_actions.send(method_name, selector, *args)
      end

      raise NoMethodError, "Undefined method '#{method_name}' with args '#{args}; for element with query: #{selector}"
    end

    def to_s
      @selector
    end

    def to_str
      @selector
    end

    private

    def calabash_proxy
      @calabash_proxy ||= Class.new.extend(PageObjectModel::CalabashProxy)
    end

    def page_actions
      @page_actions ||= Class.new.extend(PageObjectModel::CalabashProxy).extend(PageObjectModel::PageActions)
    end

    def query(opts = {})
      unless calabash_proxy.element_exists self
        raise "Não foi encontrado elemento com a query: #{selector}"
      end
      query = opts.empty? ? calabash_proxy.query(selector) : calabash_proxy.query(selector, opts)
      query.first
    end
  end
end

module PageObjectModel
  class DatePicker < PageObjectModel::Element
    extend ElementContainer

    attr_reader :date

    element :button_ok, "* text:'OK'"
    element :button_cancel, "* text:'Cancelar'"

    PATTERN_SET_DATE = '%d-%m-%Y'

    def initialize(business_day = DateTime.now)
      business_day = format_to_date_time(business_day) unless business_day.is_a? DateTime
      @date = business_day
    end

    def set_date(date)
      if date == :weekend || date == :saturday || date == :sunday
        date = DateTime.now.send("next_#{date}")
      elsif date == :full_month
        date = get_full_month_date
      elsif date.is_a? String
        date = format_to_date_time(date)
      end
      calabash_proxy.picker_set_date_time date
    end

    def set_day(day)
      self.set_date(DateTime.new(@date.year, @date.month, day.to_i))
    end

    def touch_ok_button
      button_ok.await_to_show_up
      button_ok.touch
    end

    def touch_cancel_button
      button_cancel.touch
    end

    private
    def get_full_month_date
      get_testable_month = -> (date) {
        while date.days_in_month != 31
          date = date.next_month
        end
        date
      }

      date = @date.next_month if @date.day >= 29 && @date.day <= 31
      date = get_testable_month.call(@date)
      date = DateTime.new(date.year, date.month, 1)

      date
    end

    def format_to_str(date)
      date.strftime(PATTERN_SET_DATE)
    end

    def format_to_date_time(date)
      date = date.tr('/', '-') if date.include? '/'
      DateTime.strptime(date, PATTERN_SET_DATE)
    end
  end
end
