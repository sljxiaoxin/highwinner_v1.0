//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015    |
//|                                              yangjx009@139.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"


#include "base\CMacd.mqh";
#include "base\CLaguerreRsi.mqh";

#include "util\CDrawLine.mqh";
#include "util\CDrawRect.mqh";
#include "util\CDrawArrow.mqh";


#include "trade\CTrade.mqh";
#include "trade\CTicket.mqh";
#include "trade\CTrend.mqh";
#include "trade\CSignal.mqh";
#include "trade\CChance.mqh";

class CStrategy
{  
   private:
     datetime CheckTimeTrend;
     datetime CheckTimeSignal;
     datetime CheckTimeChance;
     datetime CheckTimeEntry; 
     double   Lots;
     int      Tp;
     int      Sl;
     int      TrendTF;
     int      SignalTF;
     int      ChanceTF;
     int      EntryTF;
     
     CTrade* oCTrade;
     
     CLaguerreRsi* oCLRsi_Trend;
     CMacd* oMacdMain_Trend;
     CTrend* oCTrend;
     
     CLaguerreRsi* oCLRsi_Signal;
     CMacd* oMacdMain_Signal;
     CMacd* oMacdSignal_Signal;
     CSignal* oCSignal;
     
     CLaguerreRsi* oCLRsi_Chance;
     CMacd* oMacdMain_Chance;
     CMacd* oMacdSignal_Chance;
     CChance* oCChance;
     
     CLaguerreRsi* oCLRsi_Entry;
     CMacd* oMacdMain_Entry;
     CMacd* oMacdSignal_Entry;
     
     
    
     void Update();
     void GetTrend();
     void OnTrendChange(); //trend change callback
     
     
     
     
   public:
      
      CStrategy(int Magic, int Input_TrendTF, int Input_SignalTF,int Input_ChanceTF, int Input_EntryTF){
         TrendTF  = Input_TrendTF;
         SignalTF = Input_SignalTF;
         ChanceTF = Input_ChanceTF;
         EntryTF  = Input_EntryTF;
         
         oCTrade        = new CTrade(Magic);
         
         oCLRsi_Trend = new CLaguerreRsi(TrendTF,0);
         oMacdMain_Trend = new CMacd(TrendTF,MODE_MAIN);
         
         oCLRsi_Signal = new CLaguerreRsi(SignalTF,0);
         oMacdMain_Signal = new CMacd(SignalTF,MODE_MAIN);
         oMacdSignal_Signal = new CMacd(SignalTF,MODE_SIGNAL);
         
         oCLRsi_Chance = new CLaguerreRsi(ChanceTF,0);
         oMacdMain_Chance = new CMacd(ChanceTF,MODE_MAIN);
         oMacdSignal_Chance = new CMacd(ChanceTF,MODE_SIGNAL);
         
         oCLRsi_Entry = new CLaguerreRsi(EntryTF,0);
         oMacdMain_Entry = new CMacd(EntryTF,MODE_MAIN);
         oMacdSignal_Entry = new CMacd(EntryTF,MODE_SIGNAL);
        
         oCTrend = new CTrend(TrendTF, oCLRsi_Trend, oMacdMain_Trend);
         oCSignal = new CSignal(SignalTF,oCTrend,oCLRsi_Signal,oMacdMain_Signal,oMacdSignal_Signal);
         oCChance = new CChance(ChanceTF,oCTrend,oCSignal,oCLRsi_Chance,oMacdMain_Chance,oMacdSignal_Chance);
         
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      void Entry();
      void Exit();
      void CheckOpen();
      string getTrend();
      
};

void CStrategy::Init(double _lots, int _tp, int _sl)
{
   Lots = _lots;
   Tp = _tp;
   Sl = _sl;
}

void CStrategy::Tick(void)
{  
    
    //every M15
    if(CheckTimeEntry != iTime(NULL,EntryTF,0)){
         CheckTimeEntry = iTime(NULL,EntryTF,0);
         this.Update();
         Entry();
         oCTrend.TickDrawMove(EntryTF);
         oCChance.TickDrawMove(EntryTF);
    }
    
    //every H1
    if(CheckTimeChance != iTime(NULL,ChanceTF,0)){
         CheckTimeChance = iTime(NULL,ChanceTF,0);
         oCSignal.TickIdxPass();
         oCChance.Tick();
    }
    
    //every H4
    if(CheckTimeSignal != iTime(NULL,SignalTF,0)){
         CheckTimeSignal = iTime(NULL,SignalTF,0);
         oCSignal.Tick();
    }
    
    //every D1
    if(CheckTimeTrend != iTime(NULL,TrendTF,0)){
         CheckTimeTrend = iTime(NULL,TrendTF,0);
         oCTrend.Tick();
    }
   // CheckOpen();
}



void CStrategy::Update()
{
   oCLRsi_Trend.Fill();
   oMacdMain_Trend.Fill();
   
   oMacdMain_Signal.Fill();
   oCLRsi_Signal.Fill();
   oMacdSignal_Signal.Fill();
   
   oMacdMain_Chance.Fill();
   oCLRsi_Chance.Fill();
   oMacdSignal_Chance.Fill();
   
   oCLRsi_Entry.Fill();
   oMacdMain_Entry.Fill();
   oMacdSignal_Entry.Fill();
}

string CStrategy::getTrend()
{
   return oCTrend.GetTrend();
}

void CStrategy::GetTrend()
{

   
}


void CStrategy::OnTrendChange()
{
   
}


void CStrategy::Exit()
{
   
}

void CStrategy::Entry()
{
   
   bool isChance = oCChance.GetChance();
   if(isChance){
      string t = oCTrend.GetTrend();
      if(t=="long"){
         
         if(oMacdMain_Entry.data[1] > oMacdSignal_Entry.data[1]){
            if(oCLRsi_Entry.data[2] <=0.15 && oCLRsi_Entry.data[1]>0.15 && oCLRsi_Entry.LowValue(0,4) ==0){
               CDrawArrow::ArrowUp(TimeCurrent(),Low[1]-18*oCTrade.GetPip());
            }
         }
      }
      if(t == "short"){
         
         if(oMacdMain_Entry.data[1] < oMacdSignal_Entry.data[1]){
            if(oCLRsi_Entry.data[2] >=0.85 && oCLRsi_Entry.data[1]<0.85 && oCLRsi_Entry.HighValue(0,4) ==1){
               CDrawArrow::ArrowDown(TimeCurrent(),High[1]+18*oCTrade.GetPip());
            }
         }
      }
   }
}