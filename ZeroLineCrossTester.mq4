//+------------------------------------------------------------------+
//|                                          ZeroLineCrossTester.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict


#include "./CrossEA.mqh"

input string indicator_name = "coppock";
input int indicator_buffer_num = 0;
input int zero_line_value = 0.0;
input int atr_periods = 14;

datetime prevTime;
double open;
double high;
double low;
double close;
double atr;
double indicator;

CrossEA* ea;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   printf("Initializing the Zero Line Cross EA");
   
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
   
      ea.setIndicators(indicator, zero_line_value);
            
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
   indicator = iCustom(Symbol(), 0, indicator_name,indicator_buffer_num, shift);
   
}

//+------------------------------------------------------------------+
