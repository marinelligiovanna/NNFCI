# Confirmation Indicator Testers

This project was developed to test trend confirmation indicators at the MetaTrader 4 platform. It contains three Experts Advisors to test the following three main types of trend indicators, as described at [this post](https://nononsenseforex.com/indicators/forex-trend-indicators/) of the No Nonsense Forex blog:

1. Zero Line Cross
2. Two Lines Cross
3. Chart Indicators

Its main use is to calculate the win rate of a trend indicator according the following decision rule:

* Each Expert Advisor (EA) checks for a new Buy or Sell signal from the indicator at the end of each candle.
* If a new signal is received, the EA simulates a new order sent at the close price of the candle.
* Each order has a Stop Loss Level of 1.5 x ATR and a Take Profit Level of 1 x ATR.
* If there is an order open at the time that the indicator sends an opposite signal, the previous order is close and a loss or a gain is counted.
* If the price reaches the Stop Loss (or Take Profit) level, a new loss (or win) is counted, the order is closed and the EA waits for a new signal from the indicator.

The result will be print on Journal of the Strategy Tester Window. No report will be generated since no real order is send by the EA. These experts must only be used to rank the best trend indicators according its win rates. 

## How to use

Clone this project at the Experts folder of your MQL4 directory. On Windows, it is usually on the following folder:

`C:\Users\user\AppData\Roaming\MetaQuotes\Terminal\[Account Code]\MQL4\Experts`

On the MetaEditor, compile each .mq4 file to generate an .ex file. The Expert Advisors will be avaible for testing at the MT4 Strategy Tester window.

Note that all the tested indicators must be on the root of the Indicators directory:

`C:\Users\user\AppData\Roaming\MetaQuotes\Terminal\[Account Code]\MQL4\Indicators`

## Improvements

Unfortunately you will have to change the iCustom call on each .mq4 file in order to be able to test your indicator with custom parameters. I've not found a good way to receive indicator parameters as input, since each indicator has a different number and type of parameters.
