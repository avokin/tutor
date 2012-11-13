module WordRelationsHelper
  def get_relation_name(relation)
    if relation.relation_type == 1
      "translation"
    else
      "synonym"
    end
  end

  def get_number
    @item_index += 1
    @prefix + @item_index.to_s
  end

  def selected
    @item_index == 1
  end
end
