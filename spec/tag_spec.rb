require 'spec_helper'

describe Shortcode::Tag do

  let(:configuration) {
    Shortcode::Configuration.new.tap do |config|
      config.template_parser = :erb
      config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      config.templates = nil
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper, :custom_helper]
      config.self_closing_tags = [:timeline_event, :timeline_info]
      config.attribute_quote_type = '"'
      config.use_attribute_quotes = true
    end
  }

  context "when the template file is missing" do

    let(:tag) { Shortcode::Tag.new('doesnt_exist', configuration) }

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.render }.to raise_error(Shortcode::TemplateNotFound)
    end

  end

  context "when an unsupported template parser is specified" do

    let(:configuration) {
      Shortcode::Configuration.new.tap do |config|
        config.template_parser = :something_crazy
      end
    }
    let(:tag) { Shortcode::Tag.new('quote', configuration) }

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.render }.to raise_error(Shortcode::TemplateParserNotSupported)
    end

  end

  context "templates from strings" do
    let(:configuration) {
      Shortcode::Configuration.new.tap do |config|
        config.templates = {
          from_string: '<p><%= @attributes[:string] %></p>'
        }
      end
    }
    let(:tag) { Shortcode::Tag.new('from_string', configuration, [{ key: 'string', value: 'batman' }]) }

    it "renders a template from a string" do
      expect(tag.render).to eq('<p>batman</p>')
    end

  end

  context "when the template is missing from the config" do
    let(:configuration) {
      Shortcode::Configuration.new.tap do |config|
        config.templates = {
          from_string: '<p><%= @attributes[:string] %></p>'
        }
      end
    }
    let(:tag) { Shortcode::Tag.new('missing', configuration, [{ key: 'string', value: 'batman' }]) }

    it "raises an error" do
      expect { tag.render }.to raise_error(Shortcode::TemplateNotFound)
    end

  end

end
