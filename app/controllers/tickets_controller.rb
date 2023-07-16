# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: %i[show edit update destroy watch]
  before_action :authenticate_user!

  def new
    @ticket = @project.tickets.build
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.author = current_user

    @ticket.tags = processed_tags

    # ticket creator is automatically subscribed as a watcher
    if @ticket.save
      @ticket.watchers << current_user unless @ticket.watchers.exists?(current_user.id)

      flash[:notice] = 'Ticket has been created.'
      redirect_to [@project, @ticket]
    else
      flash.now[:alert] = 'Ticket has not been created.'
      render 'new'
    end
  end

  def show
    @comment = @ticket.comments.build(state: @ticket.state)
    @states = State.all
  end

  def edit; end

  def update
    unless @ticket.author == current_user || @current_user.admin?
      flash[:alert] = 'Only ticket authors or admins can edit tickets'
      redirect_to [@project, @ticket]
      return
    end

    if @ticket.update(ticket_params)
      @ticket.tags << processed_tags
      flash[:notice] = 'Ticket has been updated.'
      redirect_to [@project, @ticket]
    else
      flash.now[:alert] = 'Ticket has not been updated.'
      render 'edit'
    end
  end
  

  def destroy
    return unless @ticket.delete

    flash[:notice] = 'Ticket has been deleted.'
    redirect_to @project
  end

  def watch
    if @ticket.watchers.exists?(current_user.id)
      @ticket.watchers.destroy(current_user)
      flash[:notice] = 'You are no longer watching this ticket.'
    else
      @ticket.watchers << current_user
      flash[:notice] = 'You are now watching this ticket.'
    end

    redirect_to project_ticket_path(@ticket.project, @ticket)
  end

  def search
    @tickets = @project.tickets

    if params[:search].present?
      search_query = params[:search]

      fetch_tickets_for_a_tag if search_query.include?('tag')

      fetch_tickets_for_a_state if search_query.include?('state')
    else
      @tickets
    end
    render 'projects/show'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def processed_tags
    params[:tag_names].split(',').map do |tag|
      Tag.find_or_initialize_by(name: tag.strip.titleize)
    end
  end

  def process_search_term(search_term)
    params[:search].split(search_term)[1].split(' ')[0].strip.titleize
  rescue NoMethodError
    puts 'Invalid search'
  end

  def fetch_tickets_for_a_tag
    search_term = process_search_term('tag: ')
    tag = Tag.search_tag(search_term)
    if tag.nil?
      @tickets
    else
      @tickets = tag.tickets.belonging_to_project(@project.id)
    end
  end

  def fetch_tickets_for_a_state
    search_term = process_search_term('state: ')
    state = State.where('name LIKE ?', "%#{search_term}%").first
    if state.nil?
      @tickets
    else
      @tickets = @tickets.filter_map { |ticket| ticket if ticket.state_id == state.id }
    end
  end

  def ticket_params
    params.require(:ticket).permit(:name, :description, :attachment)
  end
end
