class MatchesController < ApplicationController
  before_filter :authorize
  
  # GET /match/1
  def show    
  end

  # GET /match/ 
  def index
    # shows active matches
    @matches = current_player.matches.active
  end

  # match/:id/status?move=N returns javascript to update the board to move N. 
  # If no moves have been made and you query status for move 1 - it will not return
  # javascript to update the board, and will 304 after the first request. Once that
  # move has been made, though, future requests will return JS to update the board
  # and the URL that the client polls for.
  def status 
  end

  # provides the js of previous boards
  def boards

  end

  # GET /match/new
  def new
  end

  def resign
    @match = Match.find( params[:id] )
    @match.resign( current_player )
    redirect_to :action => 'index'
  end

  # POST /match/create
  def create
    return unless request.post?

    if params[:match]
      @opponent = Player.find_by_name( params[:match][:opponent_name] )
    elsif params[:opponent_id] # some tests use this format
      @opponent = Player.find(params[:opponent_id])
    end

    flash[:error] = "Player not found ! (#{params.inspect})" and return unless @opponent

    if params[:opponent_side] == 'black'
      attrs = {:white => current_player, :black => @opponent }
    else
      attrs = {:black => current_player, :white => @opponent }
    end
    start_pos = params[:start_pos]
    
    attrs[:start_pos] = start_pos if start_pos and Fen::is_fen?( start_pos )
    @match = Match.create( attrs )
    
    if start_pos && PGN::is_pgn?( start_pos )
      pgn = PGN.new( start_pos )
      pgn.playback_against( @match )
      logger.warn "Error #{pgn.playback_errors.to_a.inspect} in PGN playback of #{start_pos}" if pgn.playback_errors
    end

    redirect_to match_url(@match.id) if @match
  end

  def auto_complete_for_player_name
    @players = Player.find(:all)
    player_text = @players.inject("") do |txt, p|
      txt << "  <li>#{p.name}</li>\n"
    end
    render :text => "<ul>\n" + player_text + "</ul>"
  end

  private 

  def gameplay
    @gameplay = match.gameplays.send( match.side_of(current_player) )
  end
  helper_method :gameplay

end
