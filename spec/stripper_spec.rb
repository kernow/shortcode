require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

describe Shortcode do

  let(:parser)      { Shortcode::Parser.new }
  let(:transformer) { Shortcode::Stripper.new }

  let(:simple_quote)          { load_fixture :simple_quote }
  let(:full_quote)            { load_fixture :full_quote }
  let(:quote_with_extras)     { load_fixture :quote_with_extras }
  let(:simple_list)           { load_fixture :simple_list }
  let(:timeline_event)        { load_fixture :timeline_event }
  let(:timeline_info)         { load_fixture :timeline_info }
  let(:timeline_person)       { load_fixture :timeline_person }
  let(:complex_snippet)       { load_fixture :complex_snippet }
  let(:block_with_whitespace) { load_fixture :block_with_whitespace }

  let(:quotes)            { [simple_quote, full_quote, quote_with_extras] }
  let(:collapsible_lists) { [simple_list] }
  let(:timelines)         { [timeline_event, timeline_info, timeline_person] }

  let(:simple_quote_output)          { load_fixture :simple_quote_stripped }
  let(:full_quote_output)            { load_fixture :full_quote_stripped }
  let(:quote_with_extras_output)     { load_fixture :quote_with_extras_stripped }
  let(:simple_list_output)           { load_fixture :simple_list_stripped }
  let(:timeline_event_output)        { load_fixture :timeline_event_stripped }
  let(:timeline_info_output)         { load_fixture :timeline_info_stripped }
  let(:timeline_person_output)       { load_fixture :timeline_person_stripped }
  let(:complex_snippet_output)       { load_fixture :complex_snippet_stripped }
  let(:block_with_whitespace_output) { load_fixture :block_with_whitespace_stripped }

  context "simple_quote" do

    it "strips the shortcodes" do
      obj = parser.parse(simple_quote)
      html = transformer.apply obj, additional_attributes: nil
      expect(html).to eq(simple_quote_output)
    end

  end

  context "full_quote" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(full_quote), additional_attributes: nil)
      expect(stripped).to eq(full_quote_output)
    end

  end

  context "quote_with_extras" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(quote_with_extras), additional_attributes: nil)
      expect(stripped).to eq(quote_with_extras_output)
    end

  end

  context "simple_list" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(simple_list), additional_attributes: nil)
      expect(stripped).to eq(simple_list_output)
    end

  end

  context "timeline_event" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(timeline_event), additional_attributes: nil)
      expect(stripped).to eq(timeline_event_output)
    end

  end

  context "timeline_info" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(timeline_info), additional_attributes: nil)
      expect(stripped).to eq(timeline_info_output)
    end

  end

  context "timeline_person" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(timeline_person), additional_attributes: nil)
      expect(stripped).to eq(timeline_person_output)
    end

  end

  context "complex_snippet" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(complex_snippet), additional_attributes: nil)
      expect(stripped).to eq(complex_snippet_output)
    end
  end

  context "erb templates" do

    it "strips the shortcodes" do
      stripped = transformer.apply(parser.parse(simple_quote), additional_attributes: nil)
      expect(stripped).to eq(simple_quote_output)
    end
  end

  context 'whitespace' do

    it 'is preserved after a block tag' do
      stripped = transformer.apply(parser.parse(block_with_whitespace), additional_attributes: nil)
      expect(stripped).to eq(block_with_whitespace_output)
    end

  end
end
