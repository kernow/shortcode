require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

class MyPresenter

  def self.for
    :quote
  end

  def initialize(attributes, content)
    @attributes = attributes
    @content = content
  end

  def content
    @content
  end

  def attributes
    { title: "my custom title" }
  end
end

describe Shortcode::Presenter do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_presenter_output, :html }

  describe "using a custom presenter" do

    before do
      Shortcode.register_presenter MyPresenter
    end

    it "uses the custom attributes" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output.gsub("\n",'')
    end

  end

end
