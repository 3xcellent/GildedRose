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
    return item if item.name == 'Sulfuras, Hand of Ragnaros'
    return self.backstage_pass(item) if item.name == 'Backstage passes to a TAFKAL80ETC concert'

    if item.name != 'Aged Brie'
      if item.quality > 0
        item.quality = item.quality - 1
      end
    else
      if item.quality < 50
        item.quality = item.quality + 1
      end
    end

    item.sell_in = item.sell_in - 1

    if item.sell_in < 0
      if item.name != 'Aged Brie'
        if item.quality > 0
          item.quality = item.quality - 1
        end
      else
        item.quality = item.quality + 1 if item.quality < 50
      end
    end

    item
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
end

