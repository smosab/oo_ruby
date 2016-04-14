require 'pry'

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    binding.pry
    balance >= 0
  end
end

mybankaccount = BankAccount.new(10000000000)

p mybankaccount.positive_balance?