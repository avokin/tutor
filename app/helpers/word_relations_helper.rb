module WordRelationsHelper
  def get_relation_name(relation)
    if relation.relation_type == 1
      "translation"
    else
      "synonym"
    end
  end
end
