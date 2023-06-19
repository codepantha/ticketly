# frozen_string_literal: true

module ApplicationHelper
  def title(*parts)
    return if parts.empty?

    content_for :title do
      (parts << 'Ticketly').join(' - ')
    end
  end

  def admins_only(&block)
    block.call if current_user.try(:admin?)
  end
end
