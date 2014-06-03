require 'spec_helper'

describe Shortcode::Tag do

  context "when the template file is missing" do

    let(:tag) { Shortcode::Tag.new('doesnt_exist') }

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.render }.to raise_error(Shortcode::TemplateNotFound)
    end

  end

  context "when an unsupported template parser is specified" do

    let(:tag) { Shortcode::Tag.new('quote') }

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :something_crazy
      end
    end

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.render }.to raise_error(Shortcode::TemplateParserNotSupported)
    end

  end

  context "templates from strings" do

    let(:tag) { Shortcode::Tag.new('from_string', [{ key: 'string', value: 'batman' }]) }

    before(:each) do
      Shortcode.setup do |config|
        config.templates = {
          from_string: '<p><%= @attributes[:string] %></p>'
        }
      end
    end

    it "renders a template from a string" do
      expect(tag.render).to eq('<p>batman</p>')
    end

  end

  context "when the template is missing from the config" do

    let(:tag) { Shortcode::Tag.new('missing', [{ key: 'string', value: 'batman' }]) }

    before(:each) do
      Shortcode.setup do |config|
        config.templates = {
          from_string: '<p><%= @attributes[:string] %></p>'
        }
      end
    end

    it "raises an error" do
      expect { tag.render }.to raise_error(Shortcode::TemplateNotFound)
    end

  end

end
