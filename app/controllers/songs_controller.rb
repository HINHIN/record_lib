class SongsController < ApplicationController
  add_breadcrumb "Songs List", :controller => "songs", :action => "list"

  def seachalbom
    @alboms = Albom.includes(:artists).where("name LIKE ?", params[:albom_name]+'%')
    
  end
  def new
    add_breadcrumb "New Song", :controller => "songs", :action => "new"
    @new_song = GetFormDataFromPost()
    
    @Song = Song.new()
    @Page_Title = "New Song"
  end

  def show
    @song = Song.find(params[:id])
    if (@song.is_remix)
      @source_remix = @song.source_remix.includes([:albom,:artists]).all
    else
      @source_remix = []
    end
    if (@song.is_mesh_up)
      @source_mesh_up = @song.source_mesh_up.includes([:albom,:artists]).all
    else
      @source_mesh_up = []
    end
    @remixes = @song.remixes.includes([:albom,:artists]).all
    @meshs = @song.meshs.includes([:albom,:artists]).all
    @artists = @song.artists.all
    if (!@song.albom_id.nil?)
      @albom = @song.albom
      if(@artists.length == 1 && @albom.compilation == false)
        add_breadcrumb "Artist: #{@artists[0].name}", :controller => "artists", :action => "show", :id => @artists[0].id
        add_breadcrumb "Albom: #{@albom.name}", :controller => "alboms", :action => "show", :id => @albom.id
      else
        add_breadcrumb "Albom: #{@albom.name}", :controller => "alboms", :action => "show", :id => @albom.id
      end
    elsif(@artists.length == 1)
      add_breadcrumb "Artist: #{@artists[0].name}", :controller => "artists", :action => "show", :id => @artists[0].id
    end
    add_breadcrumb "Song: #{@song.name}", :controller => "songs", :action => "show", :id => @song.id
    @Page_Title = "Song: #{@song.name}"
  end

  def list
    @Page_Title = 'Songs List'
    @songs = Song.includes([:albom,:artists]).all
  end
  def delete
  end
  private
    def GetFormDataFromPost()
      new_song = params[:new_song]
      if(new_song.nil?)
        return {:name=>'',:artists=>'',:time=>'',:albom=>'',:is_remix=>false,:is_mesh_up=>false}
      end
      if (new_song[:is_remix]=='1')
        new_song[:is_remix] = true
      else
        new_song[:is_remix] = false
      end
      if (new_song[:is_mesh_up]=='1')
        new_song[:is_mesh_up] = true
      else
        new_song[:is_mesh_up] = false
      end
      return new_song
    end
end
