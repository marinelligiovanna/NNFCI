//+------------------------------------------------------------------+
//|                                               CrossEA.mqh |
//|   Copyright 2019, MetaQuotes Software Corp. |
//|                                   https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "./Order.mqh"
#include "./Position.mqh"
#include "./Candle.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CrossEA
  {
private:
   Position prevPosition;     // The previous position 
   Position position;            // The current position (LONG, NEUTRAL or SHORT)
   Order* order;                  // Represent an open order.
   Candle* candle;              // The current candle value
   double longInd;               // Value of the indicator line that indicates long (longInd > shortInd = LONG)    
   double shortInd;              // Value of the indicator line that indicates short. On zero cross indicators, it is the zero line. (longInd < shortInd = SHORT)
   double losses;                // Num. of times that the price reached the SL 
   double wins;                   // Num. of times that the price reached the TP
   int numTrades;                // Num. of trades. Used mostly to create arrows to identify buy or sells on chart.
   
   void alert(string msg);
   void resetOrder(void);
   void countLoss(void);
   void countWin(void);
 
public:
   CrossEA();
   ~CrossEA();
   void setCandle(double openVal, double highVal, double lowVal, double closeVal);
   void checkSLandTP(void);
   void setIndicators(double longIndVal,double shortIndVal);
   bool mustSendOrder();
   void sendOrder(double atrIndVal, double closePriceVal);
   double getWinRate(void);
   double getLosses(void);
   double getWins(void);
   void showTestResult(void);
  };
  
CrossEA::CrossEA()
  {
   position = NEUTRAL;
   losses=0;
   wins = 0;
   order = new Order();
   candle = new Candle();
   numTrades = 0;
  }
  
//Sets the value of the candle object. The candle is mainly used for checking if the stop loss or
// take profit levels has been reached.
CrossEA::setCandle(double openVal, double highVal, double lowVal, double closeVal){
   candle.set(openVal, highVal, lowVal, closeVal);
   checkSLandTP();
 }


// Check if the stop loss or take profit levels has been reached.
CrossEA::checkSLandTP(void){

   if(order.reachedStopLoss(candle)){
      resetOrder();
      countLoss();
      alert("The price has reached the SL level! The current win rate is " + (string) getWinRate());
   }
   
   if(order.reachedTakeProfit(candle)){
      resetOrder();
      countWin();
      alert("The price has reached the TP level! The current win rate is " + (string) getWinRate());
   }
}
 
// Sets the value of the long and short indicators and calculate the
// the position according the indicators value  
void CrossEA::setIndicators(double longIndVal,double shortIndVal){
   
   longInd = longIndVal;
   shortInd = shortIndVal;
   
   // Keep the previous and current position position to know if we must send a new order.
   prevPosition = position;
   position = longInd > shortInd ? 
            LONG : 
            (longInd < shortInd 
               ? SHORT 
               : position);
}

// Creates a new order object
void CrossEA::resetOrder(void){
   delete order;
   order = new Order();
}

// Count a loss if the price reaches the SL level.
void CrossEA::countLoss(void){
   losses+=1.0;
}

// Count a win if the price reaches the TP level.
void CrossEA::countWin(void){
   wins+=1.0;
}

// Checks if the EA must send a new order by comparing the previous
// position side with the current one.
bool CrossEA::mustSendOrder(void){
   return prevPosition != position;
 }
 
// Creates a new order @closePriceVal setting the TP and SL value
// using the ATR.
void CrossEA::sendOrder(double atrIndVal, double closePriceVal){
 
   double atrSl = 1.5 * atrIndVal;
   double atrTp = 1.0 * atrIndVal;
   double sl = DBL_MIN;
   double tp = DBL_MAX;
   
   if(position == LONG){
      sl = closePriceVal - atrSl;
      tp = closePriceVal + atrTp;
         
      alert("I am sending a BUY order @ " + (string) closePriceVal + ". The SL level is Price - 1.5xATR = " + (string) sl + " and a TP level is Price + 1.0xATR = " + (string) tp); 
      ObjectCreate(0,"Buy point - " + (string)numTrades,OBJ_ARROW_BUY,0,TimeCurrent(),closePriceVal);               
   }
   else if(position == SHORT){
      sl = closePriceVal + atrSl;
      tp = closePriceVal - atrTp;
      
      alert("I am sending a SELL order @ " + (string) closePriceVal + ". The SL level is Price + 1.5xATR = " + (string) sl + " and a TP level is Price - 1.0xATR = " + (string) tp);
      ObjectCreate(0,"Sell point"+ (string)numTrades,OBJ_ARROW_SELL,0,TimeCurrent(),closePriceVal);   
   }
   
   if(position != NEUTRAL){
      order = new Order(position, closePriceVal, tp, sl);
      numTrades++;
   }
}

// Calculates and return the EA win rate.
double CrossEA::getWinRate(void){
   if(wins == 0 && losses == 0) return 0.0;
   
   return wins/(losses+wins);
}

double CrossEA::getLosses(void){
   return losses;
}

double CrossEA::getWins(void){
   return wins;
}

// Send a new message on Journal
CrossEA::alert(string msg){
   printf("[CrossEA] " + msg);
}

CrossEA::showTestResult(void) {
   string percentWin = DoubleToStr(getWinRate(), 2);
   
   printf((string)wins + ";" + (string)losses +";" + percentWin);
   printf("Put this on your sheet for colums Wins,Losses,%Wins");
   printf("Test is over. The result was: wins: " +(string)wins + " losses: " + (string)losses+ "  %win: "  + (string) percentWin); 
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CrossEA::~CrossEA()
  {
   delete candle;
   delete order;
  }
//+------------------------------------------------------------------+
