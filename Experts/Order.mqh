//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "./Position.mqh"
#include "./Candle.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


class Order
  {
private:
   Position position;
   double price;
   double tp;
   double sl;
public:
   Order(Position pos, double orderPrice, double takeProfit, double stopLoss);
   Order();
   ~Order();
   
   Position getPositionSide(void);
   double getPrice(void);
   double getTakeProfitLevel(void);
   double getStopLossLevel(void);
   bool reachedStopLoss(Candle& candleVal);
   bool reachedTakeProfit(Candle& candleVal);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Order::Order(Position positionSide, double orderPrice, double takeProfit, double stopLoss)
  {
   position = positionSide;
   price = orderPrice;
   tp = takeProfit;
   sl = stopLoss;
  }
  
 Order::Order(void){
   position = NEUTRAL;
   tp = DBL_MAX;
   sl = DBL_MIN;
 }
  
 Position Order::getPositionSide(void){
   return position;
 }
 
 double Order::getPrice(void){
   return price;
 }
 
 double Order::getTakeProfitLevel(void){
   return tp;
 }
 
 double Order::getStopLossLevel(void){
   return sl;
 }
 
 bool Order::reachedStopLoss(Candle& candleVal){
 
   if(position == NEUTRAL){
      return false;
   }
 
   if(position == LONG){
      return sl >= candleVal.getLow();
   }
   
   if(position == SHORT){
      return sl <= candleVal.getHigh();
   }
   
   return false;
 }
 
 bool Order::reachedTakeProfit(Candle& candleVal){
   
   if(position == NEUTRAL){
      return false;
   }
 
   if(position == LONG){
      return candleVal.getHigh() >= tp;
   }
   
   if(position == SHORT){
      return candleVal.getLow() <= tp;
   }
 
   return false;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Order::~Order()
  {
  }
//+------------------------------------------------------------------+
