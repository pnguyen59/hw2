class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    redi = false
    if params[:ratings]!=nil
       @ratingKey = params[:ratings]
       if @ratingKey.is_a?(Hash)
        @ratingKey = @ratingKey.keys
       end
      session[:ratingKey] = @ratingKey
       @movies = Movie.where({rating: @ratingKey})

    elsif session[:ratingKey]!= nil
      @ratingKey = session[:ratingKey]
      @movies = Movie.where({rating: @ratingKey})
      redi =true
    else
        @movies = Movie.all
      @ratingKey=Movie.getRatings
    end
    
    @all_ratings= Movie.getRatings
    @movies = @movies.order(params[:sort_by])
    @sort_t =params[:sort_by]
  
    if @sort_t != nil
      if @sort_t == 'title'
      @title_header = 'hilite'
      session[:sort_t] = 'title'
      else
        @release_header ='hilite'
        session[:sort_t] = 'release_date'
      end
    elsif session[:sort_t]!= nil
      if session[:sort_t] == 'title'
        @sort_t =session[:sort_t]
        @title_header = 'hilite'
        redi =true
      else
         @sort_t =session[:sort_t]
      @release_header ='hilite'
      redi = true
      end 
    end
    
    if redi == true
      session.clear
      flash.keep
      redirect_to movies_path(sort_by: @sort_t, ratings: @ratingKey )
    end
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

end
