require_relative './item.rb'

class GildedRose
  @items = []

  def update_quality(items)
    @items = items.map do |item|
      ItemUpdater.new(item).update
    end
  end
end

class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    updater = item_updaters[item.name] || NormalItem
    updater.new(item).age
  end

  def item_updaters
    {
      'Sulfuras, Hand of Ragnaros' => Sulfuras,
      'Backstage passes to a TAFKAL80ETC concert' => BackstagePass,
      'Aged Brie' => AgedBrie,
      'Conjured Mana Cake' => ConjuredItem
    }
  end

  class NormalItem
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def age
      item.tap do |i|
        i.quality = item_quality
        i.sell_in = item.sell_in - 1
      end
    end

    def item_quality
      [0, [50, new_quality].min].max
    end

    def new_quality
      item.quality + change_in_quality
    end

    def change_in_quality
      item.sell_in <= 0 ? -2 : -1
    end
  end

  class Sulfuras < NormalItem
    def age
      item
    end
  end

  class AgedBrie < NormalItem
    def change_in_quality
      item.sell_in <= 0 ? 2 : 1
    end
  end

  class BackstagePass < NormalItem
    def change_in_quality
      if item.sell_in <= 0
        item.quality * -1
      elsif (1..5).include? item.sell_in
        3
      elsif (6..10).include? item.sell_in
        2
      else
        1
      end
    end
  end

  class ConjuredItem < NormalItem
    def change_in_quality
      if item.sell_in <= 0
        -4
      else
        -2
      end
    end
  end
end
