require 'spec_helper'

describe "template parsers" do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  context "erb" do

    # TODO remove this before block as erb will eb the default at version 0.4
    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :erb
        config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      end
    end

    it "can render a template" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output.gsub("\n",'')
    end

  end

  context "haml" do

    it "can render a template" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output.gsub("\n",'')
    end

    context "when specified in the config" do

      before(:each) do
        Shortcode.setup do |config|
          config.template_parser = :haml
        end
      end

      it "does not show a deprecation warning" do
        expect { Shortcode.process(simple_quote) }.not_to write(Shortcode.configuration.haml_deprecation_warning).to(:error)
      end

    end

    context "when not specifed in the config" do

      it "shows a deprecation warning" do
        expect { Shortcode.process(simple_quote) }.to write(Shortcode.configuration.haml_deprecation_warning).to(:error)
      end

    end

  end

  context "slim" do

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :slim
        config.template_path = File.join File.dirname(__FILE__), "support/templates/slim"
      end
    end

    it "can render a template" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output.gsub("\n",'')
    end

  end

end
