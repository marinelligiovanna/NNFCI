//+------------------------------------------------------------------+
//|                                         ChartIndicatorTestEA.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "IndicatorTestEA.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ChartIndicatorTestEA : public IndicatorTestEA
  {
protected:
   string getName(){
      return "[Chart Indicator EA]";
   }
   
   void calculatePosition(){
      prevPosition = position;
      position = longInd != EMPTY_VALUE && shortInd == EMPTY_VALUE ? 
            LONG : 
            (longInd == EMPTY_VALUE && shortInd != EMPTY_VALUE
               ? SHORT 
               : position);

   }
   
public:
   ChartIndicatorTestEA() : IndicatorTestEA(){};
  };


//+------------------------------------------------------------------+
