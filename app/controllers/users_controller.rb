class UsersController < ApplicationController
  before_action :get_price, :require_user, only: [:show]

  def index
  end

  def show
    @user = User.find(params[:id])
    @quote = Quote.new
    #@quotes = @user.quotes.all

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
    f.title(:text => "График цены портфела")
    f.series(:name => "Цена портфеля", :yAxis => 0, :data => portfolio_price, pointStart: @data.last.trade_date.to_time, pointInterval: 24 * 360 * 10)
    f.yAxis [      {:title => {:text => "Цена портфеля в USD", :margin => 70} }    ]
    #f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    f.chart({:defaultSeriesType=>"column"})
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
    @ans = Array.new(505) {0}
          @array = Array.new
    User.find(params[:id]).quotes.each do |q|

      @data = @yahoo_client.historical_quotes(q.symbol, { start_date: Time::now-(24*60*60*365*2), end_date: Time::now })
      @data.each do |d|
        @array << d.close.to_f * q.quantity
      end
      @array.each_with_index {|e, i| @ans[i] += e}
            @array = Array.new
    end
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
