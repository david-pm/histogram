# frozen_string_literal: false

class Histogram::Chart
  attr_reader :histogram

  def initialize(list)
    @list        = sort(list)
    @min_size    = @list.uniq.min_by(&:length).size
    @histogram   = histogramize
    @max_count   = histogram.values.max
    @chart_array = Array.new
    @padding     = ' '
  end

  def to_chart
    make_blocks.tap do |depth, blocks|
      depth.times { @chart_array << build_row(blocks) }
    end
    puts @chart_array.map(&:join)
  end

  private

  def sort(list)
    list.compact
        .group_by { |str| str }
        .values
        .sort_by(&:length)
        .reverse
        .flatten
  end

  def histogramize
    @list.each_with_object(Hash.new(0)) { |item, obj| obj[item] += 1 }
  end

  def build_row(blks)
    blks.map { |blk| blk.shift }
  end

  def make_blocks
    histo_blocks = histogram.map { |name, count| make_block(name, count) }
    add_margins(histo_blocks)
    [histo_blocks.last.count, histo_blocks]
  end

  def make_block(name, num)
    pad = difference(name)

    Array.new.tap do |blocks|
      blocks << @max_count - num
      blocks << top_bottom_bar(pad)
      num.times { blocks << sidebars(pad) }
      blocks << top_bottom_bar(pad)
      blocks << name_spot(name, pad)
      blocks << number_spot(num, pad)
    end
  end

  def difference(name)
    (name.size - @min_size).tap do |res|
      raise 'fuck, this cannot be negative' if res.negative?
    end
  end

  def add_margins(histo_blocks)
    histo_blocks.each { |blk| blk.shift.times { blk.unshift '      ' } }
  end

  def name_spot(name, pad)
    " #{name}  "
  end

  def number_spot(num, pad)
    "  #{num}   " <<  calculate_padding(pad)
  end

  def sidebars(pad)
    '|   | ' << calculate_padding(pad)
  end

  def top_bottom_bar(pad)
    ' ___  ' << calculate_padding(pad)
  end

  def calculate_padding(pad)
    @padding * pad
  end
end
