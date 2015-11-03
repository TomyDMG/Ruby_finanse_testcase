class QuotesController < ApplicationController

def create
  @yahoo_client = YahooFinance::Client.new
  @quote = current_user.quotes.build(quotes_params)
  @quote.symbol.upcase!
  if @yahoo_client.quotes([@quote.symbol], [:name])[0].name != "N/A"
    if @quote.save
      flash[:success] = "Акция добавлена в портфель."
      redirect_to current_user
    else
      flash[:alert] = "Ошибка"
      redirect_to current_user
    end
  else
    flash[:alert] = "Несуществующая котировка"
    redirect_to current_user
  end
end

def edit
  @quote = Quote.find_by_id(params[:id])
end

def update
  @quote = Quote.find_by_id(params[:id]).update(quotes_params)
  flash[:success] = "Successfully updated..."
  redirect_to current_user
end

def destroy
  @quote = current_user.quotes.find_by_id(params[:id]).destroy
  redirect_to current_user
end

private

def quotes_params
  params.require(:quote).permit(:symbol, :quantity)
end


end
