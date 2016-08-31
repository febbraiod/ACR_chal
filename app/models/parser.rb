class Parser < ActiveRecord::Base

  def self.parse(file)
    trades_hash = {}

    CSV.foreach(file.tempfile, headers: true, :header_converters => lambda { |h| h.try(:downcase).tr(" ", "_") }) do |row|
      trade = row.to_hash
      transaction_arr = trade["date|time|account|representation|description|direction|shares|price"].split('|')

      trades_hash["date"] = transaction_arr[0]
      account = transaction_arr[2]
      stock = transaction_arr[3]
      buy_or_sell = transaction_arr[5]
      amount = transaction_arr[6].to_i
      dollars = amount * transaction_arr[7].to_f

      if trades_hash.has_key?(account)
        if trades_hash[account].has_key?(stock)
          if buy_or_sell == 'BUY'
            trades_hash[account][stock]["BUY"]['total_amount'] += amount
            trades_hash[account][stock]["BUY"]['continuing_dollars'] += dollars
          else
            trades_hash[account][stock]["SELL"]['total_amount'] += amount
            trades_hash[account][stock]["SELL"]['continuing_dollars'] += dollars
          end
        else
          trades_hash[account][stock] = {"BUY" => {'total_amount' => 0, 'continuing_dollars' => 0}, "SELL" => {'total_amount' => 0, 'continuing_dollars' => 0}}
          if buy_or_sell == 'BUY'
            trades_hash[account][stock]["BUY"]['total_amount'] += amount
            trades_hash[account][stock]["BUY"]['continuing_dollars'] += dollars
          else
            trades_hash[account][stock]["SELL"]['total_amount'] += amount
            trades_hash[account][stock]["SELL"]['continuing_dollars'] += dollars
          end
        end
      else 
          trades_hash[account] = {stock => {"BUY" => {'total_amount' => 0, 'continuing_dollars' => 0}, "SELL" => {'total_amount' => 0, 'continuing_dollars' => 0}}}
          if buy_or_sell == 'BUY'
            trades_hash[account][stock]["BUY"]['total_amount'] += amount
            trades_hash[account][stock]["BUY"]['continuing_dollars'] += dollars
          else
            trades_hash[account][stock]["SELL"]['total_amount'] += amount
            trades_hash[account][stock]["SELL"]['continuing_dollars'] += dollars
          end
      end
    end
    self.output_arr(trades_hash)
  end

  def self.output_arr(trades)
    result = ["date|acct|ticker|direction|amount|px"]
    date = trades["date"]
    trades.delete("date")

    trades.each do |k, v|
      trades[k].each do |stock, v|
        vwap_buy = '%.4f' % (v['BUY']['continuing_dollars'].to_f/v['BUY']['total_amount']) unless v['BUY']['total_amount'] == 0
        vwap_sell = '%.4f' % (v['SELL']['continuing_dollars'].to_f/v['SELL']['total_amount']) unless v['SELL']['total_amount'] == 0
        result << "#{date}|#{k}|#{stock}|BUY|#{v['BUY']['total_amount']}|#{vwap_buy}" unless v['BUY']['total_amount'] == 0
        result << "#{date}|#{k}|#{stock}|SELL|#{v['SELL']['total_amount']}|#{vwap_sell}" unless v['SELL']['total_amount'] == 0
      end
    end
    result
  end


end