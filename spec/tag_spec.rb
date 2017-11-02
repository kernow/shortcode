require 'spec_helper'

describe Shortcode::Tag do
  let(:configuration) {
    Shortcode.new.tap { |s|
      s.setup do |config|
        config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      end
    }.configuration
  }

  context "when the template file is missing" do

    let(:tag) { Shortcode::Tag.new('doesnt_exist', configuration) }

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.render }.to raise_error(Shortcode::TemplateNotFound)
    end

  end

  context "when an unsupported template parser is specified" do

    before(:each) do
      configuration.template_parser = :something_crazy
    end

    let(:tag) { Shortcode::Tag.new('quote', configuration) }

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.render }.to raise_error(Shortcode::TemplateParserNotSupported)
    end

  end

  context "templates from strings" do

    let(:tag) { Shortcode::Tag.new('from_string', configuration, [{ key: 'string', value: 'batman' }]) }

    before(:each) do
      configuration.templates[:from_string] = '<p><%= @attributes[:string] %></p>'
    end

    it "renders a template from a string" do
      expect(tag.render).to eq('<p>batman</p>')
    end

  end

  context "when the template is missing from the config" do

    let(:tag) { Shortcode::Tag.new('missing', configuration, [{ key: 'string', value: 'batman' }]) }

    before(:each) do
      configuration.templates[:from_string] = '<p><%= @attributes[:string] %></p>'
    end

    it "raises an error" do
      expect { tag.render }.to raise_error(Shortcode::TemplateNotFound)
    end

  end

  context "when templates exist both in configuration and file system" do
    let(:tag) { Shortcode::Tag.new('quote', configuration ) }

    before(:each) do
      configuration.templates[:quote] = '<p><%= @content %></p>'
    end

    it 'uses the configuration template when check_config_templates_first is true' do
      expect(tag.markup).to eq('<p><%= @content %></p>')
    end

    it 'uses the file system template when check_config_templates_first is false' do
      configuration.check_config_templates_first = false

      expect(tag.markup).to eq(File.open('spec/support/templates/erb/quote.html.erb').read)
    end
  end

end
