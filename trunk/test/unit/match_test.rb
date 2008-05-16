require File.dirname(__FILE__) + '/../test_helper'

class MatchTest < ActiveSupport::TestCase
	# Replace this with your real tests.
	def test_truth
		assert true
	end
			
	def test_knows_what_side_player_is_on
		m1 = matches(:paul_vs_dean)
		assert_equal players(:paul).id, m1.player1.id
		assert_equal players(:dean).id, m1.player2.id
		
		assert_equal :white, m1.side_of( players(:paul) )
		assert_equal :black, m1.side_of( players(:dean) )
		
	end

	def test_can_invite_anyone_to_match
	end

	def test_can_invite_as_white_or_black
	end

	def test_player_can_resign
		#player1
		m1 = matches(:paul_vs_dean)
		m1.resign( players(:paul) )
		m1.save!
		assert_not_nil m1.winning_player
		assert_equal players(:dean), m1.winning_player

		#player2
		m2 = matches(:dean_vs_maria)
		m2.resign( m2.player2 )
		m2.save!

		m3 = matches(:dean_vs_maria)
		assert_not_nil m3.winning_player
		assert_equal players(:dean), m3.winning_player
	end

	def test_player_can_claim_win
	end

	def test_opponent_can_deny_win
	end

	def test_opponent_can_acknowledge_win
	end


end