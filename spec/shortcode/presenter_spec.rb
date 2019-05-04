require "spec_helper"
require "parslet/rig/rspec"
require "pp"

require "support/presenters/my_presenter"
require "support/presenters/other_presenter"
require "support/presenters/multiple_presenter"
require "support/presenters/missing_for_presenter"
require "support/presenters/missing_initialize_presenter"
require "support/presenters/child_presenter"
require "support/presenters/child_missing_initialize_presenter"
require "support/presenters/missing_content_presenter"
require "support/presenters/missing_attributes_presenter"

describe Shortcode::Presenter do
  let(:shortcode) { Shortcode.new }
  let(:configuration) { shortcode.configuration }
  let(:simple_quote)  { load_fixture :simple_quote }
  let(:item)          { load_fixture :item }

  before do
    configuration.block_tags = %i[quote item]
    configuration.template_path = File.join File.dirname(__FILE__), "../support/templates/erb"
  end

  describe "using a custom presenter" do
    let(:presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
    let(:attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }

    before do
      shortcode.register_presenter MyPresenter
    end

    it "uses the custom attributes" do
      expect(shortcode.process(simple_quote).delete("\n")).to eq(presenter_output)
    end

    it "passes through additional attributes" do
      expect(shortcode.process(simple_quote, title: "Additional attribute title").delete("\n"))
        .to eq(attributes_output)
    end
  end

  describe "using a single presenter for multiple shortcodes" do
    let(:quote_presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
    let(:item_presenter_output)   { load_fixture :item_presenter_output,         :html }

    let(:quote_attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }
    let(:item_attributes_output)  { load_fixture :item_presenter_attributes_output,         :html }

    before do
      shortcode.register_presenter MultiplePresenter
    end

    it "uses the custom attributes" do
      expect(shortcode.process(simple_quote).delete("\n")).to eq(quote_presenter_output)
      expect(shortcode.process(item).delete("\n")).to eq(item_presenter_output)
    end

    it "passes through additional attributes" do
      expect(shortcode.process(simple_quote, title: "Additional attribute title").delete("\n"))
        .to eq(quote_attributes_output)
      expect(shortcode.process(item, title: "Additional attribute title").delete("\n"))
        .to eq(item_attributes_output)
    end
  end

  describe "presenter registration" do
    context "when registering a single presenter" do
      before do
        shortcode.register_presenter MyPresenter
      end

      it "adds the presenter to the list" do
        expect(configuration.presenters).to include(MyPresenter.for)
      end
    end

    context "when registering multiple presenters" do
      before do
        shortcode.register_presenter(MyPresenter, OtherPresenter)
      end

      it "adds the presenter to the list" do
        expect(configuration.presenters).to include(MyPresenter.for)
        expect(configuration.presenters).to include(OtherPresenter.for)
      end
    end
  end

  describe "presenter validation" do
    context "when missing #for class method" do
      it "raises an exception" do
        expect { shortcode.register_presenter MissingForPresenter }
          .to raise_error(ArgumentError, "The presenter must define the class method #for")
      end
    end

    context "when missing #initialize method" do
      it "raises an exception" do
        expect { shortcode.register_presenter MissingInitializePresenter }
          .to raise_error(ArgumentError, "The presenter must define an initialize method")
      end
    end

    context "when initialize exists on non-Object ancestor class" do
      it "does not raise an exception" do
        expect { shortcode.register_presenter ChildPresenter }
          .not_to raise_error
      end
    end

    context "when self and ancestory are missing #initialize method" do
      it "raises an exception" do
        expect { shortcode.register_presenter ChildMissingInitializePresenter }
          .to raise_error(ArgumentError, "The presenter must define an initialize method")
      end
    end

    context "when missing #content method" do
      it "raises an exception" do
        expect { shortcode.register_presenter MissingContentPresenter }
          .to raise_error(ArgumentError, "The presenter must define the method #content")
      end
    end

    context "when missing #attributes method" do
      it "raises an exception" do
        expect { shortcode.register_presenter MissingAttributesPresenter }
          .to raise_error(ArgumentError, "The presenter must define the method #attributes")
      end
    end
  end
end
