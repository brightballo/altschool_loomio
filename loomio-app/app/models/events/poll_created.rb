class Events::PollCreated < Event
  include Events::LiveUpdate
  include Events::Notify::Mentions
  include Events::Notify::Chatbots

  def self.publish!(poll, actor)
    super poll,
          user: actor,
          discussion: poll.discussion,
          pinned: true
  end
end
