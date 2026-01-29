class ResponseSerializer
  def initialize(item_or_items, serializer:)
    @item_or_items = item_or_items
    @serializer = serializer
  end

  def as_json(*)
    if @item_or_items.respond_to?(:each)
      { data: @item_or_items.map { |item| @serializer.new(item).as_json } }
    else
      { data: @serializer.new(@item_or_items).as_json }
    end
  end
end
