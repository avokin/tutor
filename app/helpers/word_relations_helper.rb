module WordRelationsHelper
  def get_relation_name(relation, number)
    number += 1
    if relation.relation_type == 1
      "translation_#{number}"
    else
      "synonym_#{number}"
    end
  end
end
