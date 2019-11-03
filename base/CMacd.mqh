//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CMacd
{  
   private:
     int modeLine;
     int tf;
     
   public:
      double data[50];
      
      //MODE_MAIN  MODE_SIGNAL
      CMacd(int _tf, int _modeLine){
         tf = _tf;
         modeLine = _modeLine;
         
         Fill();
      };
      
      void Fill();
      bool IsUp();
      bool IsDown();
      double HighValue(int counts); 
      double LowValue(int counts);
      double Distance(int counts);
};

void CMacd::Fill()
{
   for(int i=0;i<50;i++){ 
      data[i] = iMACD(NULL,tf,12,26,9,PRICE_CLOSE,modeLine,i);
   }
}

bool CMacd::IsUp()
{
   if(data[1] > data[2] && data[2]>=data[3]){
      return true;
   }
   return false;
}

bool CMacd::IsDown()
{
   if(data[1] < data[2] && data[2]<=data[3]){
      return true;
   }
   return false;
}

double CMacd::HighValue(int counts)
{
   double h = -1;
   for(int i=1;i<counts;i++){ 
      if(data[i] > h){
         h = data[i];
      }
   }
   return h;
}

double CMacd::LowValue(int counts)
{
   double l = 9999999;
   for(int i=1;i<counts;i++){ 
      if(data[i] < l){
         l = data[i];
      }
   }
   return l;
}

double CMacd::Distance(int counts)
{
   double h = this.HighValue(counts);
   double l = this.LowValue(counts);
   return h - l;
}