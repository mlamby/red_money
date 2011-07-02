require 'test/unit'
require 'red_money'

include RedMoney

class ParamClass
  include HasParameters

  parameter :one, 1
  parameter :two, 2

  def sum
    self.one + self.two
  end
end

class HasParametersTest < Test::Unit::TestCase

  def test_defaults
    p = ParamClass.new
    assert_equal 1, p.one
    assert_equal 2, p.two
    assert_equal 3, p.sum
  end
  
  def test_setter
    p = ParamClass.new
    p.one = 3
    p.two = 4
    
    assert_equal 3, p.one
    assert_equal 4, p.two
    assert_equal 7, p.sum
  end
end
