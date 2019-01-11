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

  def add_expense
    @trading_day = TradingDay.find(expense_params[:trading_day_id])
    @expense = Expense.create(expense_params)
    if @expense.id.present?
      redirect_to @trading_day, notice: 'Расход успешно добавлен.'
    else
      redirect_to @trading_day, notice: 'Неверно введены данные расхода.'
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:sum, :comment, :trading_day_id, :user_id)
  end

end
