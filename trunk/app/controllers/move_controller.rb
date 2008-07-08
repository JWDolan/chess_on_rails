class MoveController < ApplicationController

	rescue_from ArgumentError, :with => :display_error
	
	before_filter :authorize

	#accessible via get or post but should be idempotent on 2x get
	def create
		@match = Match.find( params[:move][:match_id] )
		@move  = @match.moves.new( params[:move] )

		#invoke validation - todo fit this into AR life cycle better
		@move.valid?


		#todo - move into models, based on side of piece being moved
		unless @match && @match.turn_of?( @current_player )
		  raise ArgumentError, "It's not your turn to move on match #{@move.match_id}, #{@current_player.name}" 
		end

		@move.save! #not implicit save like appending << to association

		#if they got the other guy on this move 
		#todo - more model-esque - possibly decommissioning this controller and working just with match
		if @match.reload.board.in_checkmate?( @current_player == @match.player1 ? :black : :white )
			@move.match.winning_player = @current_player
			@move.match.result = 'Checkmate'
			@move.match.active = 0
			@move.match.save

			redirect_to( :controller => 'match', :action => 'index' ) and return
		end

		redirect_to(:back) # this is not yet ajaxian, and no template's been written yet
	end

	def display_error(ex)
		flash[:move_error] = ex.to_s
		redirect_to(:back)
	end
end
