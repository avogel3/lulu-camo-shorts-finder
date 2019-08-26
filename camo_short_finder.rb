require 'faraday'
require 'json'

class CamoShortFinder
  def find_camo_shorts
    report
    camo_shorts
  end

  private
  def camo_shorts
    @camo_shorts ||= short_styles.select { |s| s["color-name"].downcase.include?('camo') }
  end

  def report
    puts "Total number of short styles - #{short_styles.count}"
    puts "-----------------------------------------------------------"
    puts "Total number of *CAMO* short styles - #{camo_shorts.count}"
    puts "-----------------------------------------------------------"
    puts "CAMO short styles -"
    camo_shorts.map { |style| puts "\t • #{style['name']}" }
    puts "-----------------------------------------------------------"
    puts camo_shorts
  end

  def short_styles
    @short_styles ||= product_records.map do |short_style|
      short_style["sku-style-order"].map do |color|
        color.merge({ "name" => "#{short_style["display-name"]} - #{color["color-name"]}" })
      end
    end.flatten
  end

  def product_records
    @product_records ||= body["data"]["attributes"]["main-content"][0]["records"]
  end

  def body
    @body ||= JSON.parse(api_response.body)
  end

  def api_response
    @api_response ||= Faraday
      .new(url: 'https://shop.lululemon.com')
      .get('/api/search/?Ntt=pace%2Bbreaker&page=1')
  end
end

CamoShortFinder.new.find_camo_shorts
