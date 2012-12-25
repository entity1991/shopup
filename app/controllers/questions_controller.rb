class QuestionsController < ApplicationController

  def create
    @question = current_user.questions.new params[:question]
    if @question.save
      #MainMailer.help(params[:question], current_user).deliver
      flash[:success] = "Thanks You!"
      redirect_to :back
    else
      #todo make validation message
      redirect_to :back
    end
  end
end