class ExpensesController < ApplicationController

  # def add_expense
  #   binding.pry
  # end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to @expense.trading_day
  end

end
