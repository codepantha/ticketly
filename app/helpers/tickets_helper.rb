# frozen_string_literal: true

module TicketsHelper
  def toggle_watching_button(ticket)
    text = if ticket.watchers.include?(current_user)
             'Unwatch'
           else
             'Watch'
           end
    link_to text, watch_project_ticket_path(ticket.project, ticket),
            class: text.parameterize, method: :patch
  end

  def authors_or_admins_only(ticket, &block)
    return unless current_user == ticket.author || current_user.admin?

    block.call
  end
end
