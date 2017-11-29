#!/bin/env ruby
# encoding: utf-8

# author: Rodolpho Ferreira Rodrigues

module PageObjectModel
  require 'calabash-cucumber/ibase'
  class Page < Calabash::IBase
    extend ElementContainer

    def initialize(world, transition_duration = 0.5)
      super(world, transition_duration)
    end

    def self.trait(selector)
      class_eval %(
        def trait
          "#{selector}"
        end
      )
    end

    def self.title(title)
      class_eval %(
        def title
          "#{title}"
        end
      )
    end

    def self.page_name(name)
      class_eval %(
        def name
          "#{name}"
        end
      )
    end

    alias_method :displayed?, :current_page?

    class << self
      alias_method :section_name, :page_name
    end

    def go_back
      press_back_button
    end

    def to_top_page
      scroll_by_type :up, :strong
    end

    def to_end_page
     scroll_by_type :up, :strong
    end
  end
end
