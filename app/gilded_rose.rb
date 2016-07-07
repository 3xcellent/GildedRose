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
      self.aged_brie(item)
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

  def self.aged_brie(item)
    if item.quality < 50
      item.quality = item.quality + 1
    end
    item.sell_in = item.sell_in - 1
    item.quality = item.quality + 1 if item.quality < 50 if item.sell_in < 0
  end

  class NormalItem
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def age
      if item.quality > 0
        item.quality = item.quality - 1
      end

      item.sell_in = item.sell_in - 1

      if item.sell_in < 0
        if item.quality > 0
          item.quality = item.quality - 1
        end
      end

      item
    end
  end

end

