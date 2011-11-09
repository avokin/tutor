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
    skipped = params[:skipped]
    if skipped != "1"
      result = @relation.check(answer)
      case result
        when :right_answer
          flash[:error] = 'Success'
          @relation = select_relation_to_learn
        when :wrong_answer
          flash[:error] = 'Wrong answer'
        when :another_word
          flash[:error] = "Another one"
      end
    else
      @relation = select_relation_to_learn
    end

    redirect_to try_path @relation
  end

  def select_relation_to_learn
    if cookies.signed[:targeting] == "translations"
      type = 1
    else
      type = 2
    end

    if cookies.signed[:mode] == "learning"
      status_id = 1
    else
      status_id = 2
    end
    relations = WordRelation.find_all_by_user_id_relation_type_status_id(current_user, type, status_id)
    count = relations.length
    if count == 0
      nil
    elsif count == 1
      return relations[0]
    else
      pos = rand(count - 1)
      relations[pos]
    end
  end
end