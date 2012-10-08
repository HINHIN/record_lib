class SongsController < ApplicationController
  include ApplicationHelper
  add_breadcrumb "Songs List", :controller => "songs", :action => "list"
  def seachsongmesup
    if(params[:fined_songs].presence) 
      @songs = Song.includes([:albom,:artists]).where("name LIKE ? AND id NOT IN (?)", params[:song_name].gsub(/[\\%_\x0]/, '\\\x0')+'%',params[:fined_songs]).all()
    else
      @songs = Song.includes([:albom,:artists]).where("name LIKE ?", params[:song_name].gsub(/[\\%_\x0]/, '\\\x0')+'%').all()
    end
  end
  def seachsongremix
    if(params[:fined_songs].presence) 
      @songs = Song.includes([:albom,:artists]).where("name LIKE ? AND id NOT IN (?)", params[:song_name].gsub(/[\\%_\x0]/, '\\\x0')+'%',params[:fined_songs]).all()
    else
      @songs = Song.includes([:albom,:artists]).where("name LIKE ?", params[:song_name].gsub(/[\\%_\x0]/, '\\\x0')+'%').all()
    end
  end
  def seachalbom
    @alboms = Albom.includes(:artists).where("name LIKE ?", params[:albom_name].gsub(/[\\%_\x0]/, '\\\x0')+'%').all()
  end
  def seachartist
    if(params[:fined_artists].presence) 
      @artists = Artist.where("name LIKE ? AND name NOT IN (?)", params[:artist_name].gsub(/[\\%_\x0]/, '\\\x0')+'%',params[:fined_artists]).all()
    else
      @artists = Artist.where("name LIKE ?", params[:artist_name].gsub(/[\\%_\x0]/, '\\\x0')+'%').all()
    end
  end
  def new
    add_breadcrumb "New Song", :controller => "songs", :action => "new"
    @new_song = GetFormDataFromPost()
    if(!params[:new_song].nil?)
      if(params[:commit]=='Add')
        @song = GetModelResult(@new_song)
        if(@song.valid?)
          @albom = GetAlbomModelResult(@new_song)
          if(@albom.valid?)
            @artists = GetArtistModelResult(@new_song)
            @artists.each do |artist|
              if(!artist.valid?)
                @error_obj='artist'
                @error_message = artist.errors
              end
            end
          else
            @error_message = @albom.errors
            @error_obj = 'albom'
          end
        else
          @error_obj = 'song'
          @error_message = @song.errors
        end
        if(@error_obj.nil?)
          @artists.each do |artist|
            if(artist.new_record?)
              artist.save
            end
          end
          @song.artists = @artists
          if(@albom.new_record?)
            @albom.artists = @artists
            @albom.save
          end
          
          @song.albom = @albom
          @song.save
          if(@song.is_mesh_up&&!@new_song[:mesh_ups].empty?)
            @mesh_ups_ids = []
            @new_song[:mesh_ups].split(',').each do |mesh_ups|
              @mesh_ups_ids.push(mesh_ups.to_i(10))
            end
            @mesh_ups = Song.where(:id=>@mesh_ups_ids).all()
          else
            @mesh_ups = []
          end
          @song.source_mesh_up = @mesh_ups
          if(@song.is_remix&&!@new_song[:remixes].empty?)
            @remix_ids = []
            @new_song[:remixes].split(',').each do |remix_id|
              @remix_ids.push(remix_id.to_i(10))
            end
            @remix = Song.where(:id=>@remix_ids).all()
          else
            @remix = []
          end
          @song.source_remix = @remix
          redirect_to  :controller => "songs", :action => "show", :id => @song.id
        end
      end
    end
    if(@new_song[:remixes].empty?)
      @remix = []
    else
      @remix_ids = []
      @new_song[:remixes].split(',').each do |remix_id|
        @remix_ids.push(remix_id.to_i(10))
      end
      @remix = Song.includes([:albom,:artists]).where(:id=>@remix_ids).all()
      @remix_ids = []
      @remix.each do |song|
        @remix_ids.push(song.id)
      end
      @new_song[:remixes] = @remix_ids.join(',')
    end
    if(@new_song[:mesh_ups].empty?)
      @mesh_ups = []
    else
      @mesh_ups_ids = []
      @new_song[:mesh_ups].split(',').each do |mesh_ups|
        @mesh_ups_ids.push(mesh_ups.to_i(10))
      end
      @mesh_ups = Song.includes([:albom,:artists]).where(:id=>@mesh_ups_ids).all()
      @mesh_ups_ids = []
      @mesh_ups.each do |song|
        @mesh_ups_ids.push(song.id)
      end
      @new_song[:mesh_ups] = @mesh_ups_ids.join(',')
    end
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
    @songs = Song.includes([:albom,:artists]).paginate(:page => params[:page]).all
  end
  def delete
    Song.find(params[:id]).destroy;
  end
  private
    def GetArtistModelResult(new_song)t
      artists =[]
      new_song[:artists].split(',').each do |artist_name|
        if(artist_name.strip!='')
          artist = Artist.find_by_name(artist_name.strip)
          if(artist.nil?)
            artist = Artist.new(:name => artist_name.strip)
          end
          artists.push(artist)
        end
      end
      return artists 
    end
    def GetAlbomModelResult(new_song)
      if(new_song[:albom_id].to_i(10)>0)
        result = Albom.find(new_song[:albom_id]);
        if(!result.nil?)
          if(result.name == new_song[:albom])
            return result
          end
        end
      end
      if(new_song[:albom].empty?)
        result = Albom.new({:name=>"#{new_song[:name]} (single)",:compilation=>false})
      else
        result = Albom.new({:name=>new_song[:albom],:compilation=>false})
      end
      return result
    end
    def GetModelResult(new_song)
      if(!params[:id].nil?)
        result = Song.find(params[:id]);
        if(!result.nil?)
          result[:name] =new_song[:name]
          result[:is_mesh_up] =new_song[:is_mesh_up]
          result[:is_remix] =new_song[:is_remix]
          
          scan_result = new_song[:time].scan(/([0-9]+):([0-5][0-9])/)
          if(scan_result.size!=1)
            result[:time] = 0
          else
            result[:time] = scan_result[0][0].to_i(10)*60 + scan_result[0][1].to_i(10)
          end
          return result
        end
      end
      result = {:name=>new_song[:name],:is_mesh_up=>new_song[:is_mesh_up],:is_remix=>new_song[:is_remix]}
      scan_result = new_song[:time].scan(/([0-9]+):([0-5][0-9])/)
      if(scan_result.size!=1)
        result[:time] = 0
      else
        result[:time] = scan_result[0][0].to_i(10)*60 + scan_result[0][1].to_i(10)
      end
      return Song.new(result)
    end
    def GetFormDataFromPost()
      new_song = params[:new_song]
      if(new_song.nil?)
        if(params[:id].nil?)
          return {:id=>nil,:name=>'',:artists=>'',:time=>'0:00',:albom=>'',:albom_id=>'',:is_remix=>false,:is_mesh_up=>false,:remixes=>'',:mesh_ups=>''}
        else
          result = Song.find(params[:id]);
          artists_all = result.artists.all
          artists = ''
          artists_all.each do |artist|
            artists = artists + artist.name + ', '
          end
          if(result.albom.nil?)
            albom_name = ''
          else
            albom_name = result.albom.name
          end
          return {:id=>params[:id],:name=>result.name,:artists=>artists,:time=> GetTimeFormat(result.time) ,:albom=>albom_name,:albom_id=>result.albom_id,:is_remix=>result.is_remix,:is_mesh_up=>result.is_mesh_up,:remixes=>result.remix_rev.all.join(','),:mesh_ups=>result.mesh_up_rev.all.join(',')}
        end
      end
      if (new_song[:is_remix]=='1')
        new_song[:is_remix] = true
        if(new_song[:remixes].nil?)
          new_song[:remixes] = ''
        end
      else
        new_song[:is_remix] = false
        new_song[:remixes] = ''
      end
      if (new_song[:is_mesh_up]=='1')
        new_song[:is_mesh_up] = true
        if(new_song[:mesh_ups].nil?)
          new_song[:mesh_ups] = ''
        end
      else
        new_song[:is_mesh_up] = false
        new_song[:mesh_ups] = ''
      end
      return new_song
    end
end
