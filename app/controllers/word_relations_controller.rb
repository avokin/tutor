class WordRelationsController < ApplicationController
  def create
    word_id = params[:word_relation][:word_id]
    translated_text = params[:word_relation][:related_word]
    relation_type = params[:word_relation][:relation_type]

    relation = WordRelation.create_relation(word_id, translated_text, relation_type)
    if (relation.nil?)
      render 'pages/message'
    else
      if (relation.save)
        redirect_to relation.source_word
      else
        render 'pages/message'
      end
    end
  end

  def destroy
    t = WordRelation.find(params[:id])
    t.destroy
    redirect_to t.source_word
  end
end