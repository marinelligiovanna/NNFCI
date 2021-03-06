//+------------------------------------------------------------------+
//|                                          TwoLinesCrossTester.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#define INDICATORS_PATH "../Indicators/"

#include "../Include/CrossEA.mqh"

input string indicator_name = "Trend";
input int long_buffer_num = 0;
input int short_buffer_num = 1;
input int atr_periods = 14;

datetime prevTime;
double open;
double high;
double low;
double close;
double atr;
double longInd;
double shortInd;

CrossEA* ea;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   printf("Initializing the Two Lines Cross EA");
   
   ea = new CrossEA();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ea.showTestResult();
   delete ea;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
   // Initialize candle and indicators with the values of the
   // previous candle close (shift = 1)
   if(prevTime == NULL){
      setValues(1);
   } 
     
   // Only open position at the open of the next candle (Aprox. close of the prev candle)
   if(prevTime != Time[0]){
   
      ea.setIndicators(longInd, shortInd);
            
      if(ea.mustSendOrder()){
         ea.closeOrder();
         ea.sendNewOrder(atr, close);
      }
         
     prevTime = Time[0];
   }
   
   // Set values of indicators and candle and check if the order has reached
   // the SL or TP levels. 
   setValues(0);
   ea.checkSLandTP();
      
  }

void setValues(int shift){
   
   open = iOpen(Symbol(),0,shift);
   high = iHigh(Symbol(), 0, shift);
   low = iLow(Symbol(), 0, shift);
   close = iClose(Symbol(), 0, shift);
   
   // Set candle values on EA
   ea.setCandle(open, high, low, close);
   
   // Set indicators
   atr = iATR(Symbol(), 0, atr_periods, shift); 
   longInd = iCustom(Symbol(), 0, INDICATORS_PATH + indicator_name,long_buffer_num, shift);
   shortInd = iCustom(Symbol(), 0, INDICATORS_PATH + indicator_name,short_buffer_num, shift);
   
}

//+------------------------------------------------------------------+
