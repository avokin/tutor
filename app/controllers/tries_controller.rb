class TriesController < ApplicationController
  before_filter :authenticate

  def index
    @title = "learn and repetition"

    @targets = [:translations, :synonyms]
    @modes = [:learning, :repetition]
  end

  def show
    @title = "try"
    @word_relation = WordRelation.find params[:id]
  end

  def start
    cookies.permanent.signed[:mode] = params[:tries][:mode]
    cookies.permanent.signed[:targeting] = params[:tries][:targeting]

    relation = select_relation_to_learn
    if (relation.nil?)
      render 'pages/message'
    else
      redirect_to try_path(relation)
    end
  end

  def check
    @relation = WordRelation.find params[:id]
    answer = params[:answer]
    if answer == @relation.related_user_word.word.text
      @relation.success_count += 1
      @relation.save!
      @relation = select_relation_to_learn
    else
      @relation.success_count = 0
      @relation.status_id = 1
      @relation.save!
    end

    redirect_to try_path @relation
  end

  def select_relation_to_learn
    if cookies.signed[:targeting] == "translations"
      type = 1
    else
      type = 2
    end
    count = WordRelation.count(:conditions => "user_id = #{current_user.id} and relation_type = #{type}")
    if count == 0
      nil
    elsif count == 1
      return WordRelation.find_by_relation_type type
    else
      pos = rand(count - 1)
      WordRelation.find_all_by_relation_type type, :offset => pos, :limit => 1
    end
  end
end