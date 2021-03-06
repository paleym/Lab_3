class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  	# Creating the ratings field for use in check boxes and collection
	  @all_ratings = ['G','PG', 'PG-13', 'R']
	  # Initializing whether to pull from session, assuming new params passed in
	  @do_redirect = false

    # Get the sort column, grabs from params by default, and from session if the
    # params does not have a :sort defined, and if neither are defined, redirect
    if params.include?(:sort) then
      sort = params[:sort]
    else
      sort = session[:sort]
      unless sort == nil
        @do_redirect = true
      end
    end
    
    # Saving sort choice to session
    session[:sort] = sort

    # Get the ratings checkboxes, if they are included in params, use them, if not
    # grab from session, unless session does not have them defined, then redirect
    if params.include?(:ratings) then
      rating_filter = params[:ratings]
    else
      rating_filter = session[:ratings]
      unless rating_filter == nil
        @do_redirect = true
      end
		end

    # Saving ratings choice to session
    session[:ratings] = rating_filter

    # Redirect if the sort or filter parameters were missing
    if @do_redirect then
      redirect_to session
    end
    
    unless rating_filter == nil then
      rating_filter = rating_filter.keys
    end

    if sort == nil and rating_filter == nil then
      @movies = Movie.all
    elsif rating_filter == nil
      @movies = Movie.order sort
    elsif sort == nil
      @movies = Movie.where({:rating => rating_filter})
    else
      @movies = Movie.where({:rating => rating_filter}).order(sort)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
	  params[:movie][:title].capitalize!
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
