class Stores::CommentsController < Stores::ApplicationController

  before_filter :owner_or_author?, :only => :destroy

  def create
    puts "here -------------------------"
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      render :partial => 'stores/comments/comment', :locals => {:comment => @comment}
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.content = "Comment was deleted."
    if @comment.save
      render :text => "Ok"
    end
  end

  private

  def owner_or_author?
    redirect_to nil if !((@store.owner == current_user)||(@comment.user == current_user))
  end

end
