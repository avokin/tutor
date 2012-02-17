class TriesController < ApplicationController
  WORD_COUNT = 20

  before_filter :authenticate

  def index
    @title = "learn and repetition"

    @targets = [:translations, :synonyms]
    @modes = [:learning, :repetition]
    @categories = UserCategory.find_all_by_user_id(current_user.id)
    @select = [:all, :random, :recent]
  end

  def show
    @title = "try"
    @word_relation = WordRelation.find params[:id]
  end

  def prepare_relations
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

    WordRelation.find_all_by_user_id_relation_type_status_id(current_user, type, status_id, cookies.signed[:category])
  end

  def prepare_random_relations
    ar_relations = prepare_relations
    relations = []
    ar_relations.each do |relation|
      relations << relation
    end

    result = []
    if relations.length > WORD_COUNT
      (0..WORD_COUNT - 1).each do |i|
        k = rand(relations.length - 1)
        result << relations[k].id
        relations.delete(relations[k])
      end
    else
      relations.each do |relation|
        result << relation.id
      end
    end
    result
  end

  def start
    cookies.permanent.signed[:mode] = params[:tries][:mode]
    cookies.permanent.signed[:targeting] = params[:tries][:targeting]
    cookies.permanent.signed[:category] = params[:tries][:category]
    cookies.permanent.signed[:select] = params[:tries][:select]

    if params[:tries][:select] == "random"
      relations = prepare_random_relations
      cookies.permanent.signed[:random] = relations
    end
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
    if cookies.signed[:select] == "random"
      relations = cookies.signed[:random]

      count = relations.length
      if count == 0
        nil
      elsif count == 1
        WordRelation.find(relations[0])
      else
        pos = rand(count - 1)
        WordRelation.find(relations[pos])
      end
    else
      relations = prepare_relations
       count = relations.length
       if count == 0
         nil
       elsif count == 1
         relations[0]
       else
         pos = rand(count - 1)
         relations[pos]
       end
    end
   end
end