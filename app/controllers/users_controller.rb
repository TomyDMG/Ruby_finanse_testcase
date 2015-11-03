class UsersController < ApplicationController
  before_action :get_price, :require_user, only: [:show]

  def index
  end

  def show
    @user = User.find(params[:id])
    @quote = Quote.new
    #@quotes = @user.quotes.all
    if @user.quotes.any?
    @chart = LazyHighCharts::HighChart.new('StockChart') do |f|
    f.title(:text => "График цены портфела")
    f.rangeSelector(selected: 1)
    f.series(:name => "Цена портфеля",  :data => portfolio_price)
    f.yAxis [      {:title => {:text => "Цена портфеля в USD", :margin => 70} }    ]
    #f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    f.chart({:defaultSeriesType=>"line"})
    end
  end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/'
    end
  end


  def portfolio_price
    @ans = Array.new(504) {0}
    @dates = Array.new
    @array = Array.new
    User.find(params[:id]).quotes.each do |q|
      @data = @yahoo_client.historical_quotes(q.symbol, { start_date: Time::now-(24*60*60*365*2), end_date: Time::now })
      @data.each do |d|
        @array << d.close.to_f * q.quantity
      end
      @array.each_with_index {|e, i| @ans[i] += e}
      @array = Array.new
    end
    @data.each {|d| @dates << d.trade_date.to_time.to_i * 1000 + 86400000}
    @ans.each_with_index {|e, i| @ans[i] = [@dates[i], e]}
    return @ans.reverse
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def get_price
    @yahoo_client = YahooFinance::Client.new
    @quotes = User.find(params[:id]).quotes.each do |q|
      q.price = @yahoo_client.quotes([q.symbol], [:ask])[0].ask.to_f
    end
  end

end
