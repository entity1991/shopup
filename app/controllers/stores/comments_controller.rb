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
    puts @comment.deleted?
    @comment.deleted = true
    if @comment.save
      render :text => "<p>Comment was deleted.</p>"
    end
  end

  private

  def owner_or_author?
    redirect_to nil if !((@store.owner == current_user)||(@comment.user == current_user))
  end

end
