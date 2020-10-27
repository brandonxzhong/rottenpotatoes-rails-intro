class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # pull and assign selected ratings from params 
    ratings = params[:ratings]
    
    # check if :home == 1
    home_check = params[:home]
    if home_check == "1"
      home = true
    end 
    
    # check if session exists
    live = session[:live]
    
    # if session exists and we did not come from home, we need to repull sorting and ratings 
    if live and !home 
      ratings = session[:ratings]
      @sorted = session[:sorted]
    else 
      # else session doesn't exist or we came from home, pull values as usual
      @sorted = params[:sorted]
    end 
    
    # instantiate session and finalized values
    session[:live] = true
    session[:ratings] = ratings
    session[:sorted] = @sorted 
    
    # pull the relevant ratings
    if ratings.nil?
      @ratings_to_show = [] 
    else
      keys = ratings.keys
      @ratings_to_show = keys 
    end 
    
    #assign {hilite} and {text-primary} (helper) to @title_sorted and @release_sorted 
    
    # handle sorting and output
    if @sorted == "title"
      @movies = Movie.order(:title).with_ratings(@ratings_to_show)
      @title_sorted = "hilite text-primary"
    elsif @sorted == "release"
      @movies = Movie.order(:release_date).with_ratings(@ratings_to_show)
      @release_sorted = "hilite text-primary"
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end 
    
    # select all ratings
    @all_ratings = Movie.all_ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
