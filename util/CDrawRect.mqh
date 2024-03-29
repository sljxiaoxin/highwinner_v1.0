//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDrawRect
{  

   private:
      string code;   //代号
      int index;
      string trend;
      string prefix;
      int rectIdx;
      int tf;
      int charID;
      int sub_window;
      string name;
      datetime timeBegin;
      /*
      static int s_index;
      static int s_rectindex;
      static string s_prefix;
      static string s_trend;
      */
   
   public:
      CDrawRect(string _code, int _tf){
         code = _code;
         index = 0;
         trend = "none";
         prefix = "Rect_";
         rectIdx = 0;
         tf = _tf;
         charID = 0;
         sub_window = 0;
      };
      
      bool CreateLong();
      bool CreateShort();
      bool Move(int drawTf);
      void End();
};

bool CDrawRect::CreateLong(){
   color clr = clrYellow;
   trend = "long"; 
   index += 1;
   name = prefix+code+index;
   int width = 1;
   datetime time1 = TimeCurrent();
   double price1 = iLow(NULL,tf,1);
   datetime time2 = TimeCurrent();
   double price2 = iHigh(NULL,tf,1);
   timeBegin = time1;

   if(!ObjectCreate(charID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
   {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(charID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(charID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(charID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(charID,name,OBJPROP_FILL,true);
   ObjectSetInteger(charID,name,OBJPROP_BACK,true);
   ObjectSetInteger(charID,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(charID,name,OBJPROP_SELECTED,true);
   //--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(charID,name,OBJPROP_HIDDEN,true);
   return true;
}

bool CDrawRect::CreateShort()
{
   color clr = clrBlue;
   trend = "short"; 
   index += 1;
   name = prefix+code+index;
   int width = 1;
   datetime time1 = TimeCurrent();
   double price1 = iHigh(NULL,tf,1);
   datetime time2 = TimeCurrent();
   double price2 = iLow(NULL,tf,1);
   timeBegin = time1;
   
   if(!ObjectCreate(charID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
   {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(charID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(charID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(charID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(charID,name,OBJPROP_FILL,true);
   ObjectSetInteger(charID,name,OBJPROP_BACK,true);
   ObjectSetInteger(charID,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(charID,name,OBJPROP_SELECTED,true);
   //--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(charID,name,OBJPROP_HIDDEN,true);
   return true;
}

bool CDrawRect::Move(int drawTf)
{
   if(trend == "none"){
      return false;
   }
   rectIdx += 1;
   int point_index = 1;  //0第一个点
   double price;
   int h,l;
   if(trend == "long"){
      h = iHighest(NULL,drawTf,MODE_HIGH,rectIdx,0);
      price = iHigh(NULL,drawTf,h);
      
      if(!ObjectMove(charID,name,1,TimeCurrent(),price))
      {
         Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
      }
      
      l = iLowest(NULL,drawTf,MODE_LOW,rectIdx,0);
      price = iLow(NULL,drawTf,l);
      if(!ObjectMove(charID,name,0,timeBegin,price))
      {
         Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
      }
   }
   if(trend == "short"){
      l = iLowest(NULL,drawTf,MODE_LOW,rectIdx,0);
      double price = iLow(NULL,drawTf,l);
      if(!ObjectMove(charID,name,1,TimeCurrent(),price))
      {
         Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
      }
      
      h = iHighest(NULL,drawTf,MODE_HIGH,rectIdx,0);
      double price = iHigh(NULL,drawTf,h);
      if(!ObjectMove(charID,name,0,timeBegin,price))
      {
         Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
      }
   }
   
   return(true);
}

void CDrawRect::End(void)
{
   trend = "none";
   rectIdx = 0;
}
