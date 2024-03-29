//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
#property copyright "xiaoxin003"
#property link      "yangjx009@139.com"
#property version   "1.0"
#property strict

#include "CStrategy.mqh";
 
extern int       Input_MagicNumber  = 20191103;    
extern double    Input_Lots         = 0.1;
extern int       Input_intTP        = 0;
extern int       Input_intSL        = 0;
extern string    Memo_TrendTF       = "---trend timeframe default D1---";
extern ENUM_TIMEFRAMES Input_TrendTF      = PERIOD_D1;

extern string    Memo_SignalTF      = "---Signal timeframe default H4---";
extern ENUM_TIMEFRAMES Input_SignalTF     = PERIOD_H4;

extern string    Memo_ChanceTF      = "---Chance timeframe default H1---";
extern ENUM_TIMEFRAMES Input_ChanceTF     = PERIOD_H1;

extern string    Memo_EntryTF      = "---trade entry timeframe default M15---";
extern ENUM_TIMEFRAMES Input_EntryTF     = PERIOD_M15;
      

CStrategy* oCStrategy;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   Print("begin");
   if(oCStrategy == NULL){
      oCStrategy = new CStrategy(Input_MagicNumber,Input_TrendTF,Input_SignalTF,Input_ChanceTF, Input_EntryTF);
   }
   oCStrategy.Init(Input_Lots,Input_intTP,Input_intSL);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("deinit");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
{
   oCStrategy.Tick();
   subPrintDetails();
}


void subPrintDetails()
{
   //
   string sComment   = "";
   string sp         = "----------------------------------------\n";
   string NL         = "\n";

   sComment = sp;
   sComment = sComment + "Trend = " + oCStrategy.getTrend() + NL; 
   sComment = sComment + sp;
   //sComment = sComment + "TotalItemsActive = " + oCOrder.TotalItemsActive() + NL; 
   sComment = sComment + sp;
   //sComment = sComment + "Lots=" + DoubleToStr(Lots,2) + NL;
   Comment(sComment);
}


