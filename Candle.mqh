//+------------------------------------------------------------------+
//|                                                       Candle.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Candle
  {
private:
   double open;
   double high;
   double low;
   double close;
public:
   Candle(double openVal, double highVal, double lowVal, double closeVal);
   Candle(void);
   double getOpen(void);
   double getHigh(void);
   double getLow(void);
   double getClose(void);
   void set(double openVal, double highVal, double lowVal, double  closeVal);
   ~Candle();
  };
  
 Candle::Candle(){
   
 }
  
 Candle::Candle(double openVal,double highVal,double lowVal, double closeVal ){
   set(openVal, highVal, lowVal, closeVal);
 }
 
 Candle::set(double openVal,double highVal,double lowVal,double closeVal){
   open = openVal;
   high = highVal;
   low = lowVal;
   close = closeVal;
 }
 
double Candle::getOpen(void){
   return open;
}

double Candle::getHigh(void){
   return high;
}

double Candle::getLow(void){
   return low;
}

double Candle::getClose(void){
   return close;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Candle::~Candle()
  {
  }
//+------------------------------------------------------------------+
