require 'spec_helper'

describe Shortcode::Tag do

  context "when the template file is missing" do

    let(:tag) { Shortcode::Tag.new('doesnt_exist') }

    it "raises a TemplateNotFound error when the file doesn't exists" do
      expect { tag.wrap }.to raise_error(Shortcode::TemplateNotFound)
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
      expect { tag.wrap }.to raise_error(Shortcode::TemplateParserNotSupported)
    end

  end

end
