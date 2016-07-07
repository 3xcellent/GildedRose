require_relative './item.rb'

class GildedRose
  @items = []

  def update_quality(items)
    @items = items.map do |item|
      ItemUpdater.update(item)
    end
  end
end

class ItemUpdater
  def self.update(item)
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      item
    when 'Backstage passes to a TAFKAL80ETC concert'
      self.backstage_pass(item)
    when 'Aged Brie'
      AgedBrie.new(item).age
    else
      NormalItem.new(item).age
    end
  end

  def self.backstage_pass(item)
    if item.quality < 50
      item.quality = item.quality + 1
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if item.sell_in < 11
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
        if item.sell_in < 6
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end

    item.sell_in = item.sell_in - 1
    item.quality = item.quality - item.quality if item.sell_in < 0

    item
  end

  class NormalItem
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def age
      item.tap do |i|
        i.sell_in = item.sell_in - 1
        i.quality = item_quality
      end
    end

    def item_quality
      [0, [50, new_quality].min].max
    end

    def new_quality
      item.quality + (item.sell_in < 0 ? -2 : -1)
    end
  end

  class AgedBrie < NormalItem
    def new_quality
      item.quality + (item.sell_in < 0 ? 2 : 1)
    end
  end
end

