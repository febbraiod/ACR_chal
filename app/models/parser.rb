class Parser < ActiveRecord::Base

  def self.parse(file)
    trades_hash = {}
    rows = []

    CSV.foreach(file.tempfile, headers: true, :header_converters => lambda { |h| h.try(:downcase).tr(" ", "_") }) do |row|
      trade = row.to_hash
      transaction_arr = trade["date|time|account|representation|description|direction|shares|price"].split('|')

      account = transaction_arr[2]
      stock = transaction_arr[3]
      buy_or_sell = transaction_arr[5]
      amount = transaction_arr[6].to_i
      dollars = amount * transaction_arr[7].to_i
      if trades_hash.has_key?(account)
        if trades_hash[account].has_key?(stock)
          if buy_or_sell = 'BUY'
            trades_hash[account][stock]["BUY"]['total_amount'] += amount
            trades_hash[account][stock]["BUY"]['continuing_dollars'] += dollars
          else
            trades_hash[account][stock]["SELL"]['total_amount'] += amount
            trades_hash[account][stock]["SELL"]['continuing_dollars'] += dollars
          end
        else
          trades_hash[account][stock] = {"BUY" => {'total_amount' => 0, 'continuing_dollars' => 0}, "SELL" => {'total_amount' => 0, 'continuing_dollars' => 0}}
          if buy_or_sell = 'BUY'
            trades_hash[account][stock]["BUY"]['total_amount'] += amount
            trades_hash[account][stock]["BUY"]['continuing_dollars'] += dollars
          else
            trades_hash[account][stock]["SELL"]['total_amount'] += amount
            trades_hash[account][stock]["SELL"]['continuing_dollars'] += dollars
          end
        end
      else 
          trades_hash[account] = {stock => {"BUY" => {'total_amount' => 0, 'continuing_dollars' => 0}, "SELL" => {'total_amount' => 0, 'continuing_dollars' => 0}}}
          if buy_or_sell = 'BUY'
            trades_hash[account][stock]["BUY"]['total_amount'] += amount
            trades_hash[account][stock]["BUY"]['continuing_dollars'] += dollars
          else
            trades_hash[account][stock]["SELL"]['total_amount'] += amount
            trades_hash[account][stock]["SELL"]['continuing_dollars'] += dollars
          end
      end
    end
    # r = output_hash(trades_hash)
    binding.pry
  end

  # def output_hash(trades)
  #   result = {}

  #   trades.each do |k, v|

  #   end

  # end

end



# {'a1' => {'stock1_name' => {buys => {total_amount => 12345, continuing_dollars => [last_amount * price, last_amount* price] } }}