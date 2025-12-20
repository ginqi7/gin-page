#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'yaml'
require 'mechanize'

class WebScraper
  COMMANDS = {
    'url' => ->(page, element) {
      href = element['href']
      encoded_href = URI::DEFAULT_PARSER.escape(href)
      page.uri.merge(encoded_href).to_s
    },
    'text' => ->(_page, element) { element.text.strip },
  }.freeze

  DEFAULT_CONFIG_PATH = './_data/metadata.json'

  def initialize(config_path = DEFAULT_CONFIG_PATH)
    @config = load_config(config_path)
    @agent = create_agent
  end

  def run
    # Dir.glob('./_data/sections/*').each { |f| File.delete(f) if File.file?(f) }
    hash = {}
    results = @config['sections'].filter_map do |section|
      data = fetch(section)
      hash[section['name']] = data if data
    end
    print(results)
    print_results(hash)
    hash.each do |key, value|
      File.delete("./_data/sections/#{key}.json") if File.file?("./_data/sections/#{key}.json")
      File.write("./_data/sections/#{key}.json", JSON.pretty_generate(value))
    end
  end

  private

  def load_config(path)
    JSON.parse(File.read(path))
  rescue Errno::ENOENT
    abort "Error: Configuration file '#{path}' not found."
  rescue JSON::ParserError
    abort "Error: The configuration file '#{path}' is not valid JSON."
  end

  def create_agent
    Mechanize.new.tap do |agent|
      agent.user_agent_alias = 'Linux Firefox'
      agent.open_timeout = 10
      agent.read_timeout = 10
    end
  end

  def fetch(section)
    url = section['url']
    return nil unless url

    puts "Fetch [#{url}]"
    page = @agent.get(url)
    limit = section['limit'] || 5
    elements = extract_matches(page, section['match']).first(limit)
    elements.map do |element|
      extract_properties(page, element, section['properties'])
    end
  rescue StandardError => e
    puts "Warning occurred while retrieving '#{section['name']}': #{e.message}"
    nil
  end

  def extract_matches(page, match)
    return nil unless match

    page.search(match)
  end

  def extract_properties(page, element, properties)
    return nil unless properties

    properties.transform_values do |selector_info|
      query(page, element, selector_info)
    end
  end

  def query(page, element, selector_info)
    selector, command_name = selector_info
    command = COMMANDS[command_name]
    target = element.at(selector)
    return '' unless command && target

    command.call(page, target)
  end

  def print_results(results)
    puts "\n --- Scraping Results ---"
    puts results.to_yaml
  end
end

# --- Script Entry Point ---
if __FILE__ == $PROGRAM_NAME
  config_path = ARGV[0] || WebScraper::DEFAULT_CONFIG_PATH
  scraper = WebScraper.new(config_path)
  scraper.run
end
