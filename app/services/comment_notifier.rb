class CommentNotifier
  attr_reader :comment, :watchers

  def initialize(comment)
    @comment = comment
    @watchers = comment.ticket.watchers.excluding(comment.author)
  end

  def notify_watchers
    watchers.each do |user|
      CommentMailer
        .with(comment: comment, user: user)
        .new_comment
        .deliver_later
    end
  end
end
