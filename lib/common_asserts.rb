#!/bin/env ruby
# encoding: utf-8

module TheHatefulVicent
  module CommonAsserts
    def expect_page(page, timeout = 15)
      name = page.respond_to?(:name) ? page.name : page.class.name
      part = page.class.name.end_with?('Section') ? 'Seção' : 'Página'

      begin
        page.await(timeout: timeout)
        expect(page).to be_displayed
      rescue RSpec::Expectations::ExpectationNotMetError
        raise RSpec::Expectations::ExpectationNotMetError,
          "#{part} #{name} não foi apresentada. Talvez o trait informado para a " +
          "mesma não esteja correto!"
      rescue Calabash::Cucumber::WaitHelpers::WaitError
        raise Calabash::Cucumber::WaitHelpers::WaitError,
          "#{part} #{name} não foi apresentada. Excedido timeout de #{timeout} " +
          "segundos para apresentação."
      end
    end

    def assert_popup(*elements)
      begin
        wait_for_elements_exist(elements, timeout: 10)
        true
      rescue
        false
      end
    end

    alias_method :assert_section, :assert_popup
    alias_method :expect_section, :expect_page
  end
end
