class Player < ActiveRecord::Base
  
  validates_length_of :name, :maximum=>20
  validates_uniqueness_of :name

  belongs_to :user

  has_many  :matches, :class_name=>"Match",
    :finder_sql=>'SELECT matches.* FROM matches WHERE ( player1 = #{id} OR player2= #{id} )'

  has_many :active_matches, :class_name=>"Match",
    :finder_sql=>'SELECT matches.* FROM matches WHERE ( player1 = #{id} OR player2= #{id} ) AND active=1'

  has_many :completed_matches, :class_name=>"Match",
    :finder_sql=>'SELECT matches.* FROM matches WHERE ( player1 = #{id} OR player2= #{id} ) AND active=0'

end
