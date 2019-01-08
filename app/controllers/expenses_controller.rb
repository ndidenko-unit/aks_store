class ExpensesController < ApplicationController

  def destroy
    @expense = Expense.find(params[:id])
    if @expense.trading_day.close?
      redirect_to @expense.trading_day, notice: 'Торговый день закрыт'
    else
      @expense.destroy
      redirect_to @expense.trading_day, notice: 'Расход успешно удален'
    end
  end

end
