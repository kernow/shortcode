require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

require 'support/presenters/my_presenter'
require 'support/presenters/other_presenter'
require 'support/presenters/multiple_presenter'
require 'support/presenters/missing_for_presenter'
require 'support/presenters/missing_initialize_presenter'
require 'support/presenters/missing_content_presenter'
require 'support/presenters/missing_attributes_presenter'

describe Shortcode::Presenter do

  let(:simple_quote)  { load_fixture :simple_quote }
  let(:item)          { load_fixture :item }

  before do
    Shortcode.setup do |config|
      config.template_parser = :erb
      config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      config.templates = nil
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper, :custom_helper]
      config.self_closing_tags = [:timeline_event, :timeline_info]
      config.attribute_quote_type = '"'
      config.use_attribute_quotes = true
    end
  end

  describe "using a custom presenter" do

    let(:presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
    let(:attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }

    before do
      Shortcode.register_presenter MyPresenter
    end

    it "uses the custom attributes" do
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(presenter_output)
    end

    it "passes through additional attributes" do
      expect(Shortcode.process(simple_quote, { title: 'Additional attribute title' }).gsub("\n",'')).to eq(attributes_output)
    end

  end

  describe "using a single presenter for multiple shortcodes" do

    let(:quote_presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
    let(:item_presenter_output)   { load_fixture :item_presenter_output,         :html }

    let(:quote_attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }
    let(:item_attributes_output)  { load_fixture :item_presenter_attributes_output,         :html }

    before do
      Shortcode.register_presenter MultiplePresenter
    end

    it "uses the custom attributes" do
      expect(Shortcode.process(simple_quote ).gsub("\n",'')).to eq(quote_presenter_output)
      expect(Shortcode.process(item         ).gsub("\n",'')).to eq(item_presenter_output)
    end

    it "passes through additional attributes" do
      expect(Shortcode.process(simple_quote, { title: 'Additional attribute title' }).gsub("\n",'')).to eq(quote_attributes_output)
      expect(Shortcode.process(item,         { title: 'Additional attribute title' }).gsub("\n",'')).to eq(item_attributes_output)
    end

  end

  context "presenter registration" do

    describe "registering a single presenter" do

      before do
        Shortcode.register_presenter MyPresenter
      end

      it "adds the presenter to the list" do
        expect(Shortcode.configuration.presenters).to include(MyPresenter.for)
      end

    end

    describe "registering multiple presenters" do

      before do
        Shortcode.register_presenter(MyPresenter, OtherPresenter)
      end

      it "adds the presenter to the list" do
        expect(Shortcode.configuration.presenters).to include(MyPresenter.for)
        expect(Shortcode.configuration.presenters).to include(OtherPresenter.for)
      end

    end

  end

  context "presenter validation" do

    describe "missing #for class method" do

      it "raises an exception" do
        expect { Shortcode.register_presenter MissingForPresenter }.to raise_error(ArgumentError, "The presenter must define the class method #for")
      end

    end

    describe "missing #initialize method" do

      it "raises an exception" do
        expect { Shortcode.register_presenter MissingInitializePresenter }.to raise_error(ArgumentError, "The presenter must define an initialize method")
      end

    end

    describe "missing #content method" do

      it "raises an exception" do
        expect { Shortcode.register_presenter MissingContentPresenter }.to raise_error(ArgumentError, "The presenter must define the method #content")
      end

    end

    describe "missing #attributes method" do

      it "raises an exception" do
        expect { Shortcode.register_presenter MissingAttributesPresenter }.to raise_error(ArgumentError, "The presenter must define the method #attributes")
      end

    end

  end

end
