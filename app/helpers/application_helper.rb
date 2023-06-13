# frozen_string_literal: true

module ApplicationHelper
  def title(*parts)
    return if parts.empty?

    content_for :title do
      (parts << 'Ticketly').join(' - ')
    end
  end
end
