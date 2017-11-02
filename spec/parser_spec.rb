require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

describe Shortcode::Parser do

  let(:configuration) { Shortcode.new.configuration }
  let(:parser) { Shortcode::Parser.new(configuration) }

  let(:simple_quote)      { load_fixture :simple_quote }
  let(:full_quote)        { load_fixture :full_quote }
  let(:without_quotes)    { load_fixture :without_quotes }
  let(:quote_with_extras) { load_fixture :quote_with_extras }
  let(:simple_list)       { load_fixture :simple_list }
  let(:timeline_event)    { load_fixture :timeline_event }
  let(:timeline_info)     { load_fixture :timeline_info }
  let(:timeline_person)   { load_fixture :timeline_person }
  let(:complex_snippet)   { load_fixture :complex_snippet }

  let(:quotes)            { [simple_quote, full_quote, quote_with_extras] }
  let(:collapsible_lists) { [simple_list] }
  let(:timelines)         { [timeline_event, timeline_info, timeline_person] }

  it "parses quote shortcodes" do
    quotes.each do |string|
      expect(parser).to parse(string)
    end
  end

  describe "matching similar tags" do

    context "with the smaller tag listed first" do

      before do
        configuration.block_tags = [:xx, :xxx]
      end

      it "parses xx" do
        expect(parser.open).to parse("[xx]")
      end

      it "parses xxx" do
        expect(parser.open).to parse("[xxx]")
      end

    end

    context "with the smaller tag listed last" do

      before do
        configuration.block_tags = [:xxx, :xx]
      end

      it "parses xx" do
        expect(parser.open).to parse("[xx]")
      end

      it "parses xxx" do
        expect(parser.open).to parse("[xxx]")
      end

    end

  end

  context "attribute_quote_type configuration" do

    before do
      configuration.attribute_quote_type = "'"
    end

    it "parses quotes using custom quotations" do
      quotes.each do |string|
        # Change double quotes to single quotes in the fixture
        expect(parser).to parse(string.gsub '"', "'")
      end
    end

  end

  context "use_attribute_quotes configuration" do

    before do
      configuration.use_attribute_quotes = false
    end

    it "parses shortcodes with optional quotes" do
      expect(parser).to parse(without_quotes)
    end

  end

  it "parses list shortcodes" do
    collapsible_lists.each do |string|
      expect(parser).to parse(string)
    end
  end

  it "parses timeline shortcodes" do
    timelines.each do |string|
      expect(parser).to parse(string)
    end
  end

  it "parses complex nested shortcodes" do
    expect(parser).to parse(complex_snippet)
  end

  describe "parsed strings" do

    context "simple_quote" do

      let(:parsed_object) { parser.parse(simple_quote) }

      before do
        configuration.block_tags = [:quote]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{ open: "quote", options: [], inner: [{ text: "hello" }], close: "quote" }])
      end

    end

    context "full_quote" do

      let(:parsed_object) { parser.parse(full_quote) }

      before do
        configuration.block_tags = [:quote]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{
          open: "quote",
          options: [
            { key: "author", value: "Jamie Dyer" },
            { key: "title", value: "King of England" }
          ],
          inner: [{ text: "A quote" }],
          close: "quote"
        }])
      end

    end

    context "quote_with_extras" do

      let(:parsed_object) { parser.parse(quote_with_extras) }

      before do
        configuration.block_tags = [:quote]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([
          { text: "Blah blah " },
          {
            open: "quote",
            options: [
              { key: "author", value: "Jamie Dyer" }
            ],
            inner: [{ text: "A quote" }],
            close: "quote"
          },
          { text: " <br> blah blah\n" }
        ])
      end

    end

    context "simple_list" do

      let(:parsed_object) { parser.parse(simple_list) }

      before do
        configuration.block_tags = [:collapsible_list, :item]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{
          open: "collapsible_list",
          options: [],
          inner: [{
            open: "item",
            options: [{ key: "title", value: "Example title 1" }],
            inner: [{ text: "Example content 1" }],
            close: "item"
          },
          {
            open: "item",
            options: [{ key: "title", value: "Example title 2" }],
            inner: [{ text: "Example content 2" }],
            close: "item"
          },
          {
            open: "item",
            options: [{ key: "title", value: "Example title 3" }],
            inner: [{ text: "Example content 3" }],
            close: "item"
          }],
          close: "collapsible_list"
        }])
      end

    end

    context "timeline_event" do

      let(:parsed_object) { parser.parse(timeline_event) }

      before do
        configuration.self_closing_tags = [:timeline_event]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{
          open_close: "timeline_event",
          options: [
            { key: "date", value: "March 2013" },
            { key: "title", value: "a title" },
            { key: "link", value: "http://blah.com" }
          ]
        }])
      end

    end

    context "timeline_info" do

      let(:parsed_object) { parser.parse(timeline_info) }

      before do
        configuration.self_closing_tags = [:timeline_info]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{
          open_close: "timeline_info",
          options: [
            { key: "date", value: "Feb 2013" },
            { key: "title", value: "Something amazing" }
          ]
        }])
      end

    end

    context "timeline_person" do

      let(:parsed_object) { parser.parse(timeline_person) }

      before do
        configuration.block_tags = [:timeline_person]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{
          open: "timeline_person",
          options: [
            { key: "date", value: "Jan 2012" },
            { key: "title", value: "A real title" },
            { key: "image", value: "/images/person.jpg" },
            { key: "name", value: "Sam Smith" },
            { key: "position", value: "Presedent" },
            { key: "link", value: "http://blah.com" }
          ],
          inner: [{ text: "A bit of body copy\nwith a newline\n" }],
          close: "timeline_person"
        }])
      end

    end

    context "complex_snippet" do

      let(:parsed_object) { parser.parse(complex_snippet) }

      before do
        configuration.block_tags = [:quote, :collapsible_list, :item]
      end

      it "created the expected object" do
        expect(parsed_object[:body]).to eq([{
          text: "<h3>A page title</h3>\n<p>Some text</p>\n"},
          {
            open: "collapsible_list",
            options: [],
            inner:     [{
              open: "item",
              options: [{ key: "title", value: "Example title 1" }],
              inner: [{
                open: "quote",
                options: [
                  { key: "author", value: "Jamie Dyer" },
                  { key: "title", value: "King of England" }
                ],
                inner: [{ text: "A quote" }],
                close: "quote"
              },
              { text: "I'm inbetween 2 quotes!\n    " },
              {
                open: "quote",
                options: [
                  { key: "author", value: "Forrest Gump" },
                  { key: "title", value: "Idiot" }
                ],
                inner: [{text: "Life is like..."}],
                close: "quote"
              }],
            close: "item"
            },
            {
              open: "item",
              options: [{ key: "title", value: "Example title 2" }],
              inner: [{ text: "Example content 2" }],
              close: "item"
            },
            {
              open: "item",
              options: [{ key: "title", value: "Example title 3" }],
              inner: [{ text: "Example content 3" }],
              close: "item"
            }],
            close: "collapsible_list"
          },
          { text: "\n<p>Some more text</p>\n" }
        ])
      end
    end
  end
end
